//
//  MyGuidePageViewController.m
//  Taoyi
//
//  Created by Lzy on 2018/2/1.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "MyGuidePageViewController.h"
#import "MyGuidePageView.h"
#import "AppDelegate.h"

@interface MyGuidePageViewController ()

@end

@implementation MyGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //保存当前版本
//    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *appVersion = [userDefaults objectForKey:@"appVersion"];
//    if (appVersion == nil || ![appVersion isEqualToString:currentAppVersion]) {// 判断当前版本和之前版本，如果为nil或不一样，执行启动图
//        [userDefaults setValue:currentAppVersion forKey:@"appVersion"];
//        // 静态引导页
//        [self setStaticGuidePage];
//        // 动态引导页
//        // [self setDynamicGuidePage];
//        // 视频引导页
//        // [self setVideoGuidePage];
//    }
    [self setStaticGuidePage];

    // 设置该控制器背景图片
//    UIImageView *bg_imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    [bg_imageView setImage:[UIImage imageNamed:@"view_bg_image"]];
//    [self.view addSubview:bg_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"MyHeight",@"MyHeight",@"MyHeight",@"MyHeight",@"MyHeight"];
    MyGuidePageView *guidePage = [[MyGuidePageView alloc] initWithFrame:self.view.frame imageNameArray:imageNameArray isButtonHidden:NO];
    guidePage.slideInto = YES;
    guidePage.block = ^{
        [((AppDelegate *)[UIApplication sharedApplication].delegate) configTabBarController];
    };
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark - 设置APP动态图片引导页
- (void)setDynamicGuidePage {
    NSArray *imageNameArray = @[@"guideImage6.gif",@"guideImage7.gif",@"guideImage8.gif"];
    MyGuidePageView *guidePage = [[MyGuidePageView alloc] initWithFrame:self.view.frame imageNameArray:imageNameArray isButtonHidden:YES];
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark - 设置APP视频引导页
- (void)setVideoGuidePage {
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guideMovie1" ofType:@"mov"]];
    MyGuidePageView *guidePage = [[MyGuidePageView alloc] initWithFrame:self.view.bounds videoURL:videoURL];
    [self.navigationController.view addSubview:guidePage];
}

@end
