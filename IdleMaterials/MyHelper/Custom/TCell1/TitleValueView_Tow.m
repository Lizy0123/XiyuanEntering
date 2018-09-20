//
//  TitleValueView_Tow.m
//  Taoyi
//
//  Created by Lzy on 2018/2/3.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "TitleValueView_Tow.h"
@interface TitleValueView_Tow ()
@property(strong, nonatomic)UILabel *titleLabel_Left, *valueLabel_Left, *titleLabel_Right, *valueLabel_Right;
@property(strong, nonatomic)UILabel *countTimeLabel;

@end
@implementation TitleValueView_Tow

-(void)configTitleStrLeft:(NSString *)titleStrLeft ValueStrLeft:(NSString *)valueStrLeft titleStrRight:(NSString *)titleStrRight ValueStrRight:(NSString *)valueStrRight{
    if (!self.titleLabel_Left) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(kMyPadding);
//            make.top.mas_equalTo(self);
//            make.height.mas_equalTo(44);
//        }];
        self.titleLabel_Left = label;
    }
    self.titleLabel_Left.text = titleStrLeft;
    [self.titleLabel_Left sizeToFit];
    [self.titleLabel_Left setX:kMyPadding];
    [self.titleLabel_Left setHeight:44];
    
    if (!self.valueLabel_Left) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_Left.mas_right).offset(kMyPadding/4);
            make.top.mas_equalTo(self);
            make.right.equalTo(self).offset(-kScreen_Width/2);
            make.height.mas_equalTo(44);
        }];
        self.valueLabel_Left = label;
        [self.valueLabel_Left adjustsFontSizeToFitWidth];
    }
    self.valueLabel_Left.text = valueStrLeft;
    
    
    
    if (!self.titleLabel_Right) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(kScreen_Width/2);
//            make.top.mas_equalTo(self);
//            make.height.mas_equalTo(44);
//        }];
        self.titleLabel_Right = label;
    }
    self.titleLabel_Right.text = titleStrRight;
    [self.titleLabel_Right sizeToFit];
    [self.titleLabel_Right setX:kScreen_Width/2];
    [self.titleLabel_Right setHeight:44];
    
    if (!self.valueLabel_Right) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel_Right.mas_right).offset(kMyPadding/4);
            make.top.mas_equalTo(self);
            make.right.equalTo(self).offset(-kMyPadding);
            make.height.mas_equalTo(44);
        }];
        self.valueLabel_Right = label;
        [self.valueLabel_Right adjustsFontSizeToFitWidth];
    }
    self.valueLabel_Right.text = valueStrRight;
}
+(CGFloat)viewHeight{
    return 44;
}

@end
