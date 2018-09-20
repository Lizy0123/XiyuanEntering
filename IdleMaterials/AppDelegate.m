//
//  AppDelegate.m
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "MyGuidePageViewController.h"
#import "TabBarControllerConfig.h"
#import "FLEX.h"

//NetManager
#import "YTKNetworkConfig.h"
#import "YTKNetworkAgent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (void)setHTTPRequestConfig{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    //Debug url
//  config.baseUrl = @"http://192.168.0.161:8081/XiYuanControl/";//Mr.Wangxuechun
//    config.baseUrl = @"http://192.168.0.13/XiYuanControl/";
//    config.cdnUrl = @"http://192.168.0.14/XiYuanUpload/"; //http://www.lilongcnc.cc/lauren_picture/20160203/1.png
//
    
    //Release url
        config.baseUrl = @"http://jianlong.gpwuzi.com/";
        config.cdnUrl = @"http://img.gpwuzi.com/XiYuanUpload/";
    
    //设置全局请求公共参数
    //    LLYTKUrlCommonParamsFilter *urlFilter = [LLYTKUrlCommonParamsFilter my_filterWithArguments:
    //                                                @{@"version": @"1.0"}];
    
    //    [config addUrlFilter:urlFilter];
    
    //KVC返回设置contentType
    //    NSSet *contentTypeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil];
    //    [[YTKNetworkAgent sharedAgent] setValue:contentTypeSet forKeyPath:@"_manager.responseSerializer.acceptableContentTypes"];
    
}


-(void)configRootViewController{
    //保存当前版本
//    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *appVersion = [userDefaults objectForKey:@"appVersion"];
    
    //    判断当前版本和之前版本，如果为nil或不一样，执行启动图
//    if (appVersion == nil || ![appVersion isEqualToString:currentAppVersion]) {
//        [userDefaults setValue:currentAppVersion forKey:@"appVersion"];
//        [self.window setRootViewController:[[BaseNavigationController alloc] initWithRootViewController:[MyGuidePageViewController new]]];
//    }else{
        [self configTabBarController];
//    }
}
-(void)configAppearance{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//设置状态栏的颜色模式
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorMain withFrame:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.f], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];//返回按钮的箭头颜色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:kColorMain];
    
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.001], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[UITextField appearance] setTintColor:kColorMain];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:kColorMain]; //设置UITextView的光标颜色
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xF2F4F6"] withFrame:CGRectMake(0, 0, 1, 1)] forBarPosition:0 barMetrics:UIBarMetricsDefault];
    
    ///navigation背景图
    //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbg"] forBarMetrics:UIBarMetricsDefault];
    //    [UINavigationBar appearance].translucent = NO;
    
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}
-(void)configTabBarController{
    [PlusButtonSubclass registerPlusButton];
    [self.window setRootViewController:[TabBarControllerConfig new].tabBarController];
}
-(void)configDebugTool{
#pragma mark - Flex
#ifdef DEBUG
    [[FLEXManager sharedManager] showExplorer];
#else
#endif
}
//----------------------------------------------------------------------------------------------


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    [self configDebugTool];
    [self setHTTPRequestConfig];
    [self configAppearance];
    [self configRootViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end


