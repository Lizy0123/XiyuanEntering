//
//  Header.h
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#ifndef Header_h
#define Header_h
#pragma mark - Struct
#import <Foundation/Foundation.h>
typedef struct _MyPage{
    NSUInteger pageSize;
    NSUInteger pageIndex;
}MyPage;

typedef NS_ENUM(NSInteger, kRegistViewType) {
    kRegistViewType_Regist = 0, //注册
    kRegistViewType_ForgetPassword = 1, //忘记密码
    kRegistViewType_BindUser = 2, //绑定账户
    kRegistViewType_BindUserAndPassword = 3  //绑定并注册手机号
};
typedef NS_ENUM(NSUInteger, kProductCViewType) {
    kProductCViewType_Product = 1,//商品
    kProductCViewType_Shop = 2,//店铺
};


























#import "BaseViewController.h"
#import "BaseNavigationController.h"
//#import "UIMyTableView.h"

//#import "ProductModel.h"
#import "UserModel.h"
#import "LoginViewController.h"
#define kColorMain kColorHex(0x1E9FFF)
#import "MyDIYEmpty.h"









#pragma mark Category
#import "NSObject+Common.h"
#import "NSString+Common.h"
#import "NSString+QT.h"
#import "UIView+Common.h"
#import "UIView+Toast.h"
#import "UIImage+Common.h"
#import "UILabel+Common.h"
#import "UIColor+expanded.h"
#import "UIButton+Common.h"
#import "UISearchBar+Common.h"

#import "Masonry.h"
#import "MJRefresh.h"
#import "AFNetWorking.h"
#import "UIImageView+WebCache.h"



#pragma mark - Lzy
#pragma mark - 常用宏定义
#define kToken @"token"
#define kStringToken [[NSUserDefaults standardUserDefaults] objectForKey:kToken]

#define kSessionId @"JSESSIONID"//标记：sessionId
#define kStringSessionId [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId]?[[NSUserDefaults standardUserDefaults] objectForKey:kSessionId]:@""

#define kTradeSiteCache @"kTradeSiteCache"
#define  kBadgeTipStr @"badgeTip"

#define StrHome @"首页"
#define StrSecond @"拍卖"
#define StrMiddle @"易物"
#define StrThird @"店铺"
#define StrMine @"我的"


#pragma mark - Define
#define kMyPadding 16.0f
#define kTagHome 1000
#define kTagSecond 2000
#define kTagMiddle 3000
#define kTagThird 4000
#define kTagMine 5000

static const CGFloat kTitleFontSizeLarger = 20.f;
static const CGFloat kTitleFontSizeLarge = 17.f;
static const CGFloat kTitleFontSizeMiddle = 15.f;
static const CGFloat kTitleFontSizeSmall = 13.f;


static const CGFloat kTitleFontSize = 14.f;
static const CGFloat kSubTitleFontSize = 13.f;
static const CGFloat kValueFontSize = 13.f;
static const CGFloat kContentFontSize = 13.f;

//#define kColorMain [UIColor colorWithRed:125/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define kColorPlaceholder [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1]
#define kColorGary [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1]

#define kColorBorder [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kColorTitleStr kColorHex(0x1D1D1D)
#define kColorValueStr kColorHex(0x999999)
#define kColorDescStr kColorHex(0x353535)
#define kColorSeparate kColorHex(0xF5F5F5)


#define kColorMainTitle kColorHex(0x323A45)
#define kColorTableBG kColorHex(0xFFFFFF)
#define kColorTableSectionBg kColorHex(0xF2F4F6)
#define kColor222 kColorHex(0x222222)
#define kColor666 kColorHex(0x666666)
#define kColor999 kColorHex(0x999999)
#define kColorDDD kColorHex(0xDDDDDD)
#define kColorCCC kColorHex(0xCCCCCC)
#define kColorBrandGreen kColorHex(0x3BBD79)
#define kColorBrandRed kColorHex(0xFF5846)







#pragma mark - Debug
#ifdef DEBUG
//Log
#define NSLog(FORMAT, ...) fprintf(stderr,"%s(%zd)%s\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//Alert
#define MyAlert(TITLE,MSG) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil] show]

#else
#define NSLog(FORMAT, ...) nil
#define MyAlert(TITLE,MSG) nil

#endif



//机型判断
#pragma mark - Device
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))
#define kDevice_iPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_iPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_iPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_iPhoneX     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//OS系统
#pragma mark - Edition
#define kIOSVersion             ((float)[[[UIDevice currentDevice] systemVersion] doubleValue])
//Edition
#define kEdition_iOS7           (([UIDevice currentDevice].systemVersion.floatValue >= 7.0f && [UIDevice currentDevice].systemVersion.floatValue < 8.0) ? YES : NO)
#define kEdition_iOS7OrLater    (([UIDevice currentDevice].systemVersion.floatValue >= 7.0f) ? YES : NO)
#define kEdition_iOS8           (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f && [UIDevice currentDevice].systemVersion.floatValue < 9.0f) ? YES : NO)
#define kEdition_iOS8OrLater    (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) ? YES : NO)
#define kEdition_iOS9           (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f && [UIDevice currentDevice].systemVersion.floatValue < 10.0f) ? YES : NO)
#define kEdition_iOS9OrLater    (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) ? YES : NO)
#define kEdition_iOS10          (([UIDevice currentDevice].systemVersion.floatValue >= 10.0f && [UIDevice currentDevice].systemVersion.floatValue < 11.0f) ? YES : NO)
#define kEdition_iOS10OrLater   (([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) ? YES : NO)
#define kEdition_iOS11          (([[UIDevice currentDevice].systemVersion floatValue] >= 11) ? YES : NO)
#define kEdition_iOS_EqualTo(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kEdition_iOS_GreaterThan(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kEdition_iOS_GreaterThanOrEqualTo(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kEdition_iOS_LessThan(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kEdition_iOS_LessThanOrEqualTo(v)       ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//颜色
#pragma mark - Color
#define kColorRGB(r,g,b) [UIColor colorWithRed:(CGFloat)(r)/255.0 green:(CGFloat)(g)/255.0 blue:(CGFloat)(b)/255.0 alpha:1]
#define kColorHex(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define kRandomColor [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1.0]
#define kRandomColorAnother kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))



//Frame
#pragma mark - Frame
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kViewSafeAreaInsets(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height

#define kSafeAreaTopHeight (kScreen_Height == 812.0 ? 88 : 64)
#define kSafeAreaBottomHeight (kScreen_Height == 812.0 ? 34 : 0)
#define kViewAtBottomHeight (49 + kSafeAreaBottomHeight)

#define kViewHeightAtTop (49 + kSafeAreaTopHeight)
#define kViewHeightAtBottom (49 + kSafeAreaBottomHeight)

#define kSafeBottomOffset (CYL_IS_IPHONE_X ? 34 : 0)


/**
 导航栏titleView尽可能充满屏幕，余留的边距
 iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 8
 iPhone6p(iOS8/iOS9/iOS10) margin = 12
 
 iPhone5s/iPhone6(iOS11) margin = 16
 iPhone6p(iOS11) margin = 20
 */
#define NavigationBarTitleViewMargin \
(kEdition_iOS11? ([UIScreen mainScreen].bounds.size.width > 375 ? 20 : 16) : \
([UIScreen mainScreen].bounds.size.width > 375 ? 12 : 8))

/**
 导航栏左右navigationBarItem余留的边距
 iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 16
 iPhone6p(iOS8/iOS9/iOS10) margin = 20
 */
#define NavigationBarItemMargin ([UIScreen mainScreen].bounds.size.width > 375 ? 20 : 16)

/**
 导航栏titleView和navigationBarItem之间的间距
 iPhone5s/iPhone6/iPhone6p(iOS8/iOS9/iOS10) iterItemSpace = 6
 */
#define NavigationBarInterItemSpace 6

#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


//WeakObject
#pragma mark - WeakObject
#define kWeakObject(obj)                       __weak __typeof(obj) weakObject = obj;
#define kWeak(var, weakVar)                    __weak __typeof(&*var) weakVar = var
#define kStrong_DoNotCheckNil(weakVar, _var)   __typeof(&*weakVar) _var = weakVar
#define kStrong(weakVar, _var)                 kStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;
#define kWeak_(var)                            kWeak(var, weak_##var);
#define kStrong_(var)                          kStrong(weak_##var, _##var);
/** defines a weak `self` named `__weakSelf` */
#define kWeakSelf                              kWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define kStrongSelf                            kStrong(__weakSelf, _self);


#endif /* Header_h */
