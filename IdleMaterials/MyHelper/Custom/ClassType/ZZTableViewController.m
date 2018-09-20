//
//  ZZTableViewController.m
//  ZZFoldCell
//
//  Created by 郭旭赞 on 2017/7/6.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "ZZTableViewController.h"
#import "ZZFoldCellModel.h"

#import "AFNetworking.h"
#import "Api_GetAllCategoryData.h"
@interface ZZTableViewController ()

@property(nonatomic,strong) NSMutableArray<__kindof ZZFoldCellModel *> *data;

@property(nonatomic,copy)NSString *firstName;
@property(nonatomic,copy)NSString *secondName;
@property(nonatomic,copy)NSString *thirdName;

@property(nonatomic,copy)NSString *firstId;
@property(nonatomic,copy)NSString *secondId;
@property(nonatomic,copy)NSString *thirdId;
@property(assign, nonatomic) NSIndexPath *selIndex;

@property(strong, nonatomic)UIButton *naviRightBtn;
@end

@implementation ZZTableViewController

-(UIButton *)naviRightBtn{
    if (!_naviRightBtn) {
        _naviRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_naviRightBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_naviRightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_naviRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_naviRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_naviRightBtn addTarget:self action:@selector((actionSave)) forControlEvents:UIControlEventTouchUpInside];
    }return _naviRightBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品类别";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kSafeAreaBottomHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightBtn];
    [self.naviRightBtn setEnabled:NO];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(actionSave)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self requestData];
    
//    self.data = [NSMutableArray new];
//    for (int i = 0; i < netData.count; i++) {
//        ZZFoldCellModel *foldCellModel = [ZZFoldCellModel modelWithDic:(NSDictionary *)netData[i]];
//        [self.data addObject:foldCellModel];
//    }
}
#pragma - action
-(void)requestData{
    Api_GetAllCategoryData *getAllCategoryDataApi = [[Api_GetAllCategoryData alloc] init];
    [getAllCategoryDataApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *netData = [NSArray array];
        if (self.isEquipment) {
            netData = request.responseJSONObject[@"data"][0][@"children"];
        }else{
            netData = request.responseJSONObject[@"data"][1][@"children"];
        }
        self.data = [NSMutableArray new];
        for (int i = 0; i < netData.count; i++) {
            ZZFoldCellModel *foldCellModel = [ZZFoldCellModel modelWithDic:(NSDictionary *)netData[i]];
            [self.data addObject:foldCellModel];
        }
        [self.tableView reloadData];
        NSLog(@"getAllCategoryDataApi succeed");
        NSLog(@"getAllCategoryDataApi succeed");
        
        //        NSLog(@"requestArgument:%@",request.requestArgument);
        //        NSLog(@"responseHeaders:%@",request.responseHeaders);
        //        NSLog(@"response:%@",request.response);
        //        NSLog(@"responseData:%@",request.responseData);
        //        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"getAllCategoryDataApi failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
    
    
    
    
    
    
//    NSString *proCategoryId = @"40288098472849cf0147284ed08e0002";
//    NSString *status = @"0";
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:proCategoryId forKey:@"proCategoryId"];
//    [dict setObject:status forKey:@"status"];
    
//    __weak typeof(self)weakSelf = self;
//    [[AFHTTPSessionManager manager] POST:[requestUrlHeader stringByAppendingString:@"xy/category/get.json"] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"----1-----%@",responseObject);
//        
//        NSArray *netData = responseObject[@"object"][0][@"childs"];
//        weakSelf.data = [NSMutableArray new];
//        for (int i = 0; i < netData.count; i++) {
//            ZZFoldCellModel *foldCellModel = [ZZFoldCellModel modelWithDic:(NSDictionary *)netData[i]];
//            [weakSelf.data addObject:foldCellModel];
//        }
//        [weakSelf.tableView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
}
-(void)actionSave{
    NSLog(@"----||%@------||%@------||%@",_firstName,_secondName,_thirdName);
    NSLog(@"----||%@------||%@------||%@",_firstId,_secondId,_thirdId);
    
    if (_nameBlock) {
        self.nameBlock(_firstName, _secondName, _thirdName);
        if (_idBlock) {
            self.idBlock(_firstId, _secondId, _thirdId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ZZFoldCellModel *foldCellModel = self.data[indexPath.row];
    if ([foldCellModel.level integerValue] == 2) {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.textLabel.text = [NSString stringWithFormat:@"◎%@",foldCellModel.text];;
    }
    if ([foldCellModel.level integerValue] == 3) {
        cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
        cell.textLabel.text = [NSString stringWithFormat:@"⊙ %@",foldCellModel.text];
    }
    if ([foldCellModel.level integerValue] == 4) {
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        cell.textLabel.text = [NSString stringWithFormat:@"○ %@",foldCellModel.text];
    }
    if (_selIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFoldCellModel *foldCellModel = self.data[indexPath.row];
    return foldCellModel.level.intValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFoldCellModel *didSelectFoldCellModel = self.data[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [tableView beginUpdates];
    if (didSelectFoldCellModel.belowCount == 0) {

        //Data
        NSArray *submodels = [didSelectFoldCellModel open];
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
        [self.data insertObjects:submodels atIndexes:indexes];
        if (submodels.count == 0) {
            [self.naviRightBtn setEnabled:YES];
        }else{
            [self.naviRightBtn setEnabled:NO];
        }
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"-----%@-------%@-----%@----%@",didSelectFoldCellModel.text,didSelectFoldCellModel.level,didSelectFoldCellModel.supermodel.text,didSelectFoldCellModel.supermodel.supermodel.text);
        
        if (didSelectFoldCellModel.supermodel.supermodel.text) {
            self.firstName = didSelectFoldCellModel.supermodel.supermodel.text;
            self.secondName = didSelectFoldCellModel.supermodel.text;
            self.thirdName = didSelectFoldCellModel.text;
            
            self.firstId = didSelectFoldCellModel.supermodel.supermodel.proCategoryId;
            self.secondId = didSelectFoldCellModel.supermodel.proCategoryId;
            self.thirdId = didSelectFoldCellModel.proCategoryId;
        }else{
            if (didSelectFoldCellModel.supermodel.text) {
                self.firstName = didSelectFoldCellModel.supermodel.text;
                self.secondName = didSelectFoldCellModel.text;
                self.thirdName = nil;
                
                self.firstId = didSelectFoldCellModel.supermodel.proCategoryId;
                self.secondId = didSelectFoldCellModel.proCategoryId;
                self.thirdId = nil;
            }else{
                self.firstName = didSelectFoldCellModel.text;
                self.secondName = nil;
                self.thirdName = nil;
                
                self.firstId = didSelectFoldCellModel.proCategoryId;
                self.secondId = nil;
                self.thirdId = nil;
            }
        }
    }else {
        //Data
        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
        [didSelectFoldCellModel closeWithSubmodels:submodels];
        [self.data removeObjectsInArray:submodels];
        
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        if (didSelectFoldCellModel.supermodel.supermodel.text) {
            self.firstName = didSelectFoldCellModel.supermodel.supermodel.text;
            self.secondName = didSelectFoldCellModel.supermodel.text;
            self.thirdName = didSelectFoldCellModel.text;
            
            self.firstId = didSelectFoldCellModel.supermodel.supermodel.proCategoryId;
            self.secondId = didSelectFoldCellModel.supermodel.proCategoryId;
            self.thirdId = didSelectFoldCellModel.proCategoryId;
        }else{
            if (didSelectFoldCellModel.supermodel.text) {
                self.firstName = didSelectFoldCellModel.supermodel.text;
                self.secondName = didSelectFoldCellModel.text;
                self.thirdName = nil;
                
                self.firstId = didSelectFoldCellModel.supermodel.proCategoryId;
                self.secondId = didSelectFoldCellModel.proCategoryId;
                self.thirdId = nil;
            }else{
                self.firstName = didSelectFoldCellModel.text;
                self.secondName = nil;
                self.thirdName = nil;
                
                self.firstId = didSelectFoldCellModel.proCategoryId;
                self.secondId = nil;
                self.thirdId = nil;
            }
        }
    }
    [tableView endUpdates];
    [tableView reloadData];
}
@end
