//
//  MyStepper.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/8.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

// action control: UIControlEventApplicationReserved for increment/decrement?
// delegate: if there are multiple PKYSteppers in one viewcontroller, it will be a hassle to identify each PKYSteppers
// block: watch out for retain cycle

// check visibility of buttons when
// 1. right before displaying for the first time
// 2. value changed

#import "MyStepper.h"

static const float kButtonWidth = 30.0f;

@implementation MyStepper

#pragma mark initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _value = 0.0f;
    _stepInterval = 1.0f;
    _minimum = 1.0f;
    _maximum = 99999.0f;
    _hidesDecrementWhenMinimum = NO;
    _hidesIncrementWhenMaximum = NO;
    _buttonWidth = kButtonWidth;
    
    self.clipsToBounds = YES;
    [self setBorderWidth:1.0f];
    [self setCornerRadius:3.0];
    
    self.countTextField = [[UITextField alloc] init];
    self.countTextField.textAlignment = NSTextAlignmentCenter;
    self.countTextField.layer.borderWidth = 1.0f;
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.countTextField.delegate = self;
    
    [self addSubview:self.countTextField];
    
    
    self.incrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.incrementButton setTitle:@"+" forState:UIControlStateNormal];
    [self.incrementButton addTarget:self action:@selector(incrementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.incrementButton];
    
    self.decrementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.decrementButton setTitle:@"-" forState:UIControlStateNormal];
    [self.decrementButton addTarget:self action:@selector(decrementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.decrementButton];
    
    UIColor *defaultColor = [UIColor colorWithRed:(79/255.0) green:(161/255.0) blue:(210/255.0) alpha:1.0];
    [self setBorderColor:defaultColor];
    [self setLabelTextColor:defaultColor];
    [self setButtonTextColor:defaultColor forState:UIControlStateNormal];
    
    [self setLabelFont:[UIFont fontWithName:@"Avernir-Roman" size:14.0f]];
    [self setButtonFont:[UIFont fontWithName:@"Avenir-Black" size:24.0f]];
}


#pragma mark render
- (void)layoutSubviews
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.countTextField.frame = CGRectMake(self.buttonWidth, 0, width - (self.buttonWidth * 2), height);
    
    self.incrementButton.frame = CGRectMake(width - self.buttonWidth, 0, self.buttonWidth, height);
    self.decrementButton.frame = CGRectMake(0, 0, self.buttonWidth, height);
    
    self.incrementButton.hidden = (self.hidesIncrementWhenMaximum && [self isMaximum]);
    self.decrementButton.hidden = (self.hidesDecrementWhenMinimum && [self isMinimum]);
}

- (void)setup
{
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, self.value);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        // if CGSizeZero, return ideal size
        
        CGSize labelSize = [self.countTextField sizeThatFits:size];
        
        return CGSizeMake(labelSize.width + (self.buttonWidth * 2), labelSize.height);
    }
    return size;
}


#pragma mark view customization
- (void)setBorderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.countTextField.layer.borderColor = color.CGColor;
    
}

- (void)setBorderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}

- (void)setLabelTextColor:(UIColor *)color
{
    self.countTextField.textColor = color;
    
}
-(void)setTextColor:(UIColor *)textColor{
    self.countTextField.textColor = textColor;
}
- (void)setLabelFont:(UIFont *)font
{
    self.countTextField.font = font;
    
}

- (void)setButtonTextColor:(UIColor *)color forState:(UIControlState)state
{
    [self.incrementButton setTitleColor:color forState:state];
    [self.decrementButton setTitleColor:color forState:state];
}

- (void)setButtonFont:(UIFont *)font
{
    self.incrementButton.titleLabel.font = font;
    self.decrementButton.titleLabel.font = font;
}


#pragma mark setter
- (void)setValue:(float)value
{
    _value = value;
    if (self.hidesDecrementWhenMinimum)
    {
        self.decrementButton.hidden = [self isMinimum];
    }
    
    if (self.hidesIncrementWhenMaximum)
    {
        self.incrementButton.hidden = [self isMaximum];
    }
    
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, _value);
    }
}



#pragma mark event handler
- (void)incrementButtonTapped:(id)sender
{
    if (self.value < self.maximum)
    {
        self.value += self.stepInterval;
        if (self.incrementCallback)
        {
            self.incrementCallback(self, self.value);
        }
    }
}

- (void)decrementButtonTapped:(id)sender
{
    if (self.value > self.minimum)
    {
        self.value -= self.stepInterval;
        if (self.decrementCallback)
        {
            self.decrementCallback(self, self.value);
        }
    }
}


#pragma mark private helpers
- (BOOL)isMinimum
{
    return self.value == self.minimum;
}

- (BOOL)isMaximum
{
    return self.value == self.maximum;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.valueChangedCallback)
    {
        self.valueChangedCallback(self, _value);
    }
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    _value = [toBeString floatValue];
    
    return YES;
}


@end
