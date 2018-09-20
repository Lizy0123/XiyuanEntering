//
//  Api_UpdateLoginMobile.m
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "Api_UpdateLoginMobile.h"

@implementation Api_UpdateLoginMobile{
    NSString *_oldMobileCode;
    NSString *_newMobileCode;
    NSString *_newMobile;
    
}
-(instancetype)initWithOldMobjleCode:(NSString *)oldMobileCode
                       newMobileCode:(NSString *)newMobileCode
                           newMobile:(NSString *)newMobile{
    self = [super init];
    if (self) {
        _oldMobileCode = oldMobileCode;
        _newMobileCode = newMobileCode;
        _newMobile = newMobile;
        
    }
    return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    return @"linkman/updateLoginMobile";
}

- (id)requestArgument {
    return @{
             @"code1": _oldMobileCode,
             @"code2": _newMobileCode,
             @"mobile": _newMobile,
             };
}
@end
