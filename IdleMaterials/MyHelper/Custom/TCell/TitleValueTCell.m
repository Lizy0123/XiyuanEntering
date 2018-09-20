//
//  TitleValueTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kTitleStrWidth 100
#import "TitleValueTCell.h"

@interface TitleValueTCell ()
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@property (strong, nonatomic) NSString *title, *value;
@end

@implementation TitleValueTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 7, kTitleStrWidth, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_valueLabel) {
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleStrWidth + kMyPadding, 7, kScreen_Width-kTitleStrWidth - kMyPadding *2, 30)];
            _valueLabel.backgroundColor = [UIColor clearColor];
            _valueLabel.font = [UIFont systemFontOfSize:kValueFontSize];
            _valueLabel.textColor = kColorValueStr;
            _valueLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_valueLabel];
        }
    }return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLabel.text = _title;
    _valueLabel.text = _value;
}

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value{
    self.title = title;
    self.value = value;
}
+ (CGFloat)cellHeight{
    return 44.0;
}
@end
