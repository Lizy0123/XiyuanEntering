//
//  MyImgPickerCell.h
//  MyImgPickerView
//
//  Created by Lzy on 2018/1/15.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImgPickerCCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *deleteButton;
/** 视频标志 */
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, copy) void(^LLClickDeleteButton)(NSIndexPath *cellIndexPath);

@end
