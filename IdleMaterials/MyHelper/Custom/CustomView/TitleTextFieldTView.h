//
//  TitleTextFieldTView.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/22.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"

typedef void(^CellTapAcitonBlock)(void);
typedef void(^CellEndEditBlock)(NSString *text);


@interface TitleTextFieldTView : UIView

@property(strong, nonatomic)MyTextField *myTtextField;
/** textField 的点击回调 */
@property (nonatomic, copy) CellTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) CellEndEditBlock endEditBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *placeholder;


- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value placeHolder:(NSString *)placeHolder;
+ (CGFloat)cellHeight;
+(void)refreshView;
@end
