//
//  DetailImageTCell.h
//  YLuxury
//
//  Created by Lzy on 2017/6/12.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailImageModel.h"

@interface DetailImageTCell : UITableViewCell

@property(strong, nonatomic)DetailImageModel *model;
@property (nonatomic, strong) UIImageView *Icon;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, copy ) void (^changeCellHeight)(void);
@end
