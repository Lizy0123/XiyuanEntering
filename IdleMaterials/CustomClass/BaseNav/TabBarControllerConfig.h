//
//  TabBarControllerConfig.h
//  Taoyi
//
//  Created by Lzy on 2018/1/29.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTabBarController.h"

@interface TabBarControllerConfig : NSObject
@property (nonatomic, readonly, strong) BaseTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;

@end

@interface PlusButtonSubclass : CYLPlusButton <CYLPlusButtonSubclassing>

@end

