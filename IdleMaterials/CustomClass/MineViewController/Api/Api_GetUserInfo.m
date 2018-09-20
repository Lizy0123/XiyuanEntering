//
//  Api_GetUserInfo.m
//  YTKNetworkDemo
//
//  Created by TangQiao on 11/8/14.
//  Copyright (c) 2014 yuantiku.com. All rights reserved.
//

#import "Api_GetUserInfo.h"

@implementation Api_GetUserInfo {
    NSString *_userId;
}

- (id)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    return @"linkman/getLoginLinkManInfo";
}

//- (id)requestArgument {
//    return @{ @"id": _userId };
//}

//- (id)jsonValidator {
//    return @{
//        @"nick": [NSString class],
//        @"level": [NSNumber class]
//    };
//}

//- (NSInteger)cacheTimeInSeconds {
//    return 60 * 3;
//}

@end
