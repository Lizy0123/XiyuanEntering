//
//  MyImgPickerView.m
//  MyImgPickerView
//
//  Created by Lzy on 2018/1/15.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "MyImgPickerView.h"

#import "MyImgPicker.h"
#import "MyImgPickerCCell.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"

#import "TZImagePickerController.h"
#import "MWPhotoBrowser.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


#import "MyCameraViewController.h"
#import "MyCameraToolBar.h"

#pragma mark - MyActionSheetView
@interface MyActionSheetView ()
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) UIView * btnBgView;
@property (nonatomic, assign,getter = isShow) BOOL show;

@end

@implementation MyActionSheetView
- (instancetype)initWithTitleArray:(NSArray *)titleArr andShowCancel:(BOOL)show{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.titleArr  = titleArr; self.show = show;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheet)];
        [self addGestureRecognizer:tap];
        [self configUI];
    }
    return self;
}
- (void)configUI{
    CGFloat CellHeight = 50.f;
    CGFloat CellSpace = 5.0f;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat bgHeight;
    if (self.isShow) {
        bgHeight =  CellHeight * self.titleArr.count + (CellHeight + CellSpace);
    }else{
        bgHeight  = CellHeight * self.titleArr.count;
    }
    self.btnBgView.frame = CGRectMake(0, size.height, size.width ,bgHeight);
    [self addSubview:self.btnBgView];
    
    CGFloat bgWidth = self.btnBgView.frame.size.width;
    UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 0;
    btn.frame = CGRectMake(0, bgHeight - CellHeight, bgWidth, CellHeight);
    UIImage * highLightImage = [self imageWithColor:[UIColor groupTableViewBackgroundColor] size:CGSizeMake(bgWidth, CellHeight)];
    [btn setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    [self.btnBgView addSubview:btn];
    
    btn.hidden = !self.isShow;
    
    for (int i = 0 ; i < self.titleArr.count; i++) {
        CGFloat btnX = 0;
        CGFloat btnY;
        if (self.isShow) {
            btnY = (bgHeight - CellHeight - CellSpace)  - CellHeight*(i+1);
        }else{
            btnY = bgHeight - CellHeight*(i+1);
        }
        CGFloat btnW = bgWidth;
        CGFloat btnH = CellHeight - 0.5f;
        
        UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag   = i+1;
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBgView addSubview:btn];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)show{
    CGSize size = [UIScreen mainScreen].bounds.size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.btnBgView.frame;
        frame.origin.y =  size.height - frame.size.height;
        self.btnBgView.frame = frame;
    }];
}

- (void)btnClickAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetView:clickButtonAtIndex:)]) {
        [self.delegate actionSheetView:self clickButtonAtIndex:btn.tag];
    }
    if (self.ClickIndex) {
        self.ClickIndex(btn.tag);
    }
    [self hiddenSheet];
}

- (void)hiddenSheet {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.btnBgView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.btnBgView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)btnBgView{
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc]init];
        _btnBgView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    }
    return _btnBgView;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end


#pragma mark - MyImgPickerView

static NSInteger countOfRow;
@interface MyImgPickerView ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)UIView *coverImgView;

@property (nonatomic, copy) MyImgPickerHeightBlock block;
@property (nonatomic, copy) MySelectImgBackBlock backBlock;
/** 总的媒体数组 */
@property (nonatomic, strong) NSMutableArray *mediaArray;

/** 记录从相册中已选的Image Asset */
@property (nonatomic, strong) NSMutableArray *selectedImageAssets;

/** 记录从相册中已选的Image model */
@property (nonatomic, strong) NSMutableArray *selectedImageModels;

/** 记录从相册中已选的Video model*/
@property (nonatomic, strong) NSMutableArray *selectedVideoModels;

/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation MyImgPickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UIScreen mainScreen].bounds.size.width/4);
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault{
    _mediaArray = [NSMutableArray array];
    _preShowMedias = [NSMutableArray array];
    _selectedImageAssets = [NSMutableArray array];
    _selectedVideoModels = [NSMutableArray array];
    _selectedImageModels = [NSMutableArray array];
    _type = MyImgType_PhotoAndCamera;
    _showDelete = YES;
    _showAddButton = YES;
    _allowMultipleSelection = YES;    
    _maxImageSelected = 9;
    _backgroundColor = [UIColor whiteColor];
    [self configCollectionView];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.frame.size.width/countOfRow, self.frame.size.width/countOfRow);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[MyImgPickerCCell class] forCellWithReuseIdentifier:NSStringFromClass([MyImgPickerCCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = _backgroundColor;
    [self addSubview:_collectionView];
    [self configCoverImg];
}
#pragma mark - LzyCoverView
#define kCoverBtnWidth 70
-(void)configCoverImg{
    if (!self.coverImgView) {
        UIView *backView = [[UIView alloc] initWithFrame:self.collectionView.frame];
        [self addSubview:backView];
        self.coverImgView = backView;
        
        UIImageView *coverImgView = [[UIImageView alloc] init];
        coverImgView = [[UIImageView alloc] initWithFrame:backView.frame];
        coverImgView.backgroundColor = [UIColor whiteColor];
        coverImgView.userInteractionEnabled = YES;
        //        [coverImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImgClick:)]];
        [backView addSubview:coverImgView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){CGPointMake(backView.frame.size.width/2 - kCoverBtnWidth/2, (backView.frame.size.height/2 - kCoverBtnWidth/2)),CGSizeMake(kCoverBtnWidth, kCoverBtnWidth)};
        [btn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = kCoverBtnWidth/2;
        [btn.layer setBorderWidth:2];
        [btn.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
        
        [btn addTarget:self action:@selector(coverImgClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [btn setTitle:@"上传产品图片" forState:UIControlStateNormal];
        [backView addSubview:btn];
    }
    if (_mediaArray.count>0) {
        _coverImgView.hidden = YES;
    }else{
        _coverImgView.hidden = NO;
    }
}
- (void)coverImgClick:(UITapGestureRecognizer *)tap{
    __weak typeof(self) weakSelf = self;
    MyActionSheetView *alert = [[MyActionSheetView alloc]initWithTitleArray:@[@"相册",@"相机"] andShowCancel: YES];
    alert.ClickIndex = ^(NSInteger index) {
        if (index == 1){
            [weakSelf openAlbum];
        }else if (index == 2){
            [weakSelf openCamera];
        }
    };
    [alert show];
}


#pragma mark - setter
- (void)setShowDelete:(BOOL)showDelete {
    _showDelete = showDelete;
}

- (void)setShowAddButton:(BOOL)showAddButton {
    _showAddButton = showAddButton;
    if (_mediaArray.count > countOfRow - 1 || _mediaArray.count == 0) {
        [self layoutCollection];
    }
}
- (void)setPreShowMedias:(NSArray *)preShowMedias {
    _preShowMedias = preShowMedias;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (id object in preShowMedias) {
        MyImgPickerModel *model = [MyImgPickerModel new];
        if ([object isKindOfClass:[UIImage class]]) {
            model.image = object;
        }else if ([object isKindOfClass:[NSString class]]) {
            NSString *obj = (NSString *)object;
            if ([MyImgPicker isValidUrl:obj]) {
                model.imageUrlString = object;
            }else if ([MyImgPicker isGifImage:obj]) {
                //名字中有.gif是识别不了的（和自己的拓展名重复了，所以先去掉）
                NSString *name_ = obj.lowercaseString;
                if ([name_ containsString:@"gif"]) {
                    name_ = [name_ stringByReplacingOccurrencesOfString:@".gif" withString:@""];
                }
                model.image = [UIImage sd_animatedGIFNamed:name_];
            }else {
                model.image = [UIImage imageNamed:object];
            }
        }else if ([object isKindOfClass:[MyImgPickerModel class]]) {
            model = object;
        }
        [temp addObject:model];
    }
    if (temp.count > 0) {
        [_mediaArray addObjectsFromArray:temp.copy];
        [self layoutCollection];
    }
}

- (void)setAllowPickingVideo:(BOOL)allowPickingVideo {
    _allowPickingVideo = allowPickingVideo;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [_collectionView setBackgroundColor:backgroundColor];
}

#pragma mark - public method

- (void)observeViewHeight:(MyImgPickerHeightBlock)value {
    _block = value;
    //预防先加载数据源的情况
    if (_mediaArray.count > countOfRow - 1) {
        _block(_collectionView.frame.size.height);
    }
}

- (void)observeSelectedMediaArray: (MySelectImgBackBlock)backBlock {
    _backBlock = backBlock;
}

+ (instancetype)ImgPickerViewWithFrame:(CGRect)frame CountOfRow:(NSInteger)count{
    countOfRow = count;
    CGSize size = frame.size;
    size.height = size.width / count;
    frame.size = size;
    MyImgPickerView *imagePickerV = [[MyImgPickerView alloc]initWithFrame:frame];
    return imagePickerV;
}


- (void)reload {
    [self.collectionView reloadData];
}

#pragma mark -  Collection View DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showAddButton ? ( _mediaArray.count == _maxImageSelected ? _mediaArray.count : _mediaArray.count + 1 ): _mediaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyImgPickerCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyImgPickerCCell class]) forIndexPath:indexPath];
    cell.cellIndexPath = indexPath;
    
    if (indexPath.row == _mediaArray.count) {
        cell.icon.image = [UIImage imageNamed:@"img_add" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        cell.videoImageView.hidden = YES;
        cell.deleteButton.hidden = YES;
    }else{
        MyImgPickerModel *model = [[MyImgPickerModel alloc]init];
        model = _mediaArray[indexPath.row];
        if (!model.isVideo && model.imageUrlString) {
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.imageUrlString] placeholderImage:nil];
        }else {
            cell.icon.image = model.image;
        }
        cell.videoImageView.hidden = !model.isVideo;
        cell.deleteButton.hidden = !_showDelete;
        
        cell.LLClickDeleteButton = ^(NSIndexPath *cellIndexPath) {
            
            MyImgPickerModel *model = _mediaArray[cellIndexPath.row];
            
            if (!_allowMultipleSelection) {
                
                    for (NSInteger idx = 0; idx < _selectedImageModels.count; idx++) {
                        
                        if ([((MyImgPickerModel *)_selectedImageModels[idx]) isEqual:model ]) {
                            [_selectedImageAssets removeObjectAtIndex:idx];
                            [_selectedImageModels removeObject:model];
                            break;
                        }
                    }
                
                for (NSInteger idx = 0; idx < _selectedVideoModels.count; idx++) {
                    
                    if ([((MyImgPickerModel *)_selectedVideoModels[idx]) isEqual:model]) {
                        [_selectedVideoModels removeObject:model];
                    }
                }
            }
            [_mediaArray removeObjectAtIndex:cellIndexPath.row];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutCollection];
            });
        };
    }
    return cell;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _mediaArray.count && _mediaArray.count >= _maxImageSelected) {
        [MyImgPicker showAlertWithTitle:[NSString stringWithFormat:@"最多只能选择%ld张",(long)_maxImageSelected] message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == _mediaArray.count) {
        switch (_type) {
            case MyImgType_Photo:
                [self openAlbum];
                break;
            case MyImgType_Camera:
                [self openCamera];
                break;
            case MyImgType_PhotoAndCamera:
            {
                MyActionSheetView *alert = [[MyActionSheetView alloc]initWithTitleArray:@[@"相册",@"相机"] andShowCancel: YES];
                alert.ClickIndex = ^(NSInteger index) {
                    if (index == 1){
                        [weakSelf openAlbum];
                    }else if (index == 2){
                        [weakSelf openCamera];
                    }
                };
                [alert show];
                break;
            }
            case MyImgType_VideoTape:
                [self openVideotape];
                break;
            case MyImgType_Video:
                [self openVideo];
                break;
            default:
            {                
                MyActionSheetView *alert = [[MyActionSheetView alloc]initWithTitleArray:@[@"相册", @"相机", @"录像", @"视频"] andShowCancel: YES];                
                alert.ClickIndex = ^(NSInteger index) {
                    if (index == 4) {
                        [weakSelf openVideo];
                    }else if (index == 3){
                        [weakSelf openVideotape];
                    }else if (index == 2){
                        [weakSelf openCamera];
                    }else if (index == 1){
                        [weakSelf openAlbum];
                    }
                };
                [alert show];
            }
                break;
        }
    }else{
        // 展示媒体
        //仅仅全部都是从相册选择的照片，才能用这个方法

//        if (_selectedImageAssets.count>0) {
//            id asset = _selectedImageAssets[indexPath.row];
//            BOOL isVideo = NO;
//            if ([asset isKindOfClass:[PHAsset class]]) {
//                PHAsset *phAsset = asset;
//                isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
//            } else if ([asset isKindOfClass:[ALAsset class]]) {
//                ALAsset *alAsset = asset;
//                isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//            }
//        }
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedImageAssets selectedPhotos:_mediaArray index:indexPath.row];
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//        }];
//        [[MyImgPicker getViewControllerWithView:self] presentViewController:imagePickerVc animated:YES completion:nil];

        
        _photos = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.alwaysShowControls = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.displayNavArrows = NO;
        browser.startOnGrid = NO;
        browser.enableGrid = YES;
        for (MyImgPickerModel *model in _mediaArray) {
            MWPhoto *photo = [MWPhoto photoWithImage:model.image];
            photo.caption = model.name;
            if (model.isVideo) {
                if (model.mediaURL) {
                    photo.videoURL = model.mediaURL;
                }else {
                    photo = [photo initWithAsset:model.asset targetSize:CGSizeZero];
                }
            }else if (model.imageUrlString) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:model.imageUrlString]];
            }
            [_photos addObject:photo];
        }
        [browser setCurrentPhotoIndex:indexPath.row];
        [[MyImgPicker getViewControllerWithView:self].navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark - <MWPhotoBrowserDelegate>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - 布局

///重新布局collectionview
- (void)layoutCollection {
    
    NSInteger allImageCount = _showAddButton ?(_mediaArray.count == _maxImageSelected ? _mediaArray.count : _mediaArray.count + 1 ): _mediaArray.count;
    NSInteger maxRow = (allImageCount - 1) / countOfRow + 1;
    CGRect frame = self.collectionView.frame;
    frame.size.height = allImageCount == 0 ? 0 : maxRow * self.collectionView.frame.size.width/countOfRow;
    _collectionView.frame = frame;
    self.frame = frame;
//    self.frame.size.height = _collectionView.frame.size.height;
    //block回调
    !_block ?  : _block(_collectionView.frame.size.height);
    !_backBlock ?  : _backBlock(_mediaArray);
    
    [_collectionView reloadData];
    [self configCoverImg];
}

#pragma mark - actions

/** 相册 */
- (void)openAlbum {
    NSInteger count = 0;
    if (!_allowMultipleSelection) {
        count = _maxImageSelected - (_mediaArray.count - _selectedImageModels.count);
    }else {
        count = _maxImageSelected - _mediaArray.count;
    }
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    //是否 在相册中显示拍照按钮
    imagePickController.allowTakePicture = NO;
    //是否可以选择显示原图
    imagePickController.allowPickingOriginalPhoto = NO;
    //是否 在相册中可以选择视频
    imagePickController.allowPickingVideo = _allowPickingVideo;
    if (!_allowMultipleSelection) {
        imagePickController.selectedAssets = _selectedImageAssets;
    }
    
    [[MyImgPicker getViewControllerWithView:self] presentViewController:imagePickController animated:YES completion:nil];
}

//lzyModify
- (void)openCustonCamera {
    MyCameraViewController *cameraVC = [[MyCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 4 - _mediaArray.count;
    // 连拍
    cameraVC.cameraType = ZLCameraContinuous;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        NSMutableArray *models = [NSMutableArray array];
        for (NSInteger index = 0; index < cameras.count; index++) {
                MyCameraModel *canamerPhoto = cameras[index];
                UIImage *image = canamerPhoto.photoImage;
                MyImgPickerModel *model = [[MyImgPickerModel alloc] init];
                model.image = image;
                [models addObject:model];
                if (index == cameras.count - 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_mediaArray addObjectsFromArray:models];
                        [self layoutCollection];
                    });
                }
        }
    };
    cameraVC.suVC = [MyImgPicker getViewControllerWithView:self];
    [cameraVC showPickerVc:[MyImgPicker getViewControllerWithView:self]];
}







/** 相机 */
- (void)openCamera {
    if (self.isCustomCamera) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [self openCustonCamera];
        }else{
            [MyImgPicker showAlertWithTitle:@"该设备不支持拍照" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
        }
    }else{
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            
            [[MyImgPicker getViewControllerWithView:self] presentViewController:picker animated:YES completion:nil];
            
        }else{
            [MyImgPicker showAlertWithTitle:@"该设备不支持拍照" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
        }
    }
}

/** 录像 */
- (void)openVideotape {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray * mediaTypes =[UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = mediaTypes;
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        picker.videoMaximumDuration = 600.0f; //录像最长时间
    } else {
        [MyImgPicker showAlertWithTitle:@"当前设备不支持录像" message:nil actionTitles:@[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert completion:nil];
    }
    
     [[MyImgPicker getViewControllerWithView:self] presentViewController:picker animated:YES completion:nil];
    
}

/** 视频 */
- (void)openVideo {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing = YES;
    
    [[MyImgPicker getViewControllerWithView:self] presentViewController:picker animated:YES completion:nil];
}


#pragma mark - TZImagePickerController Delegate
//处理从相册单选或多选的照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if ([_selectedImageAssets isEqualToArray: assets]) {
        return;
    }
    //每次回传的都是所有的asset 所以要初始化赋值
    if (!_allowMultipleSelection) {
        _selectedImageAssets = [NSMutableArray arrayWithArray:assets];
    }
    NSMutableArray *models = [NSMutableArray array];
    //2次选取照片公共存在的图片
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    for (NSInteger index = 0; index < assets.count; index++) {
        PHAsset *asset = assets[index];
        [[MyImgPicker manager] getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
            
            MyImgPickerModel *model = [[MyImgPickerModel alloc] init];
            model.name = name;
            model.uploadType = pathData;
            model.image = photos[index];
            //区分gif
            if ([MyImgPicker isGifWithImageData:pathData]) {
                model.image = [UIImage sd_animatedGIFWithData:pathData];
            }
                        
            if (!_allowMultipleSelection) {
                //用数组是否包含来判断是不成功的。。。
                for (MyImgPickerModel *md in _selectedImageModels) {
                    // 新方法
                    if ([md isEqual:model] ) {
                        [temp addObject:md];
                        [temp2 addObject:model];
                        break;
                    }
                }
            }
            
            [models addObject:model];
            
            if (index == assets.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_allowMultipleSelection) {
                        //删除公共存在的，剩下的就是已经不存在的
                        [_selectedImageModels removeObjectsInArray:temp];
                        //总媒体数组删先除掉不存在，这样不会影响排列的先后顺序
                        [_mediaArray removeObjectsInArray:_selectedImageModels];
//                        [_selectedImageAssets removeObjectsInArray:assets];
                        //将这次选择的进行赋值，深复制
                        _selectedImageModels = [models mutableCopy];
                        //这次选择的删除公共存在的，剩下的就是新添加的
                        [models removeObjectsInArray:temp2];
                        //总媒体数组中在后面添加新数据
                        [_mediaArray addObjectsFromArray:models];
//                        [_selectedImageAssets addObjectsFromArray:assets];
                    }else {
                        [_selectedImageModels addObjectsFromArray:models];
                        [_mediaArray addObjectsFromArray:models];
//                        [_selectedImageAssets addObjectsFromArray:assets];
                    }
                    
                    [self layoutCollection];
                });
            }
        }];
    }
}
///选取视频后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [[MyImgPicker manager] getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
        MyImgPickerModel *model = [[MyImgPickerModel alloc] init];
        model.name = name;
        model.uploadType = pathData;
        model.image = coverImage;
        model.isVideo = YES;
        model.asset = asset;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!_allowMultipleSelection) {
                //用数组是否包含来判断是不成功的。。。
                for (MyImgPickerModel *tmp in _selectedVideoModels) {
                    if ([tmp isEqual:model]) {
                        return ;
                    }
                }
            }
            [_selectedVideoModels addObject:model];
            [_mediaArray addObject:model];
//            [_selectedImageAssets addObject:asset];
            [self layoutCollection];
        });
    }];
}

#pragma mark - UIImagePickerController Delegate
///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *imageAssetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ///视频 和 录像
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoAssetURL = [info objectForKey:UIImagePickerControllerMediaURL];
        PHAsset *asset;
        //录像没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        [[MyImgPicker manager] getVideoPathFromURL:videoAssetURL PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
            MyImgPickerModel *model = [[MyImgPickerModel alloc] init];
            model.image = screenshot;
            model.name = name;
            model.uploadType = pathData;
            model.isVideo = YES;
            model.mediaURL = videoAssetURL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mediaArray addObject:model];
//                [_selectedImageAssets addObject:asset];
                [self layoutCollection];
            });
        }];
    }
    
    else if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果 picker 没有设置可编辑，那么image 为 nil
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        PHAsset *asset;
        //拍照没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        [[MyImgPicker manager] getImageInfoFromImage:image PHAsset:asset completion:^(NSString *name, NSData *data) {
            MyImgPickerModel *model = [[MyImgPickerModel alloc] init];
            model.image = image;
            model.name = name;
            model.uploadType = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mediaArray addObject:model];
                [self layoutCollection];
            });
        }];
    }
}


@end
