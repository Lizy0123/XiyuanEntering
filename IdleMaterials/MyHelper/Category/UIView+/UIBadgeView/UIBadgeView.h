//
//  UIBadgeView.h
//  YLuxury
//
//  Created by Lzy on 2017/5/10.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBadgeView : UIView

@property (nonatomic, copy) NSString *badgeValue;

+ (UIBadgeView *)viewWithBadgeTip:(NSString *)badgeValue;
+ (CGSize)badgeSizeWithStr:(NSString *)badgeValue font:(UIFont *)font;

- (CGSize)badgeSizeWithStr:(NSString *)badgeValue;
@end
