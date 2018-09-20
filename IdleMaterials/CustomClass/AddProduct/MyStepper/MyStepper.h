//
//  MyStepper.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/8.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyStepper;
// called when value is changed
typedef void (^PKYStepperValueChangedCallback)(MyStepper *stepper, float newValue);

// called when value is incremented
typedef void (^PKYStepperIncrementedCallback)(MyStepper *stepper, float newValue);


// called when value is decremented
typedef void (^PKYStepperDecrementedCallback)(MyStepper *stepper, float newValue);

IB_DESIGNABLE
@interface MyStepper : UIControl<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *countTextField;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIButton *incrementButton;
@property(nonatomic, strong) UIButton *decrementButton;

@property(nonatomic) float value; // default: 0.0
@property(nonatomic) float stepInterval; // default: 1.0
@property(nonatomic) float minimum; // default: 0.0
@property(nonatomic) float maximum; // default: 100.0
@property(nonatomic) BOOL hidesDecrementWhenMinimum; // default: NO
@property(nonatomic) BOOL hidesIncrementWhenMaximum; // default: NO
@property(nonatomic) CGFloat buttonWidth; // default: 44.0f

@property(nonatomic, copy) PKYStepperValueChangedCallback valueChangedCallback;
@property(nonatomic, copy) PKYStepperIncrementedCallback incrementCallback;
@property(nonatomic, copy) PKYStepperDecrementedCallback decrementCallback;

// call this method after setting value(s) and callback(s)
// This method will call callback
- (void)setup;

// view customization
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;

- (void)setLabelTextColor:(UIColor *)color;
- (void)setLabelFont:(UIFont *)font;

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state;
- (void)setButtonFont:(UIFont *)font;

@end
