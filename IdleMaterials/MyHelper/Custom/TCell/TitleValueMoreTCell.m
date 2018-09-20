//
//  TitleValueMoreTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kTitleStrWidth 100

#import "TitleValueMoreTCell.h"

@interface TitleValueMoreTCell ()
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@end

@implementation TitleValueMoreTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 7, kTitleStrWidth, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_valueLabel) {
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleStrWidth + kMyPadding, 7, kScreen_Width - kTitleStrWidth - kMyPadding*3, 30)];
            _valueLabel.backgroundColor = [UIColor clearColor];
            _valueLabel.font = [UIFont systemFontOfSize:kValueFontSize];
            _valueLabel.textColor = kColorValueStr;
            _valueLabel.textAlignment = NSTextAlignmentRight;
            _valueLabel.adjustsFontSizeToFitWidth = YES;
            _valueLabel.minimumScaleFactor = 0.6;
            [self.contentView addSubview:_valueLabel];
        }
    }return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value{
    _titleLabel.text = title;
    _valueLabel.text = value;
}

+ (CGFloat)cellHeight{
    return 44.0;
}

@end
