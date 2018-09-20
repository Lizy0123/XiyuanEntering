//
//  Api_Login.h
//  Taoyi
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "MyRequest.h"

@interface Api_Login : MyRequest
-(instancetype)initWithUserName:(NSString *)userName
                        password:(NSString *)password
                            mobile:(NSString *)mobile
                      mobileCode:(NSString *)mobileCode;

- (NSString *)sessionId;
@end
