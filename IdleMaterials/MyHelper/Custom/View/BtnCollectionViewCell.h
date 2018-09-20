//
//  BtnCollectionViewCell.h
//  Taoyi
//
//  Created by Lzy on 2018/2/1.
//  Copyright © 2018年 Lzy. All rights reserved.
//
#define kCCellIdentifier_BtnCollectionViewCell @"BtnCollectionViewCell"

#import <UIKit/UIKit.h>

@interface BtnCollectionViewCell : UICollectionViewCell
@property(strong, nonatomic)UIImageView *imgView;
@property(strong, nonatomic)UILabel *titleLabel;
@end
