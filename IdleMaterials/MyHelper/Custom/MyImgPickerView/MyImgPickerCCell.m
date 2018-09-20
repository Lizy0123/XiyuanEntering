//
//  MyImgPickerCell.m
//  MyImgPickerView
//
//  Created by Lzy on 2018/1/15.
//  Copyright © 2018年 Lzy. All rights reserved.
//
/** cell上删除按钮的宽 */
#define PickerDelBtnWidth ([UIScreen mainScreen].bounds.size.width/375.0) * 20

#import "MyImgPickerCCell.h"

@implementation MyImgPickerCCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _icon = [[UIImageView alloc] init];
    _icon.clipsToBounds = YES;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_icon];
    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_del_img" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShowVideo" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    [self.contentView addSubview:_videoImageView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _icon.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    _deleteButton.frame = CGRectMake(self.bounds.size.width - PickerDelBtnWidth, 0, PickerDelBtnWidth, PickerDelBtnWidth);
    _videoImageView.frame = CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2);
}
- (void)clickDeleteButton {

    !_LLClickDeleteButton ?  : _LLClickDeleteButton(self.cellIndexPath);
}

@end
