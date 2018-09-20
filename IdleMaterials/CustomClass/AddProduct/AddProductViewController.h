//
//  AddProductViewController.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/12.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "BaseViewController.h"
#import "AddProductModel.h"
#import "MyImgPickerView.h"
#import "ProductModel.h"

@interface AddProductViewController : BaseViewController
@property(assign, nonatomic)BOOL isEdit;
@property(strong, nonatomic)AddProductModel *addProductM;
@property(strong, nonatomic)ProductModel *productM;
@property(strong, nonatomic)MyImgPickerView *imgPickerView;
@property(strong, nonatomic)UIView *headerView;
@property(assign, nonatomic)BOOL isEquipment;
@end
