//
//  Api_DelProductById.h
//  LzyTool
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "MyRequest.h"

@interface Api_DelProductById : MyRequest
-(instancetype)initWithProductId:(NSString *)productId;
@end
