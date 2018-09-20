//
//  ProductDetailViewController.h
//  LzyTool
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

@interface ProductDetailViewController : BaseViewController
@property(strong, nonatomic)ProductModel *productM;
@property(assign, nonatomic)BOOL isEquipment;
@end
