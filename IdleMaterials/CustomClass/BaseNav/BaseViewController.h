//
//  BaseViewController.h
//  Taoyi
//
//  Created by Lzy on 2018/1/27.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 拿到presentViewController的那个ViewController
 */
+(UIViewController *)presentingVC;

/**
 presentVC方法，在任何界面调用present出来一个界面
 
 @param viewController 弹出的界面
 @param hasNav 弹出的界面是否有导航栏
 */
+(void)presentVC:(UIViewController *)viewController hasNav:(BOOL)hasNav;

/**
 goToVC方法，在任何界面调用push进去一个界面
 
 @param viewController 要Push进去的页面
 */
+(void)goToVC:(UIViewController *)viewController;

/**
 在任何界面调用弹出登录页面，配合使用判断是否用户登录
 */
-(void)goToLoginVC;
+(void)goToLoginVC;
+(void)configLogOutStatus;
@end

