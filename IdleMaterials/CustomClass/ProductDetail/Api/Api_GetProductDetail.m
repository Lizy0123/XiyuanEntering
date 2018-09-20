//
//  Api_GetProductDetail.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_GetProductDetail.h"

@implementation Api_GetProductDetail{
    NSString *_productId;
}
-(instancetype)initWithProductId:(NSString *)productId{
    if (self = [super init]) {
        _productId = productId;
    }return self;
}
-(NSString *)requestUrl{
    return @"product/getProductInfo";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"id":_productId,//产品ID
             @"type":@"1",//1 产品详情页面(移动端此处赋值为1)
             };
}
@end
