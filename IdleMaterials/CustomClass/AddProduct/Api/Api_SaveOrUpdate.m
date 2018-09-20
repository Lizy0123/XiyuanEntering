//
//  Api_SaveOrUpdate.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_SaveOrUpdate.h"

@implementation Api_SaveOrUpdate
-(instancetype)initWithProductModel:(ProductModel *)productM{
    if (self = [super init]) {
        _productM = productM;
    }return self;
}
-(NSString *)requestUrl{
    return @"product/saveOrUpdate";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"pdId" : ([NSObject isString:_productM.pdId]?_productM.pdId:@""),
             @"name" : ([NSObject isString:_productM.name]?_productM.name:@""),
             @"modelNo" : ([NSObject isString:_productM.modelNo]?_productM.modelNo:@""),
             @"size" : ([NSObject isString:_productM.size]?_productM.size:@""),
             @"oldWeight" : ([NSObject isString:_productM.oldWeight]?_productM.oldWeight:@""),
             @"nowWeight" : ([NSObject isString:_productM.nowWeight]?_productM.nowWeight:@""),
             @"allAddress" : ([NSObject isString:_productM.allAddress]?_productM.allAddress:@""),
             @"address" : ([NSObject isString:_productM.address]?_productM.address:@""),
             @"provinceId" : ([NSObject isString:_productM.provinceId]?_productM.provinceId:@""),
             @"cityId" : ([NSObject isString:_productM.cityId]?_productM.cityId:@""),
             @"countyId" : ([NSObject isString:_productM.countyId]?_productM.countyId:@""),
             @"num" : ([NSObject isString:_productM.num]?_productM.num:@""),
             @"unit" : ([NSObject isString:_productM.unit]?_productM.unit:@""),
             @"brand" : ([NSObject isString:_productM.brand]?_productM.brand:@""),
             @"manufacturer" : ([NSObject isString:_productM.manufacturer]?_productM.manufacturer:@""),
             @"supplier" : ([NSObject isString:_productM.supplier]?_productM.supplier:@""),
             @"oldDegree" : ([NSObject isString:_productM.oldDegree]?_productM.oldDegree:@""),
             @"workLong" : ([NSObject isString:_productM.workLong]?_productM.workLong:@""),
             @"unuseBeginTime" : ([NSObject isString:_productM.unuseBeginTime]?_productM.unuseBeginTime:@""),
             @"useBeginTime" : ([NSObject isString:_productM.useBeginTime]?_productM.useBeginTime:@""),
             @"oldValue" : ([NSObject isString:_productM.oldValue]?_productM.oldValue:@""),
             @"remark" : ([NSObject isString:_productM.remark]?_productM.remark:@""),
             @"description" : ([NSObject isString:_productM.desc]?_productM.desc:@""),
             @"cateType" : ([NSObject isString:_productM.cateType]?_productM.cateType:@""),
//             @"categoryId" : ([NSObject isString:_productM.categoryId]?_productM.categoryId:@""),
             @"oneId" : ([NSObject isString:_productM.oneId]?_productM.oneId:@""),
             @"twoId" : ([NSObject isString:_productM.twoId]?_productM.twoId:@""),
             @"threeId" : ([NSObject isString:_productM.threeId]?_productM.threeId:@""),
             @"figureNo":([NSObject isString:_productM.figureNo]?_productM.figureNo:@""),
             @"materialQuality":([NSObject isString:_productM.materialQuality]?_productM.materialQuality:@""),
             @"usefulDate" : ([NSObject isString:_productM.usefulDate]?_productM.usefulDate:@""),
             @"pics" : ([NSObject isString:_productM.pics]?_productM.pics:@""),
             };
}
@end
