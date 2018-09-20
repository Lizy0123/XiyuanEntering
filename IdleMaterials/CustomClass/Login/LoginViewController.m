//
//  LoginViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "Api_Login.h"
#import "Api_SendLoginCode.h"
#import "YTKNetworkConfig.h"
#import "TabBarControllerConfig.h"
#import "Api_GetUserInfo.h"

#define paddingLeft 16*2
#define lineWidth kScreen_Width - paddingLeft*2

#define paddingTop (((kScreen_Width - kMyPadding*6)/4.3))
#define MyHeight 50

@interface LoginViewController ()<UITextFieldDelegate, UITabBarControllerDelegate>
@property(strong, nonatomic)UIScrollView *myScrollView;
@property(strong, nonatomic)UIButton *mobileCodeBtn;
@property(strong, nonatomic)UIButton *showPassBtn;
@property(strong, nonatomic)UIImageView *topImageView;
@property(strong, nonatomic)UITextField *accountField;
@property(strong, nonatomic)UITextField *passwordField;
@property(strong, nonatomic)UITextField *mobileField;
@property(strong, nonatomic)UITextField *mobileCodeField;
@property(strong, nonatomic)UIButton *bottomBtn;
@property(assign, nonatomic)float contentSizeHeight;
@end

@implementation LoginViewController

-(UIScrollView *)myScrollView{
    if (!_myScrollView) {
        //ScrollView
        _myScrollView = [[UIScrollView alloc] init];
        _myScrollView.userInteractionEnabled = YES;
//        _myScrollView.showsHorizontalScrollIndicator = _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.bounces = YES;
        _myScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        CGFloat topImageViewY = kScreen_Height/2 - 50*2 - paddingTop -100<=0?16:kScreen_Height/2 - 50*2 - paddingTop -100;

        self.topImageView.frame = CGRectMake(kMyPadding*3, topImageViewY, kScreen_Width - kMyPadding *6, paddingTop);
        
        [_myScrollView addSubview:self.topImageView];
        
        self.contentSizeHeight += kScreen_Height/2 - 50*2;
        //账号
        self.accountField.frame = CGRectMake(paddingLeft, self.contentSizeHeight, lineWidth, MyHeight);
        [_myScrollView addSubview:_accountField];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.accountField.frame), CGRectGetMaxY(self.accountField.frame), CGRectGetWidth(self.accountField.frame), 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView];
        self.contentSizeHeight += MyHeight;

        //密码
        self.passwordField.frame = CGRectMake(CGRectGetMinX(self.accountField.frame), CGRectGetMaxY(_accountField.frame), kScreen_Width - paddingLeft*2, MyHeight);
        [_myScrollView addSubview:_passwordField];
//        self.showPassBtn.frame = CGRectMake(CGRectGetMaxX(self.passwordField.frame), CGRectGetMaxY(_accountField.frame)+9, 50, 30);
//        [_myScrollView addSubview:self.showPassBtn];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame), CGRectGetWidth(self.accountField.frame), 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView1];
        self.contentSizeHeight += MyHeight;

        //手机号
        self.mobileField.frame = CGRectMake(CGRectGetMinX(self.accountField.frame),  CGRectGetMaxY(_passwordField.frame), kScreen_Width - paddingLeft*2, MyHeight);
        [_myScrollView addSubview:_mobileField];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.mobileField.frame), CGRectGetMaxY(self.mobileField.frame), CGRectGetWidth(self.accountField.frame), 1)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView2];
        self.contentSizeHeight += MyHeight;

        //验证码
        self.mobileCodeField.frame = CGRectMake(CGRectGetMinX(self.accountField.frame),  CGRectGetMaxY(_mobileField.frame), kScreen_Width - paddingLeft*2, MyHeight);
        [_myScrollView addSubview:_mobileCodeField];
//        self.mobileCodeBtn.frame = CGRectMake(CGRectGetMaxX(self.mobileCodeField.frame), CGRectGetMaxY(_mobileField.frame)+9, 100, 30);
//        [_myScrollView addSubview:self.mobileCodeBtn];
//        self.mobileCodeBtn.userInteractionEnabled = YES;
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.mobileCodeField.frame), CGRectGetMaxY(self.mobileCodeField.frame), CGRectGetWidth(self.accountField.frame), 1)];
        lineView3.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView3];
        self.contentSizeHeight += MyHeight;

        
        self.bottomBtn.center = CGPointMake(kScreen_Width/2, CGRectGetMaxY(_mobileField.frame)+100);
        [_myScrollView addSubview:_bottomBtn];
        self.contentSizeHeight += MyHeight;
        _myScrollView.contentSize = CGSizeMake(kScreen_Width, self.contentSizeHeight);
    }return _myScrollView;
}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, paddingTop)];
        _topImageView.image = [UIImage imageNamed:@"MyImages"];
    }return _topImageView;
}
-(UITextField *)accountField{
    if (!_accountField) {
        _accountField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, kScreen_Width - paddingLeft*2, MyHeight)];
        _accountField.placeholder = @"登录账号";
        _accountField.borderStyle = UITextBorderStyleNone;
        _accountField.delegate = self;
        _accountField.layer.cornerRadius = 5;
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;

//        _accountField.layer.borderColor = [[UIColor whiteColor] CGColor];
//        _accountField.layer.borderWidth = 0.5;
        _accountField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _accountField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"Account"];
        [_accountField.leftView addSubview:imgUser];
    }return _accountField;
}
-(UITextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"登录密码";
        _passwordField.borderStyle = UITextBorderStyleNone;

        _passwordField.delegate = self;
        _passwordField.layer.cornerRadius = 5;
        _passwordField.keyboardType = UIKeyboardTypeDefault;
//        _passwordField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        _passwordField.layer.borderWidth = 0.5;
        _passwordField.secureTextEntry = YES;
        _passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"Password"];
        [_passwordField.leftView addSubview:imgUser];
        _passwordField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
        _passwordField.rightView = self.showPassBtn;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;

    }return _passwordField;
}
-(UIButton *)showPassBtn{
    if (!_showPassBtn) {
        //密码可见按钮
        _showPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPassBtn setFrame:CGRectMake(0, 0, 50, 30)];
        [_showPassBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_showPassBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_showPassBtn setImage:[UIImage imageNamed:@"ShowPassword"] forState:UIControlStateSelected];
        [_showPassBtn setImage:[UIImage imageNamed:@"HidPassword"] forState:UIControlStateNormal];
        [_showPassBtn addTarget:self action:@selector(actionShowPassBtn:) forControlEvents:UIControlEventTouchUpInside];
    }return _showPassBtn;
}
-(UITextField *)mobileField{
    if (!_mobileField) {
        _mobileField = [[UITextField alloc] init];
        _mobileField.placeholder = @"手机号码";
        _mobileField.borderStyle = UITextBorderStyleNone;
        _mobileField.keyboardType = UIKeyboardTypeNumberPad;

        _mobileField.delegate = self;
        _mobileField.layer.cornerRadius = 5;
//        _mobileField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        _mobileField.layer.borderWidth = 0.5;
        _mobileField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _mobileField.leftViewMode = UITextFieldViewModeAlways;
        _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"Mobile"];
        [_mobileField.leftView addSubview:imgUser];
    }return _mobileField;
}
-(UITextField *)mobileCodeField{
    if (!_mobileCodeField) {
        _mobileCodeField = [[UITextField alloc] init];
        _mobileCodeField.placeholder = @"短信验证码";
        _mobileCodeField.borderStyle = UITextBorderStyleNone;
        _mobileCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mobileCodeField.keyboardType = UIKeyboardTypeNumberPad;

        _mobileCodeField.delegate = self;
        _mobileCodeField.layer.cornerRadius = 5;
//        _mobileCodeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        _mobileCodeField.layer.borderWidth = 0.5;
        _mobileCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _mobileCodeField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"MobileCode"];
        [_mobileCodeField.leftView addSubview:imgUser];
        _mobileCodeField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _mobileCodeField.rightViewMode = UITextFieldViewModeAlways;
        _mobileCodeField.rightView = self.mobileCodeBtn;
    }return _mobileCodeField;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        CGFloat btnHeight = 44;
        CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width - paddingLeft*2;
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setSize:CGSizeMake(btnWidth, btnHeight)];
        [_bottomBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_bottomBtn setCornerRadius:btnHeight/2];
        [_bottomBtn setBackgroundColor:kColorMain];
        [_bottomBtn addTarget:self action:@selector(actionBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    }return _bottomBtn;
}
-(UIButton *)mobileCodeBtn{
    if (!_mobileCodeBtn) {
        _mobileCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileCodeBtn.size = CGSizeMake(100, 30);
        [_mobileCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mobileCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _mobileCodeBtn.clipsToBounds = YES;
        _mobileCodeBtn.layer.cornerRadius = 15;
        _mobileCodeBtn.backgroundColor = kColorMain;
        _mobileCodeBtn.userInteractionEnabled = NO;
        _mobileCodeBtn.alpha = 0.5;
        
        [_mobileCodeBtn addTarget:self action:@selector(actionMobileCode) forControlEvents:UIControlEventTouchUpInside];
    }return _mobileCodeBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"登录"];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.accountField.text = @"滦平建龙";
//    self.passwordField.text = @"123456";
//    self.mobileField.text = @"18332795480";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel)];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    //添加所有TextField监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:)name:UITextFieldTextDidChangeNotification object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)textFieldChanged:(NSNotification *)notification{
    if (self.accountField.text.length >0&& self.passwordField.text.length >= 3&& [NSObject isMobileNumber:self.mobileField.text] ) {
        self.mobileCodeBtn.userInteractionEnabled = YES;
        self.mobileCodeBtn.alpha = 1;
        self.bottomBtn.userInteractionEnabled = YES;
        self.bottomBtn.alpha = 1;
        [self.bottomBtn setBackgroundColor:kColorMain];
    }
    else{
        self.mobileCodeBtn.userInteractionEnabled = YES;
        self.mobileCodeBtn.alpha = 0.5;
        self.bottomBtn.userInteractionEnabled = YES;
        self.bottomBtn.alpha = 0.5;
        [self.bottomBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}
-(void)actionCancel{
    [self dismissViewControllerAnimated:YES completion:^{
        TabBarControllerConfig *tabBarControllerConfig = [[TabBarControllerConfig alloc] init];
        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
        tabBarController.delegate = self;
        tabBarController.selectedIndex = 0;
    }];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (![self.accountField isExclusiveTouch] | ![self.passwordField isExclusiveTouch] | ![self.mobileField isExclusiveTouch]| ![self.mobileCodeField isExclusiveTouch]  ) {
//        [self.accountField resignFirstResponder];
//        [self.passwordField resignFirstResponder];
//        [self.mobileField resignFirstResponder];
//        [self.mobileCodeField resignFirstResponder];
//    }
//}

-(void)actionBottomBtn{
    if (![NSObject isString:_accountField.text]) {
        [NSObject showStr:@"请输入账号"];
        return;
    }
    if (![NSObject isMobileNumber:_mobileField.text]) {
        [NSObject showStr:@"请输入手机号"];
        return;
    }
    if (![NSObject isInt:_mobileCodeField.text]) {
        [NSObject showStr:@"请输入验证码"];
        return;
    }

    //如果实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    Api_Login *loginApi = [[Api_Login alloc] initWithUserName:_accountField.text password:_passwordField.text mobile:_mobileField.text mobileCode:_mobileCodeField.text];


    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //注意：你可以直接在block回调中使用 self，不用担心循环引用。因为 YTKRequest 会在执行完 block 回调之后，将相应的 block 设置成 nil。从而打破循环引用
        //        [self showResultLog:request];
        //dictFromJsonData(request.responseData)
        /*
         LzyHeader:    {
         Set-Cookie = "JSESSIONID=ba14e4fa-3cd5-44af-9638-f9ddf664bee5; Path=/XiYuanControl; HttpOnly, rememberMe=deleteMe; Path=/XiYuanControl; Max-Age=0; Expires=Tue, 27-Mar-2018 05:43:39 GMT",
         Transfer-Encoding = "Identity",
         Content-Type = "application/json;charset=UTF-8",
         Server = "Apache-Coyote/1.1",
         Date = "Wed, 28 Mar 2018 05:43:39 GMT",
         }

         */
        if ([request.responseJSONObject[@"code"] integerValue] == 0) {
            NSString*urlStr=[NSString stringWithFormat:@"%@%@",[YTKNetworkConfig sharedConfig].baseUrl,@"login"];
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlStr]];//得到cookie
            NSString*JSESSIONID=@"";
            for (NSHTTPCookie*cookie in cookies) {
                if ([cookie.name isEqualToString:kSessionId]) {
                    JSESSIONID=cookie.value;
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:JSESSIONID forKey:kSessionId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //ps ：我们也可以得到cookie里面的session和其他信息
            NSLog(@"Lzylalala:%@",kStringSessionId);//b2f924e-1d1c-4536-97db-0cb347489344
            //将得到的cookie保存一下
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self actionCancel];
        }else if ([request.responseJSONObject[@"code"] integerValue] == 500){
            NSString *str = request.responseJSONObject[@"msg"];
            [NSObject ToastShowStr:str];
        }
        [self serveUserData];
        NSLog(@"LLYTKLoginApi succeed");
        NSLog(@"LLYTKLoginApi succeed");
        NSLog(@"requestArgument:%@",request.requestArgument);
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"LLYTKLoginApi failed");
        NSLog(@"LLYTKLoginApi failed");
        
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    }];
}
-(void)serveUserData{
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
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"LLYTKGetUserInfoApi failed");
        NSLog(@"LLYTKGetUserInfoApi failed");
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseSerializerType:%ld",(long)request.responseSerializerType);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    }];
}
-(void)actionShowPassBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passwordField.secureTextEntry = NO;
    }else{
        _passwordField.secureTextEntry = YES;
    }
}

// 开启倒计时效果
-(void)actionMobileCode{
    Api_SendLoginCode *sendCodeApi = [[Api_SendLoginCode alloc] initWithMobile:_mobileField.text];
        [sendCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"sendCodeApi succeed");
            NSLog(@"sendCodeApi succeed");
            
            NSLog(@"requestArgument:%@",request.requestArgument);
            NSLog(@"responseHeaders:%@",request.responseHeaders);
            NSLog(@"response:%@",request.response);
            NSLog(@"responseData:%@",request.responseData);
            NSLog(@"responseString:%@",request.responseString);
            NSLog(@"responseJSONObject:%@",request.responseJSONObject);
            
            if ([[request.responseJSONObject[@"code"] stringValue] isEqualToString:@"0"]) {
                [NSObject showStr:@"验证码发送成功"];
                NSString*urlStr=[NSString stringWithFormat:@"%@%@",[YTKNetworkConfig sharedConfig].baseUrl,@"login"];
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlStr]];//得到cookie
                NSString*JSESSIONID=@"";
                for (NSHTTPCookie*cookie in cookies) {
                    if ([cookie.name isEqualToString:kSessionId]) {
                        JSESSIONID=cookie.value;
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:JSESSIONID forKey:kSessionId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //ps ：我们也可以得到cookie里面的session和其他信息
                NSLog(@"Lzylalala:%@",kStringSessionId);//b2f924e-1d1c-4536-97db-0cb347489344
                
                __block NSInteger time = 59; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(time <= 0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮的样式
                            [self.mobileCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                            [self.mobileCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            self.mobileCodeBtn.userInteractionEnabled = YES;
                        });
                    }else{
                        int seconds = time % 60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置按钮显示读秒效果
                            [self.mobileCodeBtn setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                            [self.mobileCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            self.mobileCodeBtn.userInteractionEnabled = NO;
                        });
                        time--;
                    }
                });
                dispatch_resume(_timer);
            }else{
                NSString *str = request.responseJSONObject[@"msg"];
                if ([NSObject isString:str]) {
                    [NSObject showStr:str];
                }
            }
            
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [NSObject showStr:@"验证码发送失败"];

            NSLog(@"LLYTKsendCodeApi failed");
            NSLog(@"LLYTKsendCodeApi failed");
            
            NSLog(@"requestArgument:%@",request.requestArgument);
            NSLog(@"responseHeaders:%@",request.responseHeaders);
            NSLog(@"response:%@",request.response);
            NSLog(@"responseData:%@",request.responseData);
            NSLog(@"responseString:%@",request.responseString);
            NSLog(@"responseJSONObject:%@",request.responseJSONObject);
        }];
    
    
    
    
//    NSString *phoneType = @"0";
//    NSString *url = [@"http://192.168.0.13/XYGPWuzi_App/" stringByAppendingString:[NSString stringWithFormat:@"xy/user/send/%@/%@.json",_mobileField.text,phoneType]];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:_mobileField.text forKey:@"phoneNumber"];
//    [dict setObject:phoneType forKey:@"phoneType"];
//    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"成功了返回---%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"成功了返回---%@",error);
//    }];
}

@end
