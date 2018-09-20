//
//  TitleTextTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kTitleWidth 80
#define kContentFont [UIFont systemFontOfSize:kValueFontSize]

#import "TitleTextTCell.h"

@interface TitleTextTCell ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@end

@implementation TitleTextTCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, kMyPadding/2, kTitleWidth, 30)];
            [self.contentView addSubview:_titleLabel];
        }
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        [_titleLabel sizeToFit];
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), kMyPadding/2, kScreen_Width - CGRectGetMaxX(self.titleLabel.frame) - kMyPadding, 44)];
            _contentLabel.textColor = [UIColor grayColor];
            _contentLabel.font = kContentFont;
            _contentLabel.textAlignment = NSTextAlignmentLeft;
            _contentLabel.numberOfLines = 0;
            [self.contentView addSubview:_contentLabel];
        }
    }return self;
}
- (void)setTitleStr:(NSString *)titleStr valueStr:(NSString *)contentStr{
    self.titleLabel.text = titleStr;
    
    self.contentLabel.text = contentStr;
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), kMyPadding/2, kScreen_Width - CGRectGetMaxX(self.titleLabel.frame) - kMyPadding,  [TitleTextTCell cellHeightWithObj:contentStr]);
    [self.contentLabel sizeToFit];
}
+(CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    cellHeight += 8 * 2;
    cellHeight += [obj getHeightWithFont:kContentFont constrainedToSize:CGSizeMake(kScreen_Width - kTitleWidth -kMyPadding * 2, 100000.0)];
    return cellHeight;
}
@end
