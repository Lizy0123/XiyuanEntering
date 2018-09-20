//
//  TitleScrollTextTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_TitleScrollTextTCell @"TitleScrollTextTCell"

#import <UIKit/UIKit.h>

@interface TitleScrollTextTCell : UITableViewCell
- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value;
+ (CGFloat)cellHeight;
@end
