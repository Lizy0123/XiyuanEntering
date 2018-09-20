//
//  MyTextView.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView
@property(weak, nonatomic)NSString *placeholder;//第一种placeholder方法
@property(copy, nonatomic)NSString *placeHolder;//第二种placeholder方法
@property(assign, nonatomic)BOOL hidePlaceHolder;
@end
