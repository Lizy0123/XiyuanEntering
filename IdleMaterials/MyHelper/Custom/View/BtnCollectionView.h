//
//  BtnCollectionView.h
//  Taoyi
//
//  Created by Lzy on 2018/2/1.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BtnCollectionView : UIView

@property(copy, nonatomic) void(^selectedBlock)(NSIndexPath *indexPath);
-(UIView *)initWithFrame:(CGRect)frame titleArray:(NSArray *)nameArray imageArray:(NSArray *)imageArray rowNumber:(CGFloat)rowNumber;
+(CGFloat)viewHeight;
@end
