//
//  TitleValueView1.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/23.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleValueView1 : UIView
@property(copy, nonatomic)NSString *titleStr;
@property(copy, nonatomic)NSString *valueStr;
@property(strong, nonatomic)UILabel *label;

-(void)setTitleStr:(NSString *)titleStr valueStr:(NSString*)valueStr valueColor:(UIColor *)color;

@end
