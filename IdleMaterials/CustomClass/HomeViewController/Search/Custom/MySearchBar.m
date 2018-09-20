//
//  MySearchBar.m
//  XYGPWuZi
//
//  Created by Lzy on 2017/12/27.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import "MySearchBar.h"
@implementation MySearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self becomeFirstResponder];
        self.returnKeyType =UIKeyboardTypeASCIICapable;
        self.font = [UIFont systemFontOfSize:13];
        UIImage *image = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.background =  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        
        // 设置左边的view
        // initWithImage:默认UIImageView的尺寸跟图片一样
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        imageV.width += 10;
        imageV.contentMode = UIViewContentModeCenter;
        self.leftView = imageV;
        // 一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
        self.leftViewMode = UITextFieldViewModeAlways;

    }
    return self;
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}


@end
