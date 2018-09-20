//
//  TitleTextViewTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_TitleTextViewTCell @"TitleTextViewTCell"

#import <UIKit/UIKit.h>
#import "MyTextView.h"
@class TitleTextViewTCell;
@protocol TitleTextViewTCellDelegate<NSObject>
@optional
- (void)MyTitleTextViewDidChange:(NSString *)str tableViewCell:(TitleTextViewTCell *)cell;
@end

@interface TitleTextViewTCell : UITableViewCell
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)MyTextView *contentTextView;
@property(weak, nonatomic)id<TitleTextViewTCellDelegate>delegate;

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value placeHolder:(NSString *)placeHolder;

+(CGSize)sizeForContentStr:(NSString *)contentStr width:(CGFloat)maxWidth;

+(CGFloat)cellHeightWithObj:(id)obj;

@end
