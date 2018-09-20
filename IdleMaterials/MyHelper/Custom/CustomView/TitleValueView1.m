//
//  TitleValueView1.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/23.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "TitleValueView1.h"

@implementation TitleValueView1

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, kMyPadding/2, frame.size.width - kMyPadding*2, frame.size.height- kMyPadding)];
        
        [self addSubview:_label];
    }return self;
}


-(void)setTitleStr:(NSString *)titleStr valueStr:(NSString*)valueStr valueColor:(UIColor *)color{
    NSString *allStr = [NSString stringWithFormat:@"%@: %@",titleStr,valueStr];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    
//    NSRange rangeAll = NSMakeRange(0, allStr.length);
    NSRange rangeTitle = NSMakeRange(0, titleStr.length);
    NSRange rangeValue = NSMakeRange(attrStr.length - valueStr.length, valueStr.length);
    NSRange rangeMiddle = NSMakeRange(titleStr.length, attrStr.length - titleStr.length - valueStr.length);
    
    // 设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kTitleFontSize] range:rangeTitle];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kValueFontSize] range:rangeValue];
    
    //字间距
    [attrStr addAttribute:NSKernAttributeName value:@(5) range:rangeMiddle];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:kColorTitleStr range:rangeTitle];
    [attrStr addAttribute:NSForegroundColorAttributeName value:kColorValueStr range:rangeValue];
    if (!(color == nil)) {
        // 字体加粗
        [attrStr addAttribute:NSExpansionAttributeName value:@(0.3) range:rangeValue];
        // 设置颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:rangeValue];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kTitleFontSizeLarge] range:rangeValue];

    }

    [_label setAttributedText:attrStr];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
