//
//  MyCountDownButton.h
//  YLuxury
//
//  Created by Lzy on 2017/7/15.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCountDownButton;
typedef NSString* (^CountDownChanging)(MyCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(MyCountDownButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(MyCountDownButton *countDownButton,NSInteger tag);

@interface MyCountDownButton : UIButton
@property(nonatomic,strong) id userInfo;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;
@end
