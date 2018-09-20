//
//  NSObject+Property.h
//  LzyHelper
//
//  Created by Lzy on 2017/11/13.
//  Copyright © 2017年 Lzy. All rights reserved.
//


#import <Foundation/Foundation.h>
@interface NSObject (Property)
/*!
 @brief 根据当前类获取当前类的所有属性名称
 @param cls 当前类 Class类型
 @return 当前类的所有属性名称
 */
- (NSArray *)getProperties:(Class)cls;

/*!
 @brief 循环属性所对应的名称
 @param properties 循环后执行的block key为当前属性的名称
 */
- (void) enumerateProperties:(void(^)(id key))properties;
@end
