//
//  TitleValueTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_TitleValueTCell @"TitleValueTCell"

#import <UIKit/UIKit.h>

@interface TitleValueTCell : UITableViewCell
- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value;
+ (CGFloat)cellHeight;
@end
