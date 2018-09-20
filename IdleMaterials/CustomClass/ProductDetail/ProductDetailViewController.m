//
//  ProductDetailViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
/*
 {
 data =     {
 pdId = "4ba11a452bfa48ce9a9162803db700d0",
 usefulDate = <null>,
 provinceId = "5",
 categoryId = "357c71d9024340bd842f50807a65c233",
 remark = "1",
 modTime = "2018-03-30 16:54:48",
 category =     {
 id = "357c71d9024340bd842f50807a65c233",
 spread = <null>,
 delFlag = "0",
 rank = "4",
 code = "06020101",
 remark = "颚式破碎机",
 modTime = "2018-02-23 16:04:40",
 xzName = "闲废设备,选矿设备,破碎设备",
 children = <null>,
 pid = "bca86afa13324a8385b3eeea10d44377",
 pids = "2ae5c82ff1f842debd84829631afd6d7,8e6e6fae0484476f96d8efc67dcd7c32,bca86afa13324a8385b3eeea10d44377",
 name = "颚式破碎机",
 sort = "1",
 },
 address = "1",
 num = "1",
 description = "1",
 pics = "upload/xzwz/jl/user/2018033016039720058098.jpg",
 supplier = "1",
 oldWeight = "1",
 unit = "吨",
 materialQuality = <null>,
 cateType = "1",
 modUser = "李宗洋",
 modelNo = "1",
 upDownStatus = "0",
 cpId = "e809c0038ddb487492a0be3900830f59",
 delFlag = "0",
 brand = "1",
 workLong = "1",
 useBeginTime = "2018-03-30 00:00:00",
 name = "1",
 code = "10000020",
 xzPiId = "402880866275dfdf0162761dfdaf0009",
 manufacturer = "1",
 allAddress = "内蒙古自治区,包头市,青山区1",
 cityId = "353",
 oldDegree = "11",
 creTime = "2018-03-30 16:54:48",
 size = "1",
 figureNo = <null>,
 oldValue = "1",
 nowWeight = "1",
 countyId = "2748",
 companyInfo =     {
 address = "建设大道222号",
 creTime = "2018-03-19 09:39:08",
 modUserName = "孙某",
 xzLoginName = "wangxuechun",
 headPic = "upload/xzwz/jl/user/2018032010034420035064.jpg",
 adminMobile = "18633153006",
 companyAddress = "河北省承德市滦平县",
 modTime = "2018-03-20 10:36:16",
 adminName = "孙某",
 delFlag = "0",
 salt = "AshdvkhudIXPwjbPKhLB",
 countyId = "186",
 openAccFlag = "1",
 cityId = "9",
 provinceId = "3",
 linkmanNumbers = <null>,
 map = <null>,
 xzPassword = "123456",
 companyName = "滦平建龙矿业有限公司",
 cpId = "e809c0038ddb487492a0be3900830f59",
 accType = "2",
 loginName = "滦平建龙",
 pCpId = "1",
 password = "a53b82d623d496fc57b932ecb7df0ef9cce18114282a49e114bf6cd41451f8f5",
 facUserid = "402880865fb4148f015fcdcbc725001f",
 xzToken = "753e5c03e4e6640a5787ec58bccc8a2b",
 },
 creUser = "李宗洋",
 unuseBeginTime = "2018-03-30 00:00:00",
 categoryMap =     (
 "设备",
 "选矿设备",
 "破碎设备",
 "颚式破碎机",
 ),
 },
 code = 0,
 }
/Users/apple/Documents/Xiyuan/LzyTool/LzyTool/CustomClass/HomeViewController/Api_ChangeProductByIdArray.h
 */

#import "ProductDetailViewController.h"
#import "XRCarouselView.h"
#import "Api_GetProductDetail.h"
#import "YTKNetworkConfig.h"

#import "DetailImageTCell.h"
#import "DetailImageModel.h"
#import "MWPhotoBrowser.h"


#define kDescFontSize 14
#define kTitleFontSize 25

@interface ProductDetailViewController ()<UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate>
@property(strong, nonatomic)UITableView *myTableView;

@property(strong, nonatomic)XRCarouselView *myCarouselView;
//所有数据模型的数组
@property(nonatomic,strong)NSMutableArray *allModelArray;
//所有图片数组
@property(nonatomic,strong)NSMutableArray *allPictureArray;
@property(strong, nonatomic)NSMutableArray *detailImageModelArray;

@property(strong, nonatomic)ProductModel *productDetailM;
@property(assign, nonatomic)float descLabelHeight;
@property(assign, nonatomic)float titleLabelHeight;
/** MWPhoto对象数组 */
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation ProductDetailViewController
-(NSMutableArray *)allPictureArray{
    if (!_allPictureArray) {
        _allPictureArray = [[NSMutableArray alloc] init];
    }return _allPictureArray;
}
-(NSMutableArray *)detailImageModelArray{
    if (!_detailImageModelArray) {
        _detailImageModelArray = [NSMutableArray new];
        
    }return _detailImageModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"产品详情"];
    if ([self.productM.cateType isEqualToString:@"1"]) {
        self.isEquipment = YES;
    }else if([self.productM.cateType isEqualToString:@"2"]){
        self.isEquipment = NO;
    }
    [self serveData];
    [self configTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configTableView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight, 0);
    tableView.contentInset = insets;
    tableView.scrollIndicatorInsets = insets;
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [tableView registerClass:[TitleValueTCell class] forCellReuseIdentifier:kCellIdentifier_TitleValueTCell];
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.myTableView = tableView;
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)configTableHeaderViewWithHeight:(CGFloat)height{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.myTableView.tableHeaderView = headerView;
    
    if (!self.myCarouselView) {
        XRCarouselView *carousView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kScreen_Width*0.45)];
        carousView.placeholderImage = [UIImage imageNamed:@"MyPlaceHolder"];
        carousView.time = 4;
        carousView.contentMode = UIViewContentModeScaleAspectFill;
        carousView.pagePosition = PositionBottomCenter;
        [carousView setDescribeTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] bgColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        [headerView addSubview:carousView];
        self.myCarouselView = carousView;
    }
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    arr = [NSMutableArray arrayWithArray:[self.productDetailM.pics componentsSeparatedByString:@","]];

    for (NSString *imgUrl in arr) {
        if ([NSObject isString:imgUrl]) {
            NSString *completePicUrl = [[YTKNetworkConfig sharedConfig].cdnUrl stringByAppendingString:imgUrl];
            [self.allPictureArray addObject:completePicUrl];
        }
    }
    for (NSString *url in self.allPictureArray) {
        DetailImageModel *detailM = [DetailImageModel new];
        detailM.imageUrl = url;
        [self.detailImageModelArray addObject:detailM];
    }
    NSLog(@"所有的图片url----%@",self.allPictureArray);
    
    self.myCarouselView.imageArray = self.allPictureArray;
    __weak typeof(self)weakSelf = self;
    self.myCarouselView.imageClickBlock = ^(NSInteger index) {
        
        weakSelf.photos = [NSMutableArray array];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
        browser.displayActionButton = NO;
        browser.alwaysShowControls = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.displayNavArrows = NO;
        browser.startOnGrid = NO;
        browser.enableGrid = YES;
        for (NSString *imgUrl in weakSelf.allPictureArray) {
           MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]];
            [weakSelf.photos addObject:photo];
        }
        [browser setCurrentPhotoIndex:index];
        [weakSelf.navigationController pushViewController:browser animated:YES];

    };
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = self.productDetailM.name;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.myCarouselView.mas_bottom).offset(kMyPadding/2);
        make.left.equalTo(headerView).offset(kMyPadding);
        make.right.equalTo(headerView).offset(-kMyPadding);
    }];
    
    UILabel *specLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    specLabel.text = [NSString stringWithFormat:@"规格型号：%@",self.productDetailM.modelNo];
    specLabel.font = [UIFont systemFontOfSize:kDescFontSize];
    [headerView addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.left.equalTo(headerView).offset(kMyPadding);
        make.right.equalTo(headerView).offset(-kMyPadding);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.text = [NSString stringWithFormat:@"原值：%@",[NSObject moneyStyle:self.productDetailM.oldValue]];
    priceLabel.font = [UIFont systemFontOfSize:kDescFontSize];
    [headerView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(specLabel.mas_bottom);
        make.left.equalTo(headerView).offset(kMyPadding);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo((kScreen_Width-kMyPadding*2)/2);
    }];

    UILabel *productNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    productNumLabel.text = [NSString stringWithFormat:@"x%@%@",self.productDetailM.num,self.productDetailM.unit];
    productNumLabel.textAlignment = NSTextAlignmentRight;
    productNumLabel.font = [UIFont systemFontOfSize:kDescFontSize];
    [headerView addSubview:productNumLabel];
    [productNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(specLabel.mas_bottom);
        make.right.equalTo(headerView).offset(-kMyPadding);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo((kScreen_Width-kMyPadding*2)/2);
    }];
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

#pragma mark -UI
- (void)serveData{
    Api_GetProductDetail *getProductListApi = [[Api_GetProductDetail alloc] initWithProductId:self.productM.pdId];
    [getProductListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.productDetailM = [[ProductModel alloc] initWithDictionary:request.responseJSONObject[@"data"] error:nil];
        CGSize titleSize = [self.productDetailM.name boundingRectWithSize:CGSizeMake(kScreen_Width - kMyPadding *2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kDescFontSize]} context:nil].size;
        self.titleLabelHeight = titleSize.height;
        
        //设置tableView 的头视图
        [self configTableHeaderViewWithHeight:kScreen_Width*0.45+75 + kMyPadding/2+self.titleLabelHeight];
        //计算descLabel的高度
        NSString *titleContent = self.productDetailM.desc;
        CGSize descSize = [titleContent boundingRectWithSize:CGSizeMake(kScreen_Width - kMyPadding *2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kDescFontSize]} context:nil].size;
        self.descLabelHeight = descSize.height;

        [self.myTableView reloadData];
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"Api_GetProductList failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}


#pragma mark - Delegate_Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.isEquipment) {
            return 17;
        }else{
            return 12;
        }
    }
    else if (section == 1){
        return 1;
    }
    else{
        return self.detailImageModelArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 44;
    }
    else if (indexPath.section ==1){
        return self.descLabelHeight +kMyPadding *2;
    }
    else{
        DetailImageModel *model= self.detailImageModelArray[indexPath.row];
        if (model.cellHeight == 20) {
            model.cellHeight = 150;
        }
        return model.cellHeight +5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1||section == 2) {
        return 54;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (section == 1) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:topView];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 44)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"资源描述";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        return view;
    }
    if (section == 2) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:topView];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 44)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"产品图片";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        return view;
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        [self configureCell:cell forIndexPath:indexPath];
        return cell;
        
    }
    else if (indexPath.section == 1){
        static NSString * CellIdentifier = @"descCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 0, kScreen_Width -kMyPadding *2, self.descLabelHeight+kMyPadding *2)];
        label1.numberOfLines = 0;
        label1.font = [UIFont systemFontOfSize:kDescFontSize];
        label1.text = self.productDetailM.desc;
        [cell.contentView addSubview:label1];
        return cell;
    }
    else {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        DetailImageTCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[DetailImageTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellIdentifier"];
        }else{
            
            //防复用设置 删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            
        }
        
        cell.model = self.detailImageModelArray[indexPath.row];
        cell.changeCellHeight = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"录入人";
        cell.detailTextLabel.text = self.productDetailM.creUser;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"录入时间";
        if (self.productDetailM.creTime.length>10) {
            self.productDetailM.creTime = [self.productDetailM.creTime substringToIndex:10];
        }
        cell.detailTextLabel.text = self.productDetailM.creTime;
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"产品分类";
        cell.detailTextLabel.text = [self.productDetailM.categoryMap componentsJoinedByString:@"-"];
    }
    else if (indexPath.row == 3){
        if (self.isEquipment) {
            cell.textLabel.text = @"尺寸";
            cell.detailTextLabel.text = self.productDetailM.size;
        }else{
            cell.textLabel.text = @"材质";
            cell.detailTextLabel.text = self.productDetailM.materialQuality;
        }
    }
    else if (indexPath.row == 4){
        if (self.isEquipment) {
            cell.textLabel.text = @"材质";
            cell.detailTextLabel.text = self.productDetailM.materialQuality;
        }else{
            cell.textLabel.text = @"实重";
            cell.detailTextLabel.text = self.productDetailM.nowWeight;
        }
    }
    else if (indexPath.row == 5){
        if (self.isEquipment) {
            cell.textLabel.text = @"原重";
            cell.detailTextLabel.text = self.productDetailM.oldWeight;
        }else{
            cell.textLabel.text = @"所属单位";
            cell.detailTextLabel.text = self.productDetailM.companyInfo.companyName;
        }
    }
    else if (indexPath.row == 6){
        if (self.isEquipment) {
            cell.textLabel.text = @"实重";
            cell.detailTextLabel.text = self.productDetailM.nowWeight;
        }else{
            cell.textLabel.text = @"所在区域";
            cell.detailTextLabel.text = self.productDetailM.allAddress;
        }
    }
    else if (indexPath.row == 7){
        if (self.isEquipment) {
            cell.textLabel.text = @"所属单位";
            cell.detailTextLabel.text = self.productDetailM.companyInfo.companyName;
        }else{
            cell.textLabel.text = @"品牌";
            cell.detailTextLabel.text = self.productDetailM.brand;
        }
    }
    else if (indexPath.row == 8){
        if (self.isEquipment) {
            cell.textLabel.text = @"所在区域";
            cell.detailTextLabel.text = self.productDetailM.allAddress;
        }else{
            cell.textLabel.text = @"生产厂家";
            cell.detailTextLabel.text = self.productDetailM.manufacturer;
        }
    }
    else if (indexPath.row == 9){
        if (self.isEquipment) {
            cell.textLabel.text = @"品牌";
            cell.detailTextLabel.text = self.productDetailM.brand;
        }else{
            cell.textLabel.text = @"供货厂家";
            cell.detailTextLabel.text = self.productDetailM.supplier;
        }
    }
    else if (indexPath.row == 10){
        if (self.isEquipment) {
            cell.textLabel.text = @"生产厂家";
            cell.detailTextLabel.text = self.productDetailM.manufacturer;
        }else{
            cell.textLabel.text = @"有效期";
            if (self.productDetailM.usefulDate.length>10) {
                self.productDetailM.usefulDate = [self.productDetailM.usefulDate substringToIndex:10];
            }
            cell.detailTextLabel.text = self.productDetailM.usefulDate;
        }
    }
    else if (indexPath.row == 11){
        if (self.isEquipment) {
            cell.textLabel.text = @"供货厂家";
            cell.detailTextLabel.text = self.productDetailM.supplier;
        }else{
            cell.textLabel.text = @"备注";
            cell.detailTextLabel.text = self.productDetailM.remark;
        }
    }
    else if (indexPath.row == 12){
        cell.textLabel.text = @"新旧程度";
        cell.detailTextLabel.text = self.productDetailM.oldDegree;
    }
    else if (indexPath.row == 13){
        cell.textLabel.text = @"工作时长";
        cell.detailTextLabel.text = self.productDetailM.workLong;
    }
    else if (indexPath.row == 14){
        cell.textLabel.text = @"闲置起始时间";
        if (self.productDetailM.unuseBeginTime.length>10) {
            self.productDetailM.unuseBeginTime = [self.productDetailM.unuseBeginTime substringToIndex:10];
        }
        cell.detailTextLabel.text = self.productDetailM.unuseBeginTime;
    }
    else if (indexPath.row == 15){
        cell.textLabel.text = @"出厂时间";
        if (self.productDetailM.useBeginTime.length>10) {
            self.productDetailM.useBeginTime = [self.productDetailM.useBeginTime substringToIndex:10];
        }
        cell.detailTextLabel.text = self.productDetailM.useBeginTime;
    }
    else{
        cell.textLabel.text = @"备注";
        cell.detailTextLabel.text = self.productDetailM.remark;
    }
}
-(void)configMWPhotoBrowserWithIndex:(NSInteger)index{
    self.photos = [NSMutableArray array];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.alwaysShowControls = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.displayNavArrows = NO;
    browser.startOnGrid = NO;
    browser.enableGrid = YES;
    for (NSString *imgUrl in self.allPictureArray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]];
        [self.photos addObject:photo];
    }
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self configMWPhotoBrowserWithIndex:indexPath.row];
    }
}
@end
