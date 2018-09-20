//
//  Api_SendUpdateLoginMobile.m
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_SendUpdateLoginMobileCode.h"

@implementation Api_SendUpdateLoginMobileCode{
    NSString *_mobile;
}

-(NSString *)requestUrl{
    return @"sendMobileCode";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(instancetype)initWithMobile:(NSString *)mobile{
    if (self = [super init]) {
        _mobile = mobile;
    }return self;
}

-(id)requestArgument{
    NSLog(@"%@",_mobile);
    return @{
             @"mobile" : _mobile,
             };
}
@end
