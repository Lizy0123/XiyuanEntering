//
//  IconTextTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "IconTextTCell.h"

@interface IconTextTCell ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation IconTextTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_iconView) {
            _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kMyPadding, 10, 24, 24)];
            [self.contentView addSubview:_iconView];
        }
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + kMyPadding, 12, kScreen_Width/2, 20)];
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
    }return self;
}

- (void)setTitleStr:(NSString *)title icon:(NSString *)iconName{
    _titleLabel.text = title;
    _iconView.image = [UIImage imageNamed:iconName];
}

+ (CGFloat)cellHeight{
    return 44;
}
#pragma mark Tip
- (void)prepareForReuse{
    [super prepareForReuse];
    [self removeTip];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)addTipIcon{
    CGFloat pointX = kScreen_Width - 40;
    CGFloat pointY = [[self class] cellHeight]/2;
    [self.contentView addBadgeTip:kBadgeTipStr withCenterPosition:CGPointMake(pointX, pointY)];
}

- (void)removeTip{
    [self.contentView removeBadgeTips];
}

@end
