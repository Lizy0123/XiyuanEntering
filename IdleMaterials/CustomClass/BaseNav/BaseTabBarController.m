//
//  BaseTabBarController.m
//  Taoyi
//
//  Created by Lzy on 2018/1/30.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "BaseTabBarController.h"
#import "LoginViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    if ([item isEqual:[tabBar.items objectAtIndex:1]]) {
//        if ([kStringSessionId length]==0) {
//            LoginViewController *vc = [LoginViewController new];
//            BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:vc];
//            [self presentViewController:nv animated:YES completion:^{
//            }];
//        }
//    }
//}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isEqual:[tabBarController.viewControllers objectAtIndex:1]]) {
        NSLog(@"第一个");
    }
    if ([viewController isEqual:[tabBarController.viewControllers objectAtIndex:0]]) {
        NSLog(@"第0个");
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(viewController == [tabBarController.viewControllers objectAtIndex:1]){
        if ([kStringSessionId length]==0) {
            LoginViewController *vc = [LoginViewController new];
            BaseNavigationController *nv = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nv animated:YES completion:^{
            }];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

@end
