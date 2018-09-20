//
//  MyTextView.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "MyTextView.h"

@interface MyTextView ()
@property(weak, nonatomic) UILabel *placeholderLabel;
@end
@implementation MyTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    // 添加监听器，监听自己的文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 添加监听器，监听自己的文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }return self;
}

// 时刻监听文字键盘文字的变化，文字一旦改变便调用setNeedsDisplay方法
- (void)textDidChange{
    // 该方法会调用drawRect:方法，立即重新绘制占位文字
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    // 在textView的矩形框中绘制文字
    [self.placeholder drawInRect:CGRectMake(5, 5, self.frame.size.width, self.frame.size.height) withAttributes:attrs];
}


// 占位文字的setter方法
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    // 文字改变，马上重写绘制（内部会调drawRect:方法）
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
    [self setNeedsDisplay];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}



- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.placeholderLabel.text = placeHolder;
    // label的尺寸跟文字一样
    [self.placeholderLabel sizeToFit];
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder{
    _hidePlaceHolder = hidePlaceHolder;
    self.placeholderLabel.hidden = hidePlaceHolder;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    self.placeholderLabel.x = 5;
//    self.placeholderLabel.y = 8;
//
//}
@end
