//
//  TitleTextViewTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kTitleWidth 80
#define kContentFont [UIFont systemFontOfSize:kValueFontSize]

#import "TitleTextViewTCell.h"

@implementation TitleTextViewTCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 14, kTitleWidth, 30)];
            [self.contentView addSubview:_titleLabel];
        }
        _titleLabel.text = @"标题";
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
//        [_titleLabel sizeToFit];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        // 添加监听器，监听自己的文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];

    }return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // 添加监听器，监听自己的文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)textDidChange {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(MyTitleTextViewDidChange:tableViewCell:)]) {
        [self.delegate MyTitleTextViewDidChange:self.contentTextView.text tableViewCell:self];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value placeHolder:(NSString *)placeHolder{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    if (!_contentTextView) {
        _contentTextView = [[MyTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), kMyPadding/2, kScreen_Width - CGRectGetMaxX(self.titleLabel.frame) - kMyPadding, 30)];
        _contentTextView.textColor = [UIColor grayColor];
        _contentTextView.font = kContentFont;
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_contentTextView];
    }
    self.contentTextView.text = value;
    self.contentTextView.placeholder = placeHolder;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentTextView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), kMyPadding/2, kScreen_Width - CGRectGetMaxX(self.titleLabel.frame) - kMyPadding, [TitleTextViewTCell cellHeightWithObj:self.contentTextView.text] - kMyPadding);
}
+(CGSize)sizeForContentStr:(NSString *)contentStr width:(CGFloat)maxWidth{
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:kContentFont,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(maxWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size;
    return size;
}
+(CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    cellHeight += 8 * 2;
    cellHeight += [obj getHeightWithFont:kContentFont constrainedToSize:CGSizeMake(kScreen_Width - kTitleWidth -kMyPadding * 2, 100000.0)];
    if (cellHeight<44) {
        cellHeight = 44;
    }
    return cellHeight;
}
@end
