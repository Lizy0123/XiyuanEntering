//
//  TitleTextTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_TitleTextTCell @"TitleTextTCell"

#import <UIKit/UIKit.h>

@interface TitleTextTCell : UITableViewCell
- (void)setTitleStr:(NSString *)titleStr valueStr:(NSString *)contentStr;
+(CGFloat)cellHeightWithObj:(id)obj;
@end
