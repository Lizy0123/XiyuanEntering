//
//  BaseViewController.m
//  Taoyi
//
//  Created by Lzy on 2018/1/27.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "BaseTabBarController.h"

#pragma mark - UIViewController (Dismiss)
@interface UIViewController (Dismiss)
- (void)dismissModalVC;
@end
@implementation UIViewController (Dismiss)
- (void)dismissModalVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(void)configLogOutStatus{
//    UserModel *userM = [[UserModel alloc] init];
//    userM.loginMobile = nil;
//    userM.fullName = nil;
//    userM.deptName = nil;
//    userM.positionName = nil;
//
//    userM.headPic = nil;
//    userM.companyName = nil;
//    userM.cpId = nil;
//    userM.accType = nil;
    
//    [UserManager saveUserInfo:userM];
}
#pragma mark - Action
+(UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[BaseTabBarController class]]) {
        result = [(BaseTabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
+(void)presentVC:(UIViewController *)viewController hasNav:(BOOL)hasNav{
    if (!viewController) {
        return;
    }
    if (hasNav) {
        UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        if (!viewController.navigationItem.leftBarButtonItem) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalVC)];
        }
        [[self presentingVC] presentViewController:nav animated:YES completion:nil];
    }else{
        [[self presentingVC] presentViewController:viewController animated:YES completion:nil];
    }
}
+(void)goToVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [self presentingVC].navigationController;
    if (nav) {
        [nav pushViewController:viewController animated:YES];
    }
}

-(void)goToLoginVC{
    LoginViewController *vc = [LoginViewController new];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalVC)];
    vc.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

+(void)goToLoginVC{
    LoginViewController *vc = [LoginViewController new];
//    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalVC)];
//    vc.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [BaseViewController presentVC:[[BaseNavigationController alloc] initWithRootViewController:vc] hasNav:NO];
}

@end

