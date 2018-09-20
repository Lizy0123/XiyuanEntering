//
//  HomeViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductTCell.h"
#import "ProductDetailViewController.h"
#import "ProductModel.h"
#import "YTKNetworkConfig.h"

#import "CategorySearchBar.h"
#import "SearchViewController.h"
#import "AddProductViewController.h"

#import "Api_GetProductList.h"
#import "Api_DelProductById.h"
#import "Api_ChangeProductByIdArray.h"
#import "Api_GetProductDetail.h"

#import "LYEmptyViewHeader.h"

#define toolViewHeight 44

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    MyPage _page;
}
@property(strong, nonatomic)NSMutableArray *dataSourceArray;
@property(strong, nonatomic)UITableView *myTableView;
@property(strong, nonatomic)MainSearchBar *mySearchBar;
@property(strong, nonatomic)UISearchDisplayController *mySearchDisplayController;

//底部控件
@property (nonatomic,strong)UIView *toolView;
@property (nonatomic,strong)UIButton *selectAllBtn;
@property (nonatomic,strong)UIButton *delButton;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation HomeViewController
-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray==nil) {
        _dataSourceArray = [NSMutableArray new];
    }
    return _dataSourceArray;
}
-(MainSearchBar *)mySearchBar{
    if (_mySearchBar==nil) {
        _mySearchBar = [[MainSearchBar alloc] initWithFrame:CGRectMake(60,7, kScreen_Width-115, 31)];
        [_mySearchBar setContentMode:UIViewContentModeLeft];
        UITextField *textfield = [_mySearchBar valueForKey:@"_searchField"];
        [textfield setValue:kColorHex(0x999999)forKeyPath:@"_placeholderLabel.textColor"];
        [textfield setValue:[UIFont boldSystemFontOfSize:12]forKeyPath:@"_placeholderLabel.font"];
        textfield.font = [UIFont systemFontOfSize:13];
        [_mySearchBar setPlaceholder:@"搜索"];
        [_mySearchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_mySearchBar setPositionAdjustment:UIOffsetMake(10,0) forSearchBarIcon:UISearchBarIconClear];
        _mySearchBar.searchTextPositionAdjustment=UIOffsetMake(10,0);
        _mySearchBar.delegate = self;
        _mySearchBar.layer.cornerRadius=15;
        _mySearchBar.layer.masksToBounds=TRUE;
        [_mySearchBar.layer setBorderWidth:8];
        [_mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];//设置边框为白色
        [_mySearchBar sizeToFit];
        [_mySearchBar setTintColor:[UIColor whiteColor]];
        [_mySearchBar insertBGColor:[UIColor colorWithHexString:@"0xffffff"]];
        [_mySearchBar setHeight:30];
//        [_mySearchBar.scanBtn addTarget:self action:@selector(scanBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    }return _mySearchBar;
}
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.allowsMultipleSelectionDuringEditing = YES;
    }return _myTableView;
}
-(UIView *)toolView{
    if (!_toolView) {
        _toolView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, toolViewHeight)];
        _toolView.alpha=0;
        _toolView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_toolView];
        
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame=CGRectMake(0, 0,  100, toolViewHeight);
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:kColorMain forState:UIControlStateNormal];

        [_selectAllBtn addTarget:self action:@selector(actionSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_selectAllBtn];
        
        _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _delButton.frame=CGRectMake(kScreen_Width - 100, 0, 100, toolViewHeight);
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton setTitleColor:kColorMain forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(actionDeleteButn) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_delButton];
    }return _toolView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    //添加TableView
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.myTableView.ly_emptyView = [MyDIYEmpty emptyActionViewWithImageStr:@"MyPlaceHolder"
                                                                 titleStr:@"暂无数据"
                                                                detailStr:@"主账号无法查看产品数据"
                                                              btnTitleStr:@"暂无数据"
                                                                   target:self
                                                                   action:nil];    //配置刷新
    [self configRefresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //首页添加搜索框，我的页添加编辑按钮
    if (!self.isMineIn) {
        [self.navigationController.navigationBar addSubview:self.mySearchBar];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction)];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_page.pageIndex == 1) {
        [self serveData];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //首页移除搜索框，我的页移除编辑按钮
    if (!self.isMineIn) {
        [self.mySearchBar removeFromSuperview];
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark - UI
-(void)configRefresh{
    _page.pageIndex = 1;
    _page.pageSize = 1000;
    self.myTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        _page.pageIndex = 1;
        [self serveData];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page.pageIndex++;
        [self serveData];
    }];
    [self serveData];
}
- (void)searchItemClicked:(id)sender{
    [_mySearchBar setX:20];
    if (!_mySearchDisplayController) {
        _mySearchDisplayController = ({
            UISearchDisplayController *searchVC = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
            searchVC.searchResultsTableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.mySearchBar.frame), 0, kScreen_Height, 0);
            searchVC.searchResultsTableView.tableFooterView = [[UIView alloc] init];
            //            [searchVC.searchResultsTableView registerClass:[ProjectListCell class] forCellReuseIdentifier:kCellIdentifier_ProjectList];
            searchVC.searchResultsDataSource = self;
            searchVC.searchResultsDelegate = self;
            searchVC.displaysSearchBarInNavigationBar = NO;
            searchVC;
        });
    }
    
    [_mySearchBar becomeFirstResponder];
}
-(void)searchAction{
    if (!_mySearchDisplayController) {
        _mySearchDisplayController = ({
            UISearchDisplayController *searchVC = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
            searchVC.searchResultsTableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.mySearchBar.frame), 0, kScreen_Height, 0);
            searchVC.searchResultsTableView.tableFooterView = [[UIView alloc] init];
            //            [searchVC.searchResultsTableView registerClass:[ProjectListCell class] forCellReuseIdentifier:kCellIdentifier_ProjectList];
            searchVC.searchResultsDataSource = self;
            searchVC.searchResultsDelegate = self;
            searchVC.displaysSearchBarInNavigationBar = NO;
            searchVC;
        });
    }
}
-(void)goToSearchVC{
//    [self closeFliter];
//    [self closeMenu];
    SearchViewController *vc=[SearchViewController new];
    BaseNavigationController *searchNav=[[BaseNavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:searchNav animated:NO completion:nil];
}
#pragma mark - Delegate_UISearchBar
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self goToSearchVC];
    return NO;
    
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    [self searchProjectWithStr:searchText];
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self searchProjectWithStr:searchBar.text];
//}
//- (void)searchProjectWithStr:(NSString *)string{
//    self.searchString = string;
//    [self updateFilteredContentForSearchString:string];
//    [self.mySearchDisplayController.searchResultsTableView reloadData];
//}



#pragma mark - Action
- (void)serveData{
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];

    //如果实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    NSString *creUser = @"";
    if (self.isMineIn) {
        creUser = [UserManager readUserInfo].fullName;
    }
    Api_GetProductList *getProductListApi = [[Api_GetProductList alloc] initWithPageIndex:[NSString stringWithFormat:@"%lu",(unsigned long)_page.pageIndex] pageSize:[NSString stringWithFormat:@"%lu",(unsigned long)_page.pageSize] searchTime:@"" creUser:creUser cateType:@"" name:@"" modelNo:@""];
    [getProductListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"Lzy——Api_GetProductList请求结果:%@",request.responseJSONObject);
        NSLog(@"requestArgument:%@",request.requestArgument);
        if (_page.pageIndex == 1) {
            self.dataSourceArray = [ProductModel arrayOfModelsFromDictionaries:request.responseJSONObject[@"data"] error:nil];
        }else{
            [self.dataSourceArray addObjectsFromArray:[ProductModel arrayOfModelsFromDictionaries:request.responseJSONObject[@"data"] error:nil]];
        }

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
-(void)editAction{
    self.isAllSelected = NO;//全选状态的切换
    NSString *string = !self.myTableView.editing?@"完成":@"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStyleDone target:self action:@selector(editAction)];
    if (self.dataSourceArray.count) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.alpha=!self.myTableView.editing?1:0;
            UIEdgeInsets insets;
            if (!self.myTableView.editing) {
                insets = UIEdgeInsetsMake(44, 0, kSafeAreaBottomHeight, 0);
            }else{
                insets = UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight, 0);
            }
            self.myTableView.contentInset = insets;
            self.myTableView.scrollIndicatorInsets = insets;
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.alpha=0;
        }];
    }
    self.myTableView.editing = !self.myTableView.editing;
    [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - 多选删除
-(void)actionDeleteButn{
    NSMutableArray *deleteProductArr = [NSMutableArray array];
    NSMutableArray *deleteIdArr = [NSMutableArray array];

    for (NSIndexPath *indexPath in self.myTableView.indexPathsForSelectedRows) {
        ProductModel *productM = self.dataSourceArray[indexPath.row];
        [deleteProductArr addObject:productM];
        [deleteIdArr addObject:productM.pdId];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定删除所选产品？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [deleteIdArr componentsJoinedByString:@","];
        Api_ChangeProductByIdArray *changeProductByArrApi = [[Api_ChangeProductByIdArray alloc] initWithProductsArray:str type:@"5"];////1上架2下架3调剂4导出5删除
        [changeProductByArrApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            if (([[request.responseJSONObject[@"code"] stringValue] isEqualToString:@"0"])) {
                [UIView animateWithDuration:0 animations:^{
                    [self.dataSourceArray removeObjectsInArray:deleteProductArr];
                    [self.myTableView reloadData];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.25 animations:^{
                        if (!self.dataSourceArray.count){
                            self.toolView.alpha=1;
                        }
                    } completion:^(BOOL finished) {
                        self.isAllSelected = NO;//全选之后又去掉几个选中状态
                    }];
                }];
                NSLog(@"changeProductByArrApi请求结果:%@",request.responseJSONObject);
                NSLog(@"requestArgument:%@",request.requestArgument);
            }
            NSString *str = request.responseJSONObject[@"msg"];
            if ([NSObject isString:str]) {
                [NSObject showStr:str];
            }
            
            

        } failure:^(__kindof YTKBaseRequest *request) {
            NSLog(@"changeProductByArrApi failed");
            if ([request.response.URL.path containsString:@"/login.jsp"]) {
                //            [BaseViewController goToLoginVC];
                [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                    [BaseViewController configLogOutStatus];
                }];
            }
        }];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:action1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 全选删除
-(void)actionSelectAll{
    self.isAllSelected = !self.isAllSelected;
    for (int i = 0; i<self.dataSourceArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isAllSelected) {
            [self.myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{//反选
            [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductModel *productM = self.dataSourceArray[indexPath.row];
    static NSString *cellIdentifier = @"ProductTCell";
    ProductTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ProductTCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];

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
    cell.specLabel.text = [NSString stringWithFormat:@"规格型号：%@",productM.modelNo];
    cell.priceLabel.text = [NSString stringWithFormat:@"原值(元)：%@",[NSObject moneyStyle:productM.oldValue]];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@%@",productM.num,productM.unit];
    
    return cell;
}
#pragma mark - 左滑删除
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ProductModel *productM = [self.dataSourceArray objectAtIndex:indexPath.row];
        Api_DelProductById *api_DelProductById = [[Api_DelProductById alloc] initWithProductId:productM.pdId];
        [api_DelProductById startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"api_DelProductById请求结果:%@",request.responseJSONObject);
            if (([[request.responseJSONObject[@"code"] stringValue] isEqualToString:@"0"])) {
                [self.dataSourceArray removeObjectAtIndex:indexPath.row];
                [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            NSString *str = request.responseJSONObject[@"msg"];
            if ([NSObject isString:str]) {
                [NSObject showStr:str];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [NSObject showStr:@"删除失败！"];

            if ([request.response.URL.path containsString:@"/login.jsp"]) {
                //            [BaseViewController goToLoginVC];
                [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                    [BaseViewController configLogOutStatus];
                }];
            }
        }];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //获取数据
        ProductModel *productM = self.dataSourceArray[indexPath.row];
        //获取product的详情
        Api_GetProductDetail *getProductListApi = [[Api_GetProductDetail alloc] initWithProductId:productM.pdId];
        [getProductListApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"商品详情数据：%@",request.responseJSONObject[@"data"]);
            ProductModel *productDetailM = [[ProductModel alloc] initWithDictionary:request.responseJSONObject[@"data"] error:nil];
            AddProductViewController *vc = [[AddProductViewController alloc]init];
            if ([productDetailM.cateType isEqualToString:@"1"]) {
                vc.isEquipment = YES;
            }
            if ([productDetailM.cateType isEqualToString:@"2"]) {
                vc.isEquipment = NO;
            }
            vc.isEdit = YES;
            vc.productM = productDetailM;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(__kindof YTKBaseRequest *request) {
            NSLog(@"Api_GetProductList failed");
            [NSObject showStr:@"获取数据失败！"];
            if ([request.response.URL.path containsString:@"/login.jsp"]) {
                //            [BaseViewController goToLoginVC];
                [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                    [BaseViewController configLogOutStatus];
                }];
            }
        }];
    }];
    editAction.backgroundColor = [UIColor grayColor];
//    return @[deleteAction, editAction];
    if (self.isMineIn) {
        return @[deleteAction, editAction];
    }else{
        return @[];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isMineIn) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!tableView.editing) {
        ProductModel *productM = self.dataSourceArray[indexPath.row];
        ProductDetailViewController *vc = [ProductDetailViewController new];
        vc.productM = productM;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

