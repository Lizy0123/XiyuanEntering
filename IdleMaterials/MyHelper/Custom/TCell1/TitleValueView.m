//
//  TitleValueView.m
//  Taoyi
//
//  Created by Lzy on 2018/2/3.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "TitleValueView.h"

@interface TitleValueView ()
@property(strong, nonatomic)UILabel *titleLabel, *valueLabel;
@property(strong, nonatomic)UILabel *countTimeLabel;

@end

@implementation TitleValueView
-(void)configTitleStr:(NSString *)titleStr ValueStr:(NSString *)valueStr{
    if (!self.titleLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kMyPadding);
            make.top.mas_equalTo(self);
            make.right.equalTo(self).offset(-kMyPadding);
            make.height.mas_equalTo(44);
        }];
        self.titleLabel = label;
    }
    self.titleLabel.text = titleStr;
    [self.titleLabel sizeToFit];
    
    if (!self.valueLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(kMyPadding/2);
            make.top.mas_equalTo(self);
            make.right.equalTo(self).offset(-kMyPadding);
            make.height.mas_equalTo(44);
        }];
        self.valueLabel = label;
        [self.valueLabel adjustsFontSizeToFitWidth];
    }
    self.valueLabel.text = valueStr;

}

@end
