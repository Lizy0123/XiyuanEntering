//
//  Api_SendLoginCode.h
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/30.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "YTKRequest.h"
// 登陆后签到

@interface Api_SendLoginCode : YTKRequest
-(instancetype)initWithMobile:(NSString *)mobile;
@end
