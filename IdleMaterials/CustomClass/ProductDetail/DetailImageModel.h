//
//  DetailImageModel.h
//  YLuxury
//
//  Created by Lzy on 2017/8/13.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DetailImageModel : JSONModel
/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *imageUrl;
/**
 *  图片Name
 */
@property (nonatomic,copy) NSString *imageName;
/**
 *  CellHeight
 */
@property (nonatomic, assign)CGFloat cellHeight;
@end
