//
//  Api_GetAllCategoryData.m
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_GetAllCategoryData.h"

@implementation Api_GetAllCategoryData

-(instancetype)init{
    if (self = [super init]) {
        
    }return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(NSString *)requestUrl{
    return @"category/getCategoryTree";
}
@end
