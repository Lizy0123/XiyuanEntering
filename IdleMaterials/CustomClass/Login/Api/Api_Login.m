//
//  Api_Login.m
//  Taoyi
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "Api_Login.h"

@implementation Api_Login
{
    NSString *_userName;
    NSString *_password;
    NSString *_mobile;
    NSString *_mobileCode;
}

-(instancetype)initWithUserName:(NSString *)userName
                       password:(NSString *)password
                         mobile:(NSString *)mobile
                     mobileCode:(NSString *)mobileCode{
    if (self =[super init]) {
        _userName = userName;
        _password = password;
        _mobile = mobile;
        _mobileCode = mobileCode;
    }return self;
}

//-------------------------- 重写YTKRequest中方法,设置请求相关事宜 --------------------------

//htt://192.168.1.194:1800/JoinCustomer.ashx?action=login&userAccount=15801538221&Passwd=E10ADC3949BA59ABBE56E057F20F883E&version=1.0&BusinessAreaID=

//设置 http://192.168.1.194:1800/JoinCustomer.ashx? 剩下的网址信息
//http://192.168.0.54/CeramicPlatform/users/login
-(NSString *)requestUrl{
    return @"login";
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    return @{
             @"username":_userName,
             @"password":_password,
             @"mobile":_mobile,
             @"mobileCode":_mobileCode
             };
}
//-(YTKResponseSerializerType)responseSerializerType{
//    return YTKResponseSerializerTypeHTTP;
//}

//-(NSDictionary *)responseHeaders{
//    return self.response.allHeaderFields;
//}
//-(NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
//    return @{@"JSESSIONID":@"123"};
//}


//按时间缓存内容
//- (NSInteger)cacheTimeInSeconds {
//    // 3分钟 = 180 秒
//    //    return 60 * 3;
//    return 5;
//}
//验证返回数据格式
//- (id)jsonValidator {
//    return @{
//             @"data": @{
//                         @"AccountID" : [NSString class],
//                         @"Address" : [NSString class],
//                         @"Birthday" : [NSString class],
//                         @"BusinessAreaID" : [NSString class],
//                         @"City" : [NSString class],
//                         @"Credit" : [NSString class],
//                         @"Email" : [NSString class],
//                         @"HeadPhoto" : [NSString class],
//                         @"IDs" : [NSString class],
//                         @"IsPromotion" : [NSString class],
//                         @"MemberID" : [NSString class],
//                         @"MobilePhone" : [NSString class],
//                         @"Name" : [NSString class],
//                         @"P2PAccountID" : [NSString class],
//                         @"P2PMemberID" : [NSString class],
//                         @"PostCode" : [NSString class],
//                         @"Provice" : [NSString class],
//                         @"SelfPromotionID" : [NSString class],
//                         @"Sex" : [NSString class],
//                         @"SoloCredit" : [NSString class],
//                         @"Status" : [NSString class],
//                         @"Subs" : [NSArray class],
//                     },
//                 @"errorMessage" : [NSString class],
//                 @"flag" : [NSString class],
//             };
//
//}
//获取返回的数据
//- (NSString *)sessionId {
//    NSLog(@"Lzy:%s  %@",__FUNCTION__,[self responseJSONObject]);
//    return self.responseJSONObject[@"data"][@"AccountID"];
//}





@end
