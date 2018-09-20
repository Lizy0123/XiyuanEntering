


//
//  Api_SendLoginCode.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/30.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "Api_SendLoginCode.h"
@interface Api_SendLoginCode (){
    NSString *_mobile;
}
@end

@implementation Api_SendLoginCode

-(NSString *)requestUrl{
    return @"sendLoginCode";
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

//- (id)jsonValidator {
//    return @{
//             @"data": @{
//                     @"AccountID" : [NSString class],
//                     @"Address" : [NSString class],
//                     @"Birthday" : [NSString class],
//                     @"Status" : [NSString class],
//                     @"Subs" : [NSArray class],
//                     },
//             @"errorMessage" : [NSString class],
//             @"flag" : [NSString class],
//             };
//    
//}

@end
