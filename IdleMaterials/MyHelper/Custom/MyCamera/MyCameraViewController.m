//
//  BQCamera.m
//  BQCommunity
//
//  Created by ZL on 14-9-11.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <objc/message.h>
#import "MyCameraViewController.h"
#import "MyCameraView.h"
#import "MWPhotoBrowser.h"
#import "MyCameraToolBar.h"
#import "MyImgPickerModel.h"
#import "MyImgPicker.h"
typedef void(^codeBlock)(void);

static CGFloat kBottomBarHeight = 60;
static CGFloat kBtnHeight = 40;

@interface MyCameraViewController () <
UIActionSheetDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,
AVCaptureMetadataOutputObjectsDelegate,
MyCameraImgViewDelegate,MyCameraViewDelegate,MyCameraToolBarDelegate
,MWPhotoBrowserDelegate
,UIGestureRecognizerDelegate
//,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate
>
{
    CGSize shutterButtonSize;
    CGSize topBarBtnSize;
    CGSize bottomBtnSize;
}
@property (weak,nonatomic) MyCameraView *caramView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIViewController *currentViewController;

// Datas
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableDictionary *dictM;

// AVFoundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, assign) MyImageOrientation imageOrientation;
@property (nonatomic, assign) NSInteger flashCameraState;

@property (nonatomic, strong) UIButton *flashBtn;
@property(assign, nonatomic)CGFloat kCameraColletionCellW;
/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;





/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 * 最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;

@end

@implementation MyCameraViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}
//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.caramView];
        CGPoint convertedLocation = [self.preview convertPoint:location fromLayer:self.preview.superlayer];
        if ( ! [self.preview containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.captureOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.preview setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}


#pragma mark - Getter
#pragma mark Data
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

#pragma mark View
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.kCameraColletionCellW, self.kCameraColletionCellW);
        layout.minimumLineSpacing = kMyPadding;
        CGFloat collectionViewY = self.view.height - self.kCameraColletionCellW - 20 - shutterButtonSize.height;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewY, self.view.width, self.kCameraColletionCellW) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.caramView addSubview:collectionView];
        self.collectionView = collectionView;
    }return _collectionView;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initialize];
    [self configUI];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)initialize{
    //1.创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]){
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:_captureOutput]){
        [self.session addOutput:_captureOutput];
    }
    self.kCameraColletionCellW = (kScreen_Width - 3*kMyPadding)/4;
    
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.frame;
    
    MyCameraView *caramView = [[MyCameraView alloc] initWithFrame:self.view.frame];
    caramView.backgroundColor = [UIColor clearColor];
    caramView.delegate = self;
    [self.view addSubview:caramView];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    self.caramView = caramView;
    
    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    recognizer.delegate = self;

    [self.view addGestureRecognizer:recognizer];
    self.beginGestureScale = 1.0f;
    self.effectiveScale = 1.0f;
}

- (void)cameraDidSelected:(MyCameraView *)camera{
    [self.device lockForConfiguration:nil];
    [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.device setFocusPointOfInterest:CGPointMake(50,50)];
    //操作完成后，记得进行unlock。
    [self.device unlockForConfiguration];
}

//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
    }
}
#pragma mark -初始化界面
-(void)configUI{
    //Declare the sizing of the UI elements for iPhone
    shutterButtonSize = CGSizeMake(self.view.bounds.size.width * 0.21, self.view.bounds.size.width * 0.21);
    
    UIButton *deviceBtn = [self setupButtonWithImageName:@"camera-switch" andX:self.view.width - kBtnHeight*2];
    [deviceBtn addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashBtn = [self setupButtonWithImageName:@"camera-flash" andX:0];
    [flashBtn addTarget:self action:@selector(flashCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _flashBtn = flashBtn;
    
    //取消
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(0, self.view.frame.size.height - kBottomBarHeight, kBtnHeight *2, kBtnHeight);
    [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancalBtn];
    //拍照
    
    UIButton *shutterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shutterBtn.frame = (CGRect){0, 0, shutterButtonSize};
    shutterBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.875);
    shutterBtn.layer.cornerRadius = shutterBtn.width / 2.0f;
    shutterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    shutterBtn.layer.borderWidth = 2.0f;
    shutterBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    shutterBtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    shutterBtn.layer.shouldRasterize = YES;
    shutterBtn.showsTouchWhenHighlighted = YES;
    shutterBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [shutterBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutterBtn];
    // 完成
    if (self.cameraType == ZLCameraContinuous) {
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(self.view.width - kBtnHeight*2, self.view.frame.size.height - kBottomBarHeight, kBtnHeight*2 , kBtnHeight);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneBtn];
    }
}
#pragma mark 初始化按钮
- (UIButton *)setupButtonWithImageName : (NSString *) imageName andX : (CGFloat ) x{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.width = 80;
    button.y = 0;
    button.height = kBtnHeight;
    button.x = x;
    [self.view addSubview:button];
    return button;
}
#pragma mark - CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MyCameraModel *cameraM = self.images[indexPath.item];
    MyCameraImgView *lastView = [cell.contentView.subviews lastObject];
    if(![lastView isKindOfClass:[MyCameraImgView class]]){
        // 解决重用问题
        UIImage *image = cameraM.thumbImage;
        MyCameraImgView *imageView = [[MyCameraImgView alloc] initWithFrame:cell.bounds];
        imageView.delegatge = self;
        imageView.edit = YES;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    lastView.image = cameraM.thumbImage;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.photos = [NSMutableArray array];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.alwaysShowControls = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.displayNavArrows = YES;
    browser.startOnGrid = NO;
    browser.enableGrid = YES;
    for (MyCameraModel *cameraM in self.images) {
        MWPhoto *photo = [MWPhoto photoWithImage:cameraM.photoImage];
        
        [self.photos addObject:photo];
    }
    [browser setCurrentPhotoIndex:indexPath.row];
    browser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalVC)];
    browser.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);

    BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:browser];
    
    [[self topViewController] presentViewController:navc animated:YES completion:nil];
}
- (void)dismissModalVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:self.suVC];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
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

- (void)deleteImgView:(MyCameraImgView *)imageView{
    NSMutableArray *arrM = [self.images mutableCopy];
    for (MyCameraModel *camera in self.images) {
        UIImage *image = camera.thumbImage;
        if ([image isEqual:imageView.image]) {
            [arrM removeObject:camera];
        }
    }
    self.images = arrM;
    [self.collectionView reloadData];
}

- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

-(void)Captureimage{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [videoConnection setVideoScaleAndCropFactor:self.effectiveScale];

    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         t_image = [self cutImage:t_image];
         t_image = [self fixOrientation:t_image];
         NSData *data = UIImageJPEGRepresentation(t_image, 0.3);
         MyCameraModel *camera = [[MyCameraModel alloc] init];
         camera.photoImage = t_image;
         camera.thumbImage = [UIImage imageWithData:data];
         
         if (self.cameraType == ZLCameraSingle) {
             [self.images removeAllObjects];//由于当前只需要一张图片2015-11-6
             [self.images addObject:camera];
             [self displayImage:camera.photoImage];
         } else if (self.cameraType == ZLCameraContinuous) {
             [self.images addObject:camera];
             [self.collectionView reloadData];
             [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.images.count - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
         }
     }];
}

//裁剪image
- (UIImage *)cutImage:(UIImage *)srcImg {
    //注意：这个rect是指横屏时的rect，即屏幕对着自己，home建在右边
    CGRect rect = CGRectMake((srcImg.size.height / CGRectGetHeight(self.view.frame)) * 70, 0, srcImg.size.width * 1.33, srcImg.size.width);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(srcImg.CGImage, rect);
    CGFloat subWidth = CGImageGetWidth(subImageRef);
    CGFloat subHeight = CGImageGetHeight(subImageRef);
    CGRect smallBounds = CGRectMake(0, 0, subWidth, subHeight);
    //旋转后，画出来
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, subWidth);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    CGContextRef ctx = CGBitmapContextCreate(NULL, subHeight, subWidth,
                                             CGImageGetBitsPerComponent(subImageRef), 0,
                                             CGImageGetColorSpace(subImageRef),
                                             CGImageGetBitmapInfo(subImageRef));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, smallBounds, subImageRef);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
	
	CGImageRelease(subImageRef);
	CGContextRelease(ctx);
	CGImageRelease(cgimg);
	return img;
}

//旋转image
- (UIImage *)fixOrientation:(UIImage *)srcImg
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat width = srcImg.size.width;
    CGFloat height = srcImg.size.height;
    
    CGContextRef ctx;
    
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown: //竖屏，不旋转
            ctx = CGBitmapContextCreate(NULL, width, height,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
            
        case UIDeviceOrientationLandscapeLeft:  //横屏，home键在右手边，逆时针旋转90°
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            ctx = CGBitmapContextCreate(NULL, height, width,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
            
        case UIDeviceOrientationLandscapeRight:  //横屏，home键在左手边，顺时针旋转90°
            transform = CGAffineTransformTranslate(transform, 0, width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            ctx = CGBitmapContextCreate(NULL, height, width,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
            
        default:
            break;
    }
    
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0,0,width,height), srcImg.CGImage);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

//LG
- (void)displayImage:(UIImage *)images {
    MyCameraToolBar *view = [[MyCameraToolBar alloc] initWithFrame:self.view.frame];
    view.delegate = self;
    view.imageOrientation = _imageOrientation;
    view.imageToDisplay = images;
    [self.view addSubview:view];
    
}

-(void)CaptureStillImage{
    [self  Captureimage];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)changeCameraDevice:(id)sender{
    // 翻转
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

- (void) flashLightModel : (codeBlock) codeBlock{
    if (!codeBlock) return;
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    codeBlock();
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}
- (void) flashCameraDevice:(UIButton *)sender{
    if (_flashCameraState < 0) {
        _flashCameraState = 0;
    }
    _flashCameraState ++;
    if (_flashCameraState >= 4) {
        _flashCameraState = 0;
    }
    AVCaptureFlashMode mode;
    
    switch (_flashCameraState) {
        case 1:
            mode = AVCaptureFlashModeOn;
            [_flashBtn setTitle:@"打开" forState:UIControlStateNormal];
            break;
        case 2:
            mode = AVCaptureFlashModeAuto;
            [_flashBtn setTitle:@"自动" forState:UIControlStateNormal];
            break;
        case 3:
            mode = AVCaptureFlashModeOff;
            [_flashBtn setTitle:@"关闭" forState:UIControlStateNormal];
            break;
        default:
            mode = AVCaptureFlashModeOff;
            [_flashBtn setTitle:@"关闭" forState:UIControlStateNormal];
            break;
    }
    if ([self.device isFlashModeSupported:mode]){
        [self flashLightModel:^{
            [self.device setFlashMode:mode];
        }];
    }
}

- (void)cancel:(id)sender{
    [self flashLightModel:^{
        [self.device setFlashMode:AVCaptureFlashModeOff];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//拍照
- (void)stillImage:(id)sender{
    // 判断图片的限制个数
    if (self.maxCount > 0 && self.images.count >= self.maxCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"拍照的个数不能超过%ld",(long)self.maxCount]delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    [self Captureimage];
}

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark - 屏幕
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
// 支持屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
// 画面一开始加载时就是竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - MyCameraToolBarDelegate
- (void)useBtnClicked {
    [self doneAction];
}

- (void)cancleBtnClicked {
    [self.images removeAllObjects];
}
//完成、取消
- (void)doneAction{
    //关闭相册界面
    if(self.callback){
        self.callback(self.images);
    }
    [self cancel:nil];
}
@end

