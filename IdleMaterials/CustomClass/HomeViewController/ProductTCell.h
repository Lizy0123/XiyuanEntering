//
//  ProductTCell.h
//  LzyTool
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTCell : UITableViewCell
@property (strong, nonatomic)UILabel *titleLabel, *specLabel, *priceLabel, *numLabel, *typeLabel;
@property(strong, nonatomic)UIImageView *productImageView;
@end
