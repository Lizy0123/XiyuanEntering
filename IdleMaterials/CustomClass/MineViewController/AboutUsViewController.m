//
//  AboutUsViewController.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectZero];
    image.image = [UIImage imageNamed:@"MyImages"];
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, kScreen_Width, 20)];
    label.text = @"闲置资产录入系统";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectZero];
    label1.text = [NSString stringWithFormat:@"客服热线：0315-3859900%@",@""];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor blackColor];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-190);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    label2.text = [NSString stringWithFormat:@"客服邮箱：Service@xkxm.com%@",@""];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor blackColor];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-160);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];

    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectZero];
    label3.text = [NSString stringWithFormat:@"当前版本：V%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:13];
    label3.textColor = [UIColor blackColor];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-130);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"Copyright 2013 - 2018 工平物资 冀ICP备14021605号";
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(30+kSafeAreaBottomHeight));
        make.height.mas_equalTo(30);
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
