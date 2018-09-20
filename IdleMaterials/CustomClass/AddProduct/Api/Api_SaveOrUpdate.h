//
//  Api_SaveOrUpdate.h
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "MyRequest.h"
#import "ProductModel.h"

@interface Api_SaveOrUpdate : MyRequest
-(instancetype)initWithProductModel:(ProductModel *)productM;
@property(strong, nonatomic)ProductModel *productM;
@end
