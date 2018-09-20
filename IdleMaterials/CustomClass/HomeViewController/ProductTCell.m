//
//  ProductTCell.m
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "ProductTCell.h"
#define padding 16
#define imageWidth 80
#define screen_Width [UIScreen mainScreen].bounds.size.width

@implementation ProductTCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing) {
        if (selected) {
            // 编辑状态去掉渲染
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.backgroundView.backgroundColor = [UIColor whiteColor];
            // 左边选择按钮去掉渲染背景
            UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            self.selectedBackgroundView = view;
            
        }
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding/2, imageWidth, imageWidth)];
        _productImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_productImageView];
        
        CGFloat imgLeft = (CGRectGetMaxX(_productImageView.frame)+padding);
        CGFloat typeLabelWidth = 40;

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgLeft, padding/2, screen_Width - imgLeft - padding -typeLabelWidth, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];

        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - padding - typeLabelWidth, CGRectGetMinY(_titleLabel.frame), typeLabelWidth, 20)];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.borderWidth = 1;
        _typeLabel.cornerRadius = 5;
        _typeLabel.clipsToBounds = YES;
        [self.contentView addSubview:_typeLabel];
        
        _specLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgLeft, CGRectGetMaxY(_titleLabel.frame)+3, screen_Width - (CGRectGetMaxX(_productImageView.frame)+padding/2) - padding , 30)];
        _specLabel.font = [UIFont systemFontOfSize:13];
        _specLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_specLabel];
        
        CGFloat priceLabelY = CGRectGetMaxY(_specLabel.frame)+3;
        CGFloat numLabelWidth = 80;
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgLeft, priceLabelY, screen_Width - (CGRectGetMaxX(_productImageView.frame)+padding/2) - padding - numLabelWidth, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(screen_Width - numLabelWidth, priceLabelY, numLabelWidth-padding, 20)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = [UIColor grayColor];
        _numLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_numLabel];
    }return self;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews){
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        img.image = [UIImage imageNamed:@"btn1-choose"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews){
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"btn1-choose-1"];
                    }
                    else{
                        img.image=[UIImage imageNamed:@"btn1-choose"];
                    }
                }
            }
        }
    }
}

@end
