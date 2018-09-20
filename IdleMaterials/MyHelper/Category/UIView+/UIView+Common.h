//
//  UIView+Common.h
//  YLuxury
//
//  Created by Lzy on 2017/5/10.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>
#import "UIBadgeView.h"
//#import "UIView+Frame.h"

@class LoadingView, BlankPageView;

typedef NS_ENUM(NSInteger, kBlankPageType)
{
    kBlankPageTypeView = 0,
    kBlankPageTypeNetwork,
    kBlankPageTypeAddress,
    kBlankPageTypeShopCart,
    kBlankPageTypeCollection,
    kBlankPageTypeComment,
    kBlankPageTypeCoupon,
    kBlankPageTypeHistory,
    kBlankPageTypeMessage,
    kBlankPageTypeOrder,
    kBlankPageTypeOhter,
    kBlankPageTypeSearch,
    
};

typedef NS_ENUM(NSInteger, BadgePositionType) {
    
    BadgePositionTypeDefault = 0,
    BadgePositionTypeMiddle
};

@interface UIView (Common)


@property (nonatomic, assign) CGSize size;// Sets frame.size = size
/** UIView的最大X值 */
@property (assign, nonatomic) CGFloat maxX;
/** UIView的最大Y值 */
@property (assign, nonatomic) CGFloat maxY;
/** UIView 的坐标 */
@property (nonatomic, assign) CGPoint origin;// Sets frame.origin = origin
/** UIView 的宽度 bounds */
@property (nonatomic, assign) CGFloat boundsWidth;
/** UIView 的高度 bounds */
@property (nonatomic, assign) CGFloat boundsHeight;

- (UIViewController *)currentController;





// The following copied and pasted from Three20 http://three20.info/
@property (nonatomic) CGFloat left; // Sets frame.origin.x = left
@property (nonatomic) CGFloat top; // Sets frame.origin.y = top
@property (nonatomic) CGFloat right; // Sets frame.origin.x = right - frame.size.width
@property (nonatomic) CGFloat bottom; // Sets frame.origin.y = bottom - frame.size.height
@property (nonatomic) CGFloat width; // Sets frame.size.width = width
@property (nonatomic) CGFloat height; // Sets frame.size.height = height
@property (nonatomic) CGFloat centerX; // Sets center.x = centerX
@property (nonatomic) CGFloat centerY; // Sets center.y = centerY
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, readonly) CGFloat screenX; // Return the x coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGFloat screenY; // Return the y coordinate on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGRect screenFrame; // Return the view frame on the screen, taking into account scroll views.
@property (nonatomic, readonly) CGFloat orientationWidth; // Return the width in portrait or the height in landscape.
@property (nonatomic, readonly) CGFloat orientationHeight; // Return the height in portrait or the width in landscape.

+ (instancetype)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color; // Quickly create a view.

- (UIView *)descendantOrSelfWithClass:(Class)cls; // Finds the first descendant view (including this view) that is a member of a particular class.
- (UIView *)ancestorOrSelfWithClass:(Class)cls; // Finds the first ancestor view (including this view) that is a member of a particular class.

- (void)removeAllSubviews; // Removes all subviews.

/**
 * Calculates the origin of this view from another parent view in screen coordinates.
 *
 * parentView should be a parent view of this view.
 */
- (CGPoint)originInView:(UIView *)parentView;

// Layer properties, they can use in xib/storyboard file.
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable float shadowOpacity;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;





- (void)doCircleFrame;
- (void)doNotCircleFrame;
- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**
 * Returns a snapshot of the view.
 *
 * This method takes into account the offset of scrollable views and captures whatever is currently
 * in the frame of the view.
 *
 * @param transparent Return a snapshot of the view with transparency if transparent is YES.
 */
- (UIImage *)snapshotWithTransparent:(BOOL)transparent;
- (UIViewController *)viewController; // The view controller whose view contains this view.
- (UIViewController *)findViewController;
- (void)addBadgeTip:(NSString *)badgeValue withCenterPosition:(CGPoint)center;
- (void)addBadgeTip:(NSString *)badgeValue;
- (void)addBadgePoint:(NSInteger)pointRadius withPosition:(BadgePositionType)type;
- (void)addBadgePoint:(NSInteger)pointRadius withPointPosition:(CGPoint)point;
- (void)removeBadgePoint;
- (void)removeBadgeTips;
- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;
- (CGFloat)maxXOfFrame;

- (void)setSubScrollsToTop:(BOOL)scrollsToTop;

/**
 渐变色

 @param cgColorArray 用.CGColor
 */
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray;
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )aPoint endPoint:(CGPoint)endPoint;



- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (CGSize)doubleSizeOfFrame;


+ (CGRect)frameWithOutNav;
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;



+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace;
- (void)removeViewWithTag:(NSInteger)tag;




#pragma mark - mark Debug
+ (void)outputTreeInView:(UIView *)view withSeparatorCount:(NSInteger)count;//输出某个View的subview目录
- (void)outputSubviewTree;//输出子视图的目录树


#pragma mark LoadingView
@property (strong, nonatomic) LoadingView *loadingView;
- (void)beginLoading;
- (void)endLoading;


#pragma mark BlankPageView
@property (strong, nonatomic) BlankPageView *blankPageView;
- (void)configBlankPage:(kBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
- (void)configBlankPage:(kBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;
@end

@interface LoadingView : UIView
@property (strong, nonatomic) UIImageView *loopView, *monkeyView;
@property (assign, nonatomic, readonly) BOOL isLoading;
- (void)startAnimating;
- (void)stopAnimating;
@end

@interface BlankPageView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UIView *myBackgroundView;

@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (assign, nonatomic) kBlankPageType curType;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
@property (copy, nonatomic) void(^loadAndShowStatusBlock)(void);
@property (copy, nonatomic) void(^clickButtonBlock)(kBlankPageType curType);
- (void)configWithType:(kBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;
@end

