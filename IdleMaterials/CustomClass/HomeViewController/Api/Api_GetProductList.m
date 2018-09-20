//
//  Api_GetProductList.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_GetProductList.h"

@implementation Api_GetProductList{
    NSString *_pageIndex;
    NSString *_pageSize;
    NSString *_searchTime;
    NSString *_creUser;
    NSString *_cateType;
    NSString *_name;
    NSString *_modelNo;
    
}
-(instancetype)initWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize searchTime:(NSString *)searchTime creUser:(NSString *)creUser cateType:(NSString *)cateType name:(NSString *)name modelNo:(NSString *)modelNo{
    if (self = [super init]) {
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _searchTime = searchTime;
        _creUser = creUser;
        _cateType = cateType;
        _name = name;
        _modelNo = modelNo;
        _creUser = creUser;
    }return self;
}
-(NSString *)requestUrl{
    return @"product/companyProductList";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             
             @"piName":@"",//产品属性
             @"creUser":_creUser,
             @"name":_name,
             @"modelNo":_modelNo,
             @"page":_pageIndex,
             @"limit":_pageSize,//limit
             @"searchTime":_searchTime,//searchTime
//             @"type":@"",//参数(不为空是所有公司产品列表)
             @"cateType":_cateType,
             @"cpId":([NSObject isString:[UserManager readUserInfo].cpId]?[UserManager readUserInfo].cpId:@""),
             };
}
@end
