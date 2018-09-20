//
//  NSObject+Common.m
//  YLuxury
//
//  Created by Lzy on 2017/5/15.
//  Copyright © 2017年 YLuxury. All rights reserved.
//
#define kPath_ImageCache @"ImageCache"
#define kPath_ResponseCache @"ResponseCache"
#define kHUDQueryViewTag 101


#define kKeyWindow [UIApplication sharedApplication].keyWindow

#import "NSObject+Common.h"
//#import "JDStatusBarNotification.h"
//#import "YLAppDelegate.h"
#import "MBProgressHUD+Add.h"


@implementation NSObject (Common)
#pragma mark - 判断
+(BOOL)isDictionary:(id)dic{
    if (!dic) {
        return NO;
    }
    if ((NSNull *)dic == [NSNull null]) {
        return NO;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([dic count] <= 0) {
        return NO;
    }
    return YES;
}
+ (BOOL)isArray:(id)array{
    if (!array) {
        return NO;
    }
    if ((NSNull *)array == [NSNull null]) {
        return NO;
    }
    if (![array isKindOfClass:[NSArray class]]) {
        return NO;
    }
    if ([array count] <= 0) {
        return NO;
    }
    if (array == nil) {
        NO;
    }
    return YES;
}
+(BOOL)isArrayEmpty:(NSArray *)array
{
    return (array == nil || [array count] == 0);
}
+(BOOL)isString:(id)str{
    if (!str) {
        return NO;
    }
    if ((NSNull *)str == [NSNull null]) {
        return NO;
    }
//    if (![str isKindOfClass:[NSString class]]) {
//        return NO;
//    }
    if ([str isEqualToString:@""]) {
        return NO;
    }
    if (((NSString *)str).length == 0) {
        return NO;
    }
    if ([str isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([str isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
+ (BOOL)isNumber:(NSString *)str {
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0) {
        return NO;
    }
    return YES;
}

+(BOOL)isInt:(id)str{
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+(BOOL)isFloat:(id)str{
    NSScanner* scan = [NSScanner scannerWithString:str];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,186,183
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

    NSString * CS = @"^1((77|78|79|8[09])[0-9]|349)\\d{7}$";

    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestcs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CS];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestcs evaluateWithObject:mobileNum] == YES))
    {
        if([regextestcm evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }

        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isValidateIdentityCard: (NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression{
    NSPredicate  *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
}


+ (BOOL)isValidateTelNumber:(NSString *)number{
    NSString *strRegex = @"[0-9]{1,20}";
    BOOL rt = [[self class] isValidateRegularExpression:number byExpression:strRegex];
    return rt;
}

+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    BOOL rt = [[self class] isValidateRegularExpression:email byExpression:strRegex];
    return rt;
}

+(NSString *)moneyStyle:(NSString *)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:money];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle =NSNumberFormatterCurrencyStyle;
    formatter.locale= [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [formatter stringFromNumber:numTemp];
}
+(void)ToastActivityShow{
    [kKeyWindow makeToastActivity:CSToastPositionCenter];
}
+(void)ToastActivityHide{
    [kKeyWindow hideToastActivity];
}
+(void)ToastShowStr:(NSString *)str{
    if (str.length>40) {
        [NSObject ToastShowStr:str during:2.0f];
    }else{
        [NSObject ToastShowCustomeStr:str during:2.0f];
    }
}
+(void)ToastShowStr:(NSString *)str during:(CGFloat)during{
    [kKeyWindow makeToast:str
                 duration:during
                 position:CSToastPositionCenter
                    title:nil
                    image:nil
                    style:nil
               completion:nil];
}
+(void)ToastShowCustomeStr:(NSString *)str during:(CGFloat)during{
    // Show a custom view as toast
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 120)];
    customView.cornerRadius = 10;
    customView.layer.masksToBounds = YES;
    customView.opaque = YES;
    customView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
    
    [customView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)]; // autoresizing masks are respected on custom views
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(customView.frame) + 20, CGRectGetMinY(customView.frame) + 20, CGRectGetWidth(customView.frame) - 20*2, CGRectGetHeight(customView.frame) - 20*2)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    label.text = str;
    [customView addSubview:label];
    
    [kKeyWindow showToast:customView
                 duration:during
                 position:CSToastPositionCenter
               completion:nil];
}
+(void)ToastHide{
    [kKeyWindow hideToast];
}
+(void)ToastHideAll{
    [kKeyWindow hideAllToasts];
}

#pragma mark Tip M

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}
+ (instancetype)showHUDQueryStr:(NSString *)titleStr{
    titleStr = titleStr.length > 0? titleStr: @"正在加载...";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.tag = kHUDQueryViewTag;
    hud.labelText = titleStr;
    hud.labelFont = [UIFont boldSystemFontOfSize:15.0];
    hud.margin = 10.f;
    return hud;
}
+ (NSUInteger)hideHUDQuery{
    __block NSUInteger count = 0;
    NSArray *huds = [MBProgressHUD allHUDsForView:kKeyWindow];
    [huds enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == kHUDQueryViewTag) {
            [obj removeFromSuperview];
            count++;
        }
    }];
    return count;
}
+ (void)showStatusBarQueryStr:(NSString *)tipStr{
//    [JDStatusBarNotification showWithStatus:tipStr styleName:JDStatusBarStyleSuccess];
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
}
+ (void)showStr:(NSString *)tipStr{
    
//    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:tipStr iconImage:nil];
//    toast.toastType = FFToastTypeDefault;
//    toast.toastPosition = FFToastPositionBottomWithFillet;
//    [toast show];
    
    // Make toast with an image, title, and completion block
    [[UIApplication sharedApplication].keyWindow makeToast:tipStr
                                     duration:2.0
                                     position:CSToastPositionCenter
                                        title:nil
                                        image:nil
                                        style:nil
                                   completion:^(BOOL didTap) {
                                       if (didTap) {
                                           NSLog(@"completion from tap");
                                       } else {
                                           NSLog(@"completion without tap");
                                       }
                                   }];
    
    
    ;
    
    
//    if ([JDStatusBarNotification isVisible]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
//            [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
//        });
//    }else{
//        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];
//    }
}
+ (void)showStatusBarErrorStr:(NSString *)errorStr{
//    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:errorStr iconImage:nil];
//    toast.toastType = FFToastTypeDefault;
//    toast.toastPosition = FFToastPositionBottomWithFillet;
//    [toast show];
    
    // Make toast with an image, title, and completion block
    [[UIApplication sharedApplication].keyWindow makeToast:errorStr
                                                  duration:2.0
                                                  position:CSToastPositionCenter
                                                     title:nil
                                                     image:nil
                                                     style:nil
                                                completion:^(BOOL didTap) {
                                                    if (didTap) {
                                                        NSLog(@"completion from tap");
                                                    } else {
                                                        NSLog(@"completion without tap");
                                                    }
                                                }];
    
    
//    if ([JDStatusBarNotification isVisible]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
//            [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
//            
//        });
//    }else{
//        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
//    }
}

//+ (void)showStatusBarError:(NSError *)error{
//    NSString *errorStr = [NSObject tipFromError:error];
//    [NSObject showStatusBarErrorStr:errorStr];
//}



#pragma mark File M
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}
//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}



// 图片缓存到本地
+ (BOOL) saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName
{
    if (!image) {
        return NO;
    }
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    if ([self createDirInCache:folderName]) {
        NSString * directoryPath = [self pathInCacheDirectory:folderName];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
        bool isSaved = false;
        if ( isDir == YES && existed == YES )
        {
            isSaved = [[image dataForCodingUpload] writeToFile:[directoryPath stringByAppendingPathComponent:imageName] options:NSAtomicWrite error:nil];
        }
        return isSaved;
    }else{
        return NO;
    }
}
// 获取缓存图片
+ (NSData*) loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName
{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    NSString * directoryPath = [self pathInCacheDirectory:folderName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@", directoryPath, imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:abslutePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : abslutePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}

// 删除图片缓存
+ (BOOL) deleteImageCacheInFolder:(NSString *)folderName{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    return [self deleteCacheWithPath:folderName];
}



+ (BOOL) deleteResponseCache{
    return [self deleteCacheWithPath:kPath_ResponseCache];
}

+ (NSUInteger)getResponseCacheSize {
    NSString *dirPath = [self pathInCacheDirectory:kPath_ResponseCache];
    NSUInteger size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:dirPath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}


+ (BOOL) deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

#pragma mark NetError
//-(id)handleResponse:(id)responseJSON{
//    return [self handleResponse:responseJSON autoShowError:YES];
//}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

@end
