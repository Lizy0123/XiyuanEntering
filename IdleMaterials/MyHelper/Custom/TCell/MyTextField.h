//
//  MyTextField.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyTapAcitonBlock)(void);
typedef void(^MyEndEditBlock)(NSString *text);

@interface MyTextField : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) MyTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) MyEndEditBlock endEditBlock;

@end
