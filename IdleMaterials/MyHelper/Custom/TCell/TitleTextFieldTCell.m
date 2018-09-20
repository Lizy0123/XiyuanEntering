//
//  TitleTextFieldTCell.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/5.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//
#define kTitleStrWidth 100
#define kScaleFit (kScreen_Width / 375.0f)

#import "TitleTextFieldTCell.h"

@interface TitleTextFieldTCell ()<UITextFieldDelegate>
@property (strong, nonatomic) UILabel *titleLable, *valueLabel;
@property (nonatomic, strong) UIView *tapView;

@end

@implementation TitleTextFieldTCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, 7, kTitleStrWidth, 30)];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:kTitleFontSize];
        _titleLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLable];

        _myTtextField = [[MyTextField alloc] initWithFrame:CGRectMake(kMyPadding + kTitleStrWidth, 7, kScreen_Width - kMyPadding *2 - kTitleStrWidth, 30)];
        _myTtextField.backgroundColor = [UIColor clearColor];
        _myTtextField.font = [UIFont systemFontOfSize:kValueFontSize *kScaleFit];
        _myTtextField.textAlignment = NSTextAlignmentRight;
        _myTtextField.textColor = kColorValueStr;
        _myTtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _myTtextField.delegate = self;
        [self.contentView addSubview:_myTtextField];


    }return self;
}
- (void)setTapAcitonBlock:(CellTapAcitonBlock)tapAcitonBlock {
    _tapAcitonBlock = tapAcitonBlock;
    self.tapView.hidden = NO;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView updateConstraintsIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTtextField.frame = CGRectMake(kMyPadding + kTitleStrWidth, 7, kScreen_Width - kMyPadding *3 - kTitleStrWidth, 30);
    });
}

- (void)setEndEditBlock:(CellEndEditBlock)endEditBlock {
    _endEditBlock = endEditBlock;
    [self.myTtextField addTarget:self action:@selector(didEndEditTextField:) forControlEvents:UIControlEventAllEditingEvents];
}
- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:self.bounds];
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    NSLog(@"点击了textField，执行点击回调");
    if (self.tapAcitonBlock) {
        self.tapAcitonBlock();
    }
}

- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value placeHolder:(NSString *)placeHolder{
    _titleLable.text = title;
    _myTtextField.placeholder = placeHolder;
    _myTtextField.text = value;
}

- (void)didEndEditTextField:(UITextField *)textField {
    NSLog(@"textField编辑结束，回调编辑框输入的文本内容:%@", textField.text);
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}


+ (CGFloat)cellHeight{
    return 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
