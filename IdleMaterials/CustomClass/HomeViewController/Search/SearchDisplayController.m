//
//  SearchDisplayController.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/2.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SearchHistories.plist"] // 搜索历史存储路径

#import "SearchDisplayController.h"
#import "PublicSearchModel.h"
#import "ProductTCell.h"
#import "ProductModel.h"
#import "YTKNetworkConfig.h"
#import "ProductDetailViewController.h"
#import "Api_GetProductList.h"

//#import "TradeNoticeViewController.h"
//#import "TradeNoticeTCell.h"
//#import "TradeNoticeModel.h"
//#import "X_JingJiaDetailViewController.h"



//#import "TransactionPreviewViewController.h"
//#import "TransactionPreviewTCell.h"
//#import "TransactionPreviewModel.h"
//#import "TransactionDetailViewController.h"
//
//#import "WantToBuyModel.h"
//#import "WantToBuyDetailViewController.h"
//
//#import "IdleProductViewController.h"
//#import "IdleProductTCell.h"
//#import "IdleProductModel.h"
//#import "ProductDetailViewController.h"


@interface SearchDisplayController()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) PublicSearchModel *searchPros;
@property (nonatomic, strong) UIScrollView *searchHistoryView;
@property (nonatomic, assign) double historyHeight;
@property (nonatomic, copy) NSString *searchHistoriesCachePath;/** 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH(PYSearchConst.h文件中的宏定义) */

@property (nonatomic, strong) NSMutableArray *searchHistories;/** 搜索历史 */
@property (nonatomic, assign) NSUInteger searchHistoriesCount;/** 搜索历史记录缓存数量，默认为20 */
@property(strong, nonatomic)UIButton *leftUpBtn;
@property(strong, nonatomic)UIButton *rightUpBtn;
@property(nonatomic, copy)NSString *cateType;

//列表页码
@property(nonatomic,assign)int page;

- (void)initSearchResultsTableView;
- (void)initSearchHistoryView;
- (void)didClickedMoreHotkey:(UIGestureRecognizer *)sender;
- (void)didCLickedCleanSearchHistory:(id)sender;
- (void)didClickedContentView:(UIGestureRecognizer *)sender;
- (void)didClickedHistory:(UIGestureRecognizer *)sender;

@end

@implementation SearchDisplayController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchHistoryView.delegate = nil;
}


- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    if(!visible) {
        [_myTableView removeFromSuperview];
        //        [_backgroundView removeFromSuperview];
        [_contentView removeFromSuperview];
        
        _myTableView = nil;
        _contentView = nil;
        //        _backgroundView = nil;
        _searchHistoryView = nil;
        [super setActive:visible animated:animated];
    }else {
        [super setActive:visible animated:animated];
        NSArray *subViews = self.searchContentsController.view.subviews;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            for (UIView *view in subViews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")]) {
                    NSArray *sub = view.subviews;
                    ((UIView*)sub[2]).hidden = YES;
                }
            }
        } else {
            [[subViews lastObject] removeFromSuperview];
        }
        if(!_contentView) {
            _contentView = ({
                UIView *view = [[UIView alloc] init];
                view.frame = CGRectMake(0.0f, 0, kScreen_Width, kScreen_Height - kSafeAreaTopHeight);
                view.backgroundColor = [UIColor clearColor];
                view.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedContentView:)];
                [view addGestureRecognizer:tapGestureRecognizer];
                view;
            });
            self.contentView.backgroundColor= [UIColor whiteColor];
            [self initSearchHistoryView];
        }
        
        [self.parentVC.view addSubview:_contentView];
        [self.parentVC.view bringSubviewToFront:_contentView];
        self.searchBar.delegate = self;
    }
}
- (void)initSearchResultsTableView {
    self.dataSourceArray = [[NSMutableArray alloc] init];
    if(!_myTableView) {
        _myTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:_contentView.frame style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.tableFooterView = [UIView new];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

            [self.parentVC.view addSubview:tableView];
            tableView;
        });
    }
    [_myTableView.superview bringSubviewToFront:_myTableView];
    
    [_myTableView reloadData];
    self.page = 1;
    [self serveData];
}
-(void)reloadDisplayData{
    [self.dataSourceArray removeAllObjects];
    self.page = 1;
    [self serveData];
}
//搜索历史记录
- (NSMutableArray *)searchHistories{
    if (!_searchHistories) {
        self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}
- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    // 刷新
    self.searchHistories = nil;
    [self.myTableView reloadData];
}
-(NSString *)cateType{
    if (!_cateType) {
        _cateType = @"";
    }return _cateType;
}
-(UIButton *)leftUpBtn{
    if (!_leftUpBtn) {
        _leftUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftUpBtn.size = CGSizeMake(100, 30);
        [_leftUpBtn setTitle:@"设备类" forState:UIControlStateNormal];
        _leftUpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _leftUpBtn.clipsToBounds = YES;
        _leftUpBtn.layer.cornerRadius = 15;
        _leftUpBtn.backgroundColor = kColorMain;
        _leftUpBtn.alpha = 0.9;
        [_leftUpBtn addTarget:self action:@selector(actionLeftUpBtn) forControlEvents:UIControlEventTouchUpInside];
    }return _leftUpBtn;
}
-(UIButton *)rightUpBtn{
    if (!_rightUpBtn) {
        _rightUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightUpBtn.size = CGSizeMake(100, 30);
        [_rightUpBtn setTitle:@"材料类" forState:UIControlStateNormal];
        _rightUpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _rightUpBtn.clipsToBounds = YES;
        _rightUpBtn.layer.cornerRadius = 15;
        _rightUpBtn.backgroundColor = kColorMain;
        _rightUpBtn.alpha = 0.9;
        [_rightUpBtn addTarget:self action:@selector(actionRightUpBtn) forControlEvents:UIControlEventTouchUpInside];
    }return _rightUpBtn;
}

- (void)initSearchHistoryView {
    self.searchHistoriesCount = 20;

    if(!_searchHistoryView) {
        
        _searchHistoryView = [[UIScrollView alloc] init];
        _searchHistoryView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_searchHistoryView];
        self.searchBar.delegate=self;
        [self registerForKeyboardNotifications];
    }
    
    [[_searchHistoryView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        view.backgroundColor = kColorHex(0xdddddd);
        [_searchHistoryView addSubview:view];
    }
    
    CGFloat kTopBtnViewHeight = 70;
    [_searchHistoryView addSubview:self.leftUpBtn];
    [_searchHistoryView addSubview:self.rightUpBtn];
    
    [self.leftUpBtn setFrame:CGRectMake(kMyPadding, kMyPadding, kTopBtnViewHeight, 30)];
    [self.rightUpBtn setFrame:CGRectMake(kMyPadding + kTopBtnViewHeight + kMyPadding, kMyPadding, kTopBtnViewHeight, 30)];
    
    
    
    NSArray *array = self.searchHistories;//[CSSearchModel getSearchHistory];
    CGFloat imageLeft = 12.0f;
    CGFloat textLeft = 34.0f;
    CGFloat height = 44.0f;
    
//    _historyHeight=height*(array.count+1);
    _historyHeight = kScreen_Height - 150;
    //set history list
    [_searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(kScreen_Width);
        make.height.mas_equalTo(_historyHeight);
    }];
    _searchHistoryView.contentSize = CGSizeMake(kScreen_Width, _historyHeight);
    
    
    for (int i = 0; i < array.count; i++) {
        UILabel *lblHistory = [[UILabel alloc] initWithFrame:CGRectMake(textLeft, i * height +kTopBtnViewHeight, kScreen_Width - textLeft, height)];
        lblHistory.userInteractionEnabled = YES;
        lblHistory.font = [UIFont systemFontOfSize:14];
        lblHistory.textColor = kColorHex(0x222222);
        lblHistory.text = array[i];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftView.left = 12;
        leftView.centerY = lblHistory.centerY;
        leftView.image = [UIImage imageNamed:@"icon_search_clock"];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        rightImageView.right = kScreen_Width - 12;
        rightImageView.centerY = lblHistory.centerY;
        rightImageView.image = [UIImage imageNamed:@"icon_arrow_searchHistory"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (i + 1) * height + kTopBtnViewHeight, kScreen_Width - imageLeft, 0.5)];
        view.backgroundColor = kColorHex(0xdddddd);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedHistory:)];
        [lblHistory addGestureRecognizer:tapGestureRecognizer];
        
        [_searchHistoryView addSubview:lblHistory];
        [_searchHistoryView addSubview:leftView];
        [_searchHistoryView addSubview:rightImageView];
        [_searchHistoryView addSubview:view];
    }
    
    if(array.count) {
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClean.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnClean setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [btnClean setTitleColor:kColorMain forState:UIControlStateNormal];
        [btnClean setFrame:CGRectMake(0, array.count * height+kTopBtnViewHeight, kScreen_Width, height)];
        [_searchHistoryView addSubview:btnClean];
        [btnClean addTarget:self action:@selector(didCLickedCleanSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (array.count + 1) * height, kScreen_Width - imageLeft, 0.5)];
//            view.backgroundColor = kColorHex(0xdddddd);
//            [_searchHistoryView addSubview:view];
        }
    }
    
}

#pragma mark - Acton
- (void)didClickedMoreHotkey:(UIGestureRecognizer *)sender {
    [self.searchBar resignFirstResponder];
//    CSHotTopicPagesVC *vc = [CSHotTopicPagesVC new];
//    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)didCLickedCleanSearchHistory:(id)sender {
    
//    [CSSearchModel cleanAllSearchHistory];
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];

    [self initSearchHistoryView];
}

- (void)didClickedContentView:(UIGestureRecognizer *)sender {
    [self.searchBar resignFirstResponder];
}

- (void)didClickedHistory:(UIGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    self.searchBar.text = label.text;
    // 缓存数据并且刷新界面
    [self actionSaveSearchCacheAndRefreshView];

//    [CSSearchModel addSearchHistory:self.searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
}
/** 进入搜索状态调用此方法 */
- (void)actionSaveSearchCacheAndRefreshView{
    UISearchBar *searchBar = self.searchBar;
    // 回收键盘
    [searchBar resignFirstResponder];
    // 先移除再刷新
    [self.searchHistories removeObject:searchBar.text];
    [self.searchHistories insertObject:searchBar.text atIndex:0];
    
    // 移除多余的缓存
    if (self.searchHistories.count > self.searchHistoriesCount) {
        // 移除最后一条缓存
        [self.searchHistories removeLastObject];
    }
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    
    [self.myTableView reloadData];
}
#pragma mark -- goVC

#pragma mark -
#pragma mark Search Data Request

- (void)refresh {
    if(_isLoading){
        [_myTableView.mj_header endRefreshing];
        return;
    }
    self.page = 1;
    [self serveData];
}

- (void)loadMore {
    if(_isLoading){
        [_myTableView.mj_footer endRefreshing];
        return;
    }
    self.page ++;
    [self serveData];

}

-(void)serveData{
    self.isLoading = YES;
    NSString *name = @"";
    NSString *modelNo = @"";
    NSString *creUser = @"";
    
    if (_curSearchType == kSearchType_ProductName) {
        name = self.searchBar.text;
    }else if (_curSearchType == kSearchType_ProductModelNo){
        modelNo = self.searchBar.text;
    }else if (_curSearchType == kSearchType_ProductCreUser){
        creUser = self.searchBar.text;
    }else{
        self.isLoading = NO;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }
    //如果实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    Api_GetProductList *getProductListApi = [[Api_GetProductList alloc] initWithPageIndex:[NSString stringWithFormat:@"%lu",(unsigned long)self.page] pageSize:@"15" searchTime:@"" creUser:creUser cateType:self.cateType name:name modelNo:modelNo];
    
    [getProductListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.isLoading = NO;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (self.page == 1) {
            self.dataSourceArray = [ProductModel arrayOfModelsFromDictionaries:request.responseJSONObject[@"data"] error:nil];
        }else{
            [self.dataSourceArray addObjectsFromArray:[ProductModel arrayOfModelsFromDictionaries:request.responseJSONObject[@"data"] error:nil]];
        }
        [self.myTableView reloadData];
        
        NSLog(@"Lzy——Api_GetProductList请求结果:%@",request.responseJSONObject);
        NSLog(@"requestArgument:%@",request.requestArgument);

    } failure:^(__kindof YTKBaseRequest *request) {
        self.isLoading = NO;
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (!(self.page == 0)) {
            self.page --;
        }
        NSLog(@"Api_GetProductList failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self.parentVC presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}
-(void)actionLeftUpBtn{
    self.cateType = @"1";
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
}
-(void)actionRightUpBtn{
    self.cateType = @"2";
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
}


- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown{
    if (_historyHeight+236>(kScreen_Height-64)) {
        [_searchHistoryView setHeight:kScreen_Height-236-64];
    }
}

-(void)keyboardWillBeHidden{
    if (_historyHeight+236>(kScreen_Height-64)) {
        [_searchHistoryView setHeight:_historyHeight];
    }
}

#pragma mark - UISearchBarDelegate Support

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 缓存数据并且刷新界面
    [self actionSaveSearchCacheAndRefreshView];
//    [CSSearchModel addSearchHistory:searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    
    [self initSearchResultsTableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource Support

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *productM = self.dataSourceArray[indexPath.row];
    static NSString *cellIdentifier = @"ProductTcell";
    ProductTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductTCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSArray *array = [NSMutableArray arrayWithArray:[productM.pics componentsSeparatedByString:@","]];
    if ((array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) && ([[array firstObject] length]>0)) {
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[YTKNetworkConfig sharedConfig].cdnUrl,[array objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"MyPlaceHolder"]];
    }else{
        [cell.productImageView setImage:[UIImage imageNamed:@"MyPlaceHolder"]];
    }
    if ([productM.cateType isEqualToString:@"1"]) {
        cell.typeLabel.text = @"设备";
        cell.typeLabel.textColor = kColorMain;
        cell.typeLabel.borderColor = kColorMain;
    }else{
        cell.typeLabel.text = @"材料";
        cell.typeLabel.textColor = [UIColor greenColor];
        cell.typeLabel.borderColor = [UIColor greenColor];
    }
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",productM.name];
    cell.specLabel.text = [NSString stringWithFormat:@"规格型号:%@",productM.modelNo];
    cell.priceLabel.text = [NSString stringWithFormat:@"原值（元）:%@",[NSObject moneyStyle:productM.oldValue]];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@%@",productM.num,productM.unit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProductModel *productM = self.dataSourceArray[indexPath.row];
    ProductDetailViewController *vc = [ProductDetailViewController new];
    vc.productM = productM;
    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self setActive:TRUE];
    return TRUE;
}
@end
