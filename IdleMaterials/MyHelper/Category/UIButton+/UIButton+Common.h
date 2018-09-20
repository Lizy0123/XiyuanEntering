//
//  UIButton+Common.h
//  YLuxury
//
//  Created by Lzy on 2017/5/11.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LzyButtonEdgeInsetsStyle) {
    LzyButtonEdgeInsetsStyleTop, // image在上，label在下
    LzyButtonEdgeInsetsStyleLeft, // image在左，label在右
    LzyButtonEdgeInsetsStyleBottom, // image在下，label在上
    LzyButtonEdgeInsetsStyleRight // image在右，label在左
};
typedef enum {
    StrapBootstrapStyle = 0,
    StrapDefaultStyle,
    StrapPrimaryStyle,
    StrapSuccessStyle,
    StrapInfoStyle,
    StrapWarningStyle,
    StrapDangerStyle
} StrapButtonStyle;
@interface UIButton (Common)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(LzyButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;



-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
- (UIImage *) buttonImageFromColor:(UIColor *)color ;
+ (UIButton *)buttonWithStyle:(StrapButtonStyle)style andTitle:(NSString *)title andFrame:(CGRect)rect target:(id)target action:(SEL)selector;


//开始请求时，UIActivityIndicatorView 提示
- (void)startQueryAnimate;
- (void)stopQueryAnimate;



@end
