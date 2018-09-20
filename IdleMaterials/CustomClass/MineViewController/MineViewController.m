//
//  MineViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "MineViewController.h"
#import "HomeViewController.h"
#import "AboutUsViewController.h"
#import "ChangeMobileViewController.h"
#import "Api_GetUserInfo.h"
#import "YTKNetworkConfig.h"
#import "LoginViewController.h"


@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *myTableView;
@property(nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic, strong)UIView *tableFooterView;
@property(assign, nonatomic)BOOL isLogin;
@property(strong, nonatomic)UIImageView *headImageView;
@property(strong, nonatomic)UILabel *titleLabel;
@end

@implementation MineViewController

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        //        _myTableView.bounces = NO;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _myTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _myTableView.sectionIndexColor = [UIColor groupTableViewBackgroundColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.allowsMultipleSelectionDuringEditing = YES;
        _myTableView.tableHeaderView = self.tableHeaderView;

    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"会员中心"];
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
/*
 GetUserInfoApi result ->    {
 data =     {
 href = <null>,
 creTime = "2018-03-28 08:33:27",
 jobNo = "滦平建龙_5566",
 dmId = <null>,
 lmId = "d73793fec2a84b32904c2777ed62ed1a",
 hasAuthority = <null>,
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
 modUser = <null>,
 phones = "13121866293",
 delFlag = "0",
 modTime = <null>,
 name = <null>,
 newLoginTime = "2018-03-28 14:41:40",
 positionName = "子公司管理员",
 loginMobile = "13121866293",
 deptName = "子公司管理员",
 cpId = "e809c0038ddb487492a0be3900830f59",
 adminFlag = "0",
 oldLoginTime = "2018-03-28 13:48:47",
 ptId = "a2fa2ce602c24e28958fcf049974cc3a",
 positionJob =     {
 operUser = "admin",
 dmId = "f48cdce910ca436cb9ea42a591f43e7c",
 delFlag = "0",
 department =     {
 spread = <null>,
 dmId = "f48cdce910ca436cb9ea42a591f43e7c",
 delFlag = "0",
 children = <null>,
 deptName = "子公司管理员",
 modTime = "2018-03-19 09:39:08",
 cpId = "e809c0038ddb487492a0be3900830f59",
 operUser = "admin",
 name = <null>,
 creTime = "2018-03-19 09:39:08",
 },
 modTime = "2018-03-19 09:39:08",
 name = <null>,
 href = <null>,
 posiName = "子公司管理员",
 ptId = "a2fa2ce602c24e28958fcf049974cc3a",
 posiCode = "滦平建龙_admin",
 creTime = "2018-03-19 09:39:08",
 },
 remark = <null>,
 fullName = "李宗洋",
 },
 code = 0,
 }
 
 
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([((NSString *)kStringSessionId) length]>0) {
        self.isLogin = YES;
        _myTableView.tableFooterView = self.tableFooterView;
    }
    Api_GetUserInfo *getUserInfoApi = [[Api_GetUserInfo alloc] initWithUserId:@""];
    [getUserInfoApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"GetUserInfoApi result ->%@",request.responseJSONObject[@"data"]);

        UserModel *userM = [[UserModel alloc] init];
        userM.loginMobile = request.responseJSONObject[@"data"][@"loginMobile"];
        userM.fullName = request.responseJSONObject[@"data"][@"fullName"];
        userM.deptName = request.responseJSONObject[@"data"][@"deptName"];
        userM.positionName = request.responseJSONObject[@"data"][@"positionName"];
        
        userM.headPic = request.responseJSONObject[@"data"][@"companyInfo"][@"headPic"];
        userM.companyName = request.responseJSONObject[@"data"][@"companyInfo"][@"companyName"];
        userM.cpId = request.responseJSONObject[@"data"][@"companyInfo"][@"cpId"];
        userM.accType = request.responseJSONObject[@"data"][@"companyInfo"][@"accType"];

        [UserManager saveUserInfo:userM];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[YTKNetworkConfig sharedConfig].cdnUrl,[UserManager readUserInfo].headPic]] placeholderImage:[UIImage imageNamed:@"logo"]];
        [self.titleLabel setText:[UserManager readUserInfo].companyName];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        UserModel *userM = [[UserModel alloc] init];
        userM.loginMobile = @"";
        userM.fullName =  @"";
        userM.deptName =  @"";
        userM.positionName =  @"";
        
        userM.headPic =  @"";
        userM.companyName =  @"";
        userM.cpId =  @"";
        userM.accType =  @"";
        [UserManager saveUserInfo:userM];
        
        NSLog(@"LLYTKGetUserInfoApi failed");
        NSLog(@"LLYTKGetUserInfoApi failed");
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseSerializerType:%ld",(long)request.responseSerializerType);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}
-(UIView *)tableHeaderView{
    CGFloat imageViewWidth = 90;
    CGFloat headerViewHeight = 180;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, headerViewHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - imageViewWidth)/2, (headerViewHeight - imageViewWidth)/2, imageViewWidth, imageViewWidth)];
    imageView.image = [UIImage imageNamed:@"logo"];
    imageView.clipsToBounds = YES;
    imageView.cornerRadius = imageViewWidth/2;
    [backView addSubview:imageView];
    self.headImageView = imageView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+5, kScreen_Width, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"";
    [backView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    return backView;
}

-(UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
        UIButton *button = [UIButton buttonWithStyle:StrapDefaultStyle andTitle:@"退出登录" andFrame:CGRectMake(16, 80, kScreen_Width-32, 44) target:self action:@selector(actionUserLogOut)];
        [_tableFooterView addSubview:button];
        
    }return _tableFooterView;
}


-(void)actionUserLogOut{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kSessionId];
    LoginViewController *vc = [[LoginViewController alloc] init];
    
    BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nv animated:YES completion:^{
        
    }];
}






#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else if (section == 1){
        return 1;
    }
    else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"登录手机";
                cell.detailTextLabel.text = [UserManager readUserInfo].loginMobile;
            }
                break;
            case 1:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"登录人";
                cell.detailTextLabel.text = [UserManager readUserInfo].fullName;
            }
                break;
            case 2:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"所属部门";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",[UserManager readUserInfo].deptName,[UserManager readUserInfo].positionName];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"已上传商品";
        cell.detailTextLabel.text = @"点击查看";
    }
    else{
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"客服热线";
                cell.imageView.image = [UIImage imageNamed:@"kefuCenter"];
            }
                break;
            case 1:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"关于我们";
                cell.imageView.image = [UIImage imageNamed:@"sheZhi"];
            }
                break;
            case 2:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"修改登录手机";
                cell.imageView.image = [UIImage imageNamed:@"sheZhi"];
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"登录手机");

            if ([kStringToken length]) {
//                OpenAccountViewController *vc = [[OpenAccountViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                LoginViewController *loginVC = [[LoginViewController alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//                [self presentViewController:nav animated:YES completion:^{
//                }];
            }
        }else if (indexPath.row == 1){
            NSLog(@"登录人");

        }else{
            NSLog(@"所属部门");

        }
    }
    else if (indexPath.section == 1) {
        HomeViewController *vc = [[HomeViewController alloc] init];
        vc.isMineIn = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:{
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"03153859900"]; UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
                break;
            case 1:{
                AboutUsViewController *vc = [[AboutUsViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                ChangeMobileViewController *vc = [[ChangeMobileViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
@end
