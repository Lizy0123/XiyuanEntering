//
//  Api_ChangeProductByIdArray.m
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_ChangeProductByIdArray.h"

@implementation Api_ChangeProductByIdArray{
    NSString *_ids;
    NSString *_type;
}

-(instancetype)initWithProductsArray:(NSString *)ids type:(NSString *)type{
    if (self = [super init]) {
        _ids = ids;
        _type = type;
    }return self;
}
-(NSString *)requestUrl{
    return @"product/changeProductByIdArray";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"ids":_ids,//产品属性
             @"type":_type,//1上架2下架3调剂4导出5删除
             };
}
@end
