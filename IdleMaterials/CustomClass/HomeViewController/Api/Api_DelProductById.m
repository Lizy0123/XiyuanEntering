//
//  Api_DelProductById.m
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_DelProductById.h"

@implementation Api_DelProductById{
    NSString *_productId;
}
-(instancetype)initWithProductId:(NSString *)productId{
    if (self = [super init]) {
        _productId = productId;
    }return self;
}
-(NSString *)requestUrl{
    return @"product/delProduct";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"id":_productId,
             };
}
@end
