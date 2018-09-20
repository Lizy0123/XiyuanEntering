//
//  TitleScrollTextTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "TitleScrollTextTCell.h"

@interface TitleScrollTextTCell ()
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation TitleScrollTextTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 12, 80, 20)];
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_valueLabel) {
            _scrollView = [UIScrollView new];
            _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
            _valueLabel = [UILabel new];
            _valueLabel.textAlignment = NSTextAlignmentLeft;
            _valueLabel.font = [UIFont systemFontOfSize:kValueFontSize];
            _valueLabel.textColor = kColorValueStr;
            [_scrollView addSubview:_valueLabel];
            [self.contentView addSubview:_scrollView];
            [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel.mas_right);
                make.top.bottom.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-kMyPadding);
            }];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(_scrollView);
                make.height.equalTo(_titleLabel);
            }];
        }
        
    }return self;
}

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value;{
    _titleLabel.text = title;
    _valueLabel.text = value;
    [self.contentView updateConstraintsIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(_valueLabel.frame), CGRectGetHeight(_scrollView.frame));
    });
}

+ (CGFloat)cellHeight{
    return 44;
}

@end
