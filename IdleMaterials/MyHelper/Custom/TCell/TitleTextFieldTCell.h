//
//  TitleTextFieldTCell.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kCellIdentifier_TitleTextFieldTCell @"TitleTextFieldTCell"

#import <UIKit/UIKit.h>
#import "MyTextField.h"

typedef void(^CellTapAcitonBlock)(void);
typedef void(^CellEndEditBlock)(NSString *text);

@interface TitleTextFieldTCell : UITableViewCell
@property(strong, nonatomic)MyTextField *myTtextField;
/** textField 的点击回调 */
@property (nonatomic, copy) CellTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) CellEndEditBlock endEditBlock;

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value placeHolder:(NSString *)placeHolder;
+ (CGFloat)cellHeight;

@end
