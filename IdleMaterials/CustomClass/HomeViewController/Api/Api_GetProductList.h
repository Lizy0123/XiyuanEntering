//
//  Api_GetProductList.h
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "MyRequest.h"

@interface Api_GetProductList : MyRequest
-(instancetype)initWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize searchTime:(NSString *)searchTime creUser:(NSString *)creUser cateType:(NSString *)cateType name:(NSString *)name modelNo:(NSString *)modelNo;
@end
