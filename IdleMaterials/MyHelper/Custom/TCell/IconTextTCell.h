//
//  IconTextTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_IconTextTCell @"IconTextTCell"

#import <UIKit/UIKit.h>

@interface IconTextTCell : UITableViewCell
- (void)setTitleStr:(NSString *)title icon:(NSString *)iconName;
+ (CGFloat)cellHeight;

- (void)addTipIcon;
- (void)removeTip;
@end
