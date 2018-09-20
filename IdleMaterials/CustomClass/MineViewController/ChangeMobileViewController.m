//
//  ChangeMobileViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "ChangeMobileViewController.h"
#import "Api_UpdateLoginMobile.h"
#import "Api_SendUpdateLoginMobileCode.h"

#define paddingLeft 16*3
#define lineWidth kScreen_Width - paddingLeft*2

#define paddingTop (((kScreen_Width - kMyPadding*3)/4.3))
#define height 50

@interface ChangeMobileViewController ()<UITextFieldDelegate>
@property(strong, nonatomic)UIScrollView *myScrollView;
@property(strong, nonatomic)UIButton *mobileCodeBtnUp;
@property(strong, nonatomic)UIButton *mobileCodeBtnBottom;
@property(strong, nonatomic)UIImageView *topImageView;
@property(strong, nonatomic)UITextField *oldMobileField;
@property(strong, nonatomic)UITextField *oldMobileCodeField;
@property(strong, nonatomic)UITextField *newMobileField;
@property(strong, nonatomic)UITextField *newMobileCodeField;
@property(strong, nonatomic)UIButton *bottomBtn;

@end

@implementation ChangeMobileViewController

-(UIScrollView *)myScrollView{
    if (!_myScrollView) {
        //ScrollView
        _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _myScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

        self.topImageView.frame = CGRectMake(kMyPadding*3, kMyPadding, kScreen_Width - kMyPadding *6, paddingTop);
        [_myScrollView addSubview:self.topImageView];
        //原手机号
        self.oldMobileField.frame = CGRectMake(paddingLeft, paddingTop + kMyPadding *2, lineWidth, height);
        [_myScrollView addSubview:_oldMobileField];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.oldMobileField.frame), CGRectGetMaxY(self.oldMobileField.frame), CGRectGetWidth(self.oldMobileField.frame), 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView];
        //原手机号验证码
        self.oldMobileCodeField.frame = CGRectMake(CGRectGetMinX(self.oldMobileField.frame), CGRectGetMaxY(_oldMobileField.frame), kScreen_Width - paddingLeft*2 - 100, height);
        [_myScrollView addSubview:_oldMobileCodeField];
        self.mobileCodeBtnUp.frame = CGRectMake(CGRectGetMaxX(self.oldMobileCodeField.frame), CGRectGetMaxY(_oldMobileField.frame)+9, 100, 30);
        [_myScrollView addSubview:self.mobileCodeBtnUp];
        self.mobileCodeBtnUp.userInteractionEnabled = YES;
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.oldMobileCodeField.frame), CGRectGetMaxY(self.oldMobileCodeField.frame), CGRectGetWidth(self.oldMobileField.frame), 1)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView1];

        //新手机号
        self.newMobileField.frame = CGRectMake(CGRectGetMinX(self.oldMobileField.frame),  CGRectGetMaxY(_oldMobileCodeField.frame), kScreen_Width - paddingLeft*2, height);
        [_myScrollView addSubview:_newMobileField];
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.newMobileField.frame), CGRectGetMaxY(self.newMobileField.frame), CGRectGetWidth(self.oldMobileField.frame), 1)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView2];
        //新手机验证码
        self.newMobileCodeField.frame = CGRectMake(CGRectGetMinX(self.oldMobileField.frame),  CGRectGetMaxY(_newMobileField.frame), kScreen_Width - paddingLeft*2 - 100, height);
        [_myScrollView addSubview:_newMobileCodeField];
        self.mobileCodeBtnBottom.frame = CGRectMake(CGRectGetMaxX(self.newMobileCodeField.frame), CGRectGetMaxY(_newMobileField.frame)+9, 100, 30);
        [_myScrollView addSubview:self.mobileCodeBtnBottom];
        self.mobileCodeBtnBottom.userInteractionEnabled = YES;
        
        
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.newMobileCodeField.frame), CGRectGetMaxY(self.newMobileCodeField.frame), CGRectGetWidth(self.oldMobileField.frame), 1)];
        lineView3.backgroundColor = [UIColor lightGrayColor];
        [_myScrollView addSubview:lineView3];
        
        self.bottomBtn.center = CGPointMake(kScreen_Width/2, CGRectGetMaxY(_newMobileField.frame)+100);
        [_myScrollView addSubview:_bottomBtn];
    }return _myScrollView;
}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMyPadding, kMyPadding, kScreen_Width - kMyPadding *2, paddingTop)];
        _topImageView.image = [UIImage imageNamed:@"MyImages"];
    }return _topImageView;
}
-(UITextField *)oldMobileField{
    if (!_oldMobileField) {
        _oldMobileField = [[UITextField alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, kScreen_Width - paddingLeft*2, height)];
        _oldMobileField.placeholder = @"原手机号";
        _oldMobileField.borderStyle = UITextBorderStyleNone;
        _oldMobileField.delegate = self;
        _oldMobileField.layer.cornerRadius = 5;
        _oldMobileField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _oldMobileField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_oldMobileField.leftView addSubview:imgUser];
    }return _oldMobileField;
}
-(UITextField *)oldMobileCodeField{
    if (!_oldMobileCodeField) {
        _oldMobileCodeField = [[UITextField alloc] init];
        _oldMobileCodeField.placeholder = @"原手机号验证码";
        _oldMobileCodeField.borderStyle = UITextBorderStyleNone;
        _oldMobileCodeField.delegate = self;
        _oldMobileCodeField.layer.cornerRadius = 5;
        _oldMobileCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _oldMobileCodeField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_oldMobileCodeField.leftView addSubview:imgUser];
    }return _oldMobileCodeField;
}
-(UITextField *)newMobileField{
    if (!_newMobileField) {
        _newMobileField = [[UITextField alloc] init];
        _newMobileField.placeholder = @"新手机号";
        _oldMobileField.borderStyle = UITextBorderStyleNone;
        _newMobileField.delegate = self;
        _newMobileField.layer.cornerRadius = 5;;
        _newMobileField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _newMobileField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_newMobileField.leftView addSubview:imgUser];
    }return _newMobileField;
}
-(UITextField *)newMobileCodeField{
    if (!_newMobileCodeField) {
        _newMobileCodeField = [[UITextField alloc] init];
        _newMobileCodeField.placeholder = @"新手机号验证码";
        _newMobileCodeField.borderStyle = UITextBorderStyleNone;
        _newMobileCodeField.delegate = self;
        _newMobileCodeField.layer.cornerRadius = 5;
        _newMobileCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _newMobileCodeField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        imgUser.image = [UIImage imageNamed:@"iconfont-user"];
        [_newMobileCodeField.leftView addSubview:imgUser];
    }return _newMobileCodeField;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        CGFloat btnHeight = 44;
        CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width - paddingLeft*2;
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setSize:CGSizeMake(btnWidth, btnHeight)];
        [_bottomBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_bottomBtn setCornerRadius:btnHeight/2];
        [_bottomBtn setBackgroundColor:kColorMain];
        [_bottomBtn addTarget:self action:@selector(actionBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    }return _bottomBtn;
}
-(UIButton *)mobileCodeBtnUp{
    if (!_mobileCodeBtnUp) {
        _mobileCodeBtnUp = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileCodeBtnUp.size = CGSizeMake(100, 30);
        [_mobileCodeBtnUp setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mobileCodeBtnUp.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _mobileCodeBtnUp.clipsToBounds = YES;
        _mobileCodeBtnUp.layer.cornerRadius = 15;
        _mobileCodeBtnUp.backgroundColor = kColorMain;
        _mobileCodeBtnUp.userInteractionEnabled = NO;
        _mobileCodeBtnUp.alpha = 0.9;
        
        [_mobileCodeBtnUp addTarget:self action:@selector(actionMobileCodeUp) forControlEvents:UIControlEventTouchUpInside];
    }return _mobileCodeBtnUp;
}
-(UIButton *)mobileCodeBtnBottom{
    if (!_mobileCodeBtnBottom) {
        _mobileCodeBtnBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        _mobileCodeBtnBottom.size = CGSizeMake(100, 30);
        [_mobileCodeBtnBottom setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mobileCodeBtnBottom.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _mobileCodeBtnBottom.clipsToBounds = YES;
        _mobileCodeBtnBottom.layer.cornerRadius = 15;
        _mobileCodeBtnBottom.backgroundColor = kColorMain;
        _mobileCodeBtnBottom.userInteractionEnabled = NO;
        _mobileCodeBtnBottom.alpha = 0.9;
        
        [_mobileCodeBtnBottom addTarget:self action:@selector(actionMobileCodeDown) forControlEvents:UIControlEventTouchUpInside];
    }return _mobileCodeBtnBottom;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)actionBottomBtn{
    //如果实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    Api_UpdateLoginMobile *UpdateLoginMobileApi = [[Api_UpdateLoginMobile alloc] initWithOldMobjleCode:_oldMobileCodeField.text newMobileCode:_newMobileCodeField.text newMobile:_newMobileField.text];
    [UpdateLoginMobileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if ([request.responseJSONObject[@"code"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([request.responseJSONObject[@"code"] integerValue] == 500){
            NSString *str = request.responseJSONObject[@"msg"];
            [NSObject ToastShowStr:str];
        }
        NSLog(@"UpdateLoginMobile succeed");
        NSLog(@"UpdateLoginMobile succeed");
        NSLog(@"requestArgument:%@",request.requestArgument);
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"UpdateLoginMobileApi failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}
-(void)actionShowPassBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _oldMobileCodeField.secureTextEntry = NO;
    }else{
        _oldMobileCodeField.secureTextEntry = YES;
    }
}

// 开启倒计时效果
-(void)actionMobileCodeUp{
    Api_SendUpdateLoginMobileCode *SendUpdateLoginMobileCodeApi = [[Api_SendUpdateLoginMobileCode alloc] initWithMobile:_oldMobileField.text];
    [SendUpdateLoginMobileCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"SendUpdateLoginMobileCodeApi succeed");
        NSLog(@"SendUpdateLoginMobileCodeApi succeed");
        NSLog(@"requestArgument:%@",request.requestArgument);
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"SendUpdateLoginMobileCodeApi failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];


    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.mobileCodeBtnUp setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.mobileCodeBtnUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.mobileCodeBtnUp.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.mobileCodeBtnUp setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                [self.mobileCodeBtnUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.mobileCodeBtnUp.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
-(void)actionMobileCodeDown{
    Api_SendUpdateLoginMobileCode *SendUpdateLoginMobileCodeApi = [[Api_SendUpdateLoginMobileCode alloc] initWithMobile:_newMobileField.text];
    [SendUpdateLoginMobileCodeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"SendUpdateLoginMobileCodeApi succeed");
        NSLog(@"SendUpdateLoginMobileCodeApi succeed");
        NSLog(@"requestArgument:%@",request.requestArgument);
        NSLog(@"responseHeaders:%@",request.responseHeaders);
        NSLog(@"response:%@",request.response);
        NSLog(@"responseData:%@",request.responseData);
        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"SendUpdateLoginMobileCodeApi failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
    
    
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.mobileCodeBtnBottom setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.mobileCodeBtnBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.mobileCodeBtnBottom.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.mobileCodeBtnBottom setTitle:[NSString stringWithFormat:@"(%.2ds)", seconds] forState:UIControlStateNormal];
                [self.mobileCodeBtnBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.mobileCodeBtnBottom.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
