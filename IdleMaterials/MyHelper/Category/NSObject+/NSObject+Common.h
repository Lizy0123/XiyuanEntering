//
//  NSObject+Common.h
//  YLuxury
//
//  Created by Lzy on 2017/5/15.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kKeyWindow [UIApplication sharedApplication].keyWindow

@interface NSObject (Common)
+(BOOL)isDictionary:(id)dic;
+(BOOL)isArray:(id)array;
+(BOOL)isArrayEmpty:(NSArray *)array;
+(BOOL)isString:(id)str;
+(BOOL)isNumber:(NSString *)str;
+(BOOL)isInt:(id)str;
+(BOOL)isFloat:(id)str;

+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidateTelNumber:(NSString *)number;
+(BOOL)isValidateIdentityCard: (NSString *)identityCard;

#pragma mark HUD

+(NSString *)moneyStyle:(NSString *)money;







#pragma mark Tip M

+ (void)showHudTipStr:(NSString *)tipStr;
+ (instancetype)showHUDQueryStr:(NSString *)titleStr;
+ (NSUInteger)hideHUDQuery;
+ (void)showStatusBarQueryStr:(NSString *)tipStr;
+ (void)showStr:(NSString *)tipStr;
+ (void)showStatusBarErrorStr:(NSString *)errorStr;

//Toast
+(void)ToastActivityShow;
+(void)ToastActivityHide;
+(void)ToastShowStr:(NSString *)str;
+(void)ToastShowStr:(NSString *)str during:(CGFloat)during;
+(void)ToastShowCustomeStr:(NSString *)str during:(CGFloat)during;
+(void)ToastHide;
+(void)ToastHideAll;



#pragma mark File M
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName;
//创建缓存文件夹
+ (BOOL)createDirInCache:(NSString *)dirName;

//图片
+ (BOOL)saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName;
+ (NSData*)loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName;
+ (BOOL)deleteImageCacheInFolder:(NSString *)folderName;
+ (BOOL)deleteResponseCache;
+ (NSUInteger)getResponseCacheSize;

/** 获取当前的时间 */
+(NSString *)currentDateString;
@end
