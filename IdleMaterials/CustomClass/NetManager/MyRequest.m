//
//  MyRequest.m
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "MyRequest.h"
#import "YTKBaseRequest+AnimatingAccessory.h"
#import "ZCHTTPError.h"
#import <AFNetworking.h>

@class ZCHTTPError;

@implementation MyRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.animatingText = @"";
}

- (BOOL)isHideErrorToast
{
    return NO;
}

//缓存时间<使用默认的start，在缓存周期内并没有真正发起请求>
//- (NSInteger)cacheTimeInSeconds
//{
//    return 60;
//}
//请求超时时间
- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}
-(NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    NSLog(@"传送的sessionId：%@",kStringSessionId);
//    return @{kSessionId:kStringSessionId};
    return @{@"Cookie":[NSString stringWithFormat:@"JSESSIONID=%@",kStringSessionId]};
}

- (void)requestCompletePreprocessor
{
    [super requestCompletePreprocessor];
    //json转model
}

///  Called on the main thread after request succeeded.
- (void)requestCompleteFilter
{
    [super requestCompleteFilter];
}

///  Called on background thread after request succeded but before switching to main thread. See also
///  `requestCompletePreprocessor`.
- (void)requestFailedPreprocessor
{
    [super requestFailedPreprocessor];
    //可以在此方法内处理token失效的情况，所有http请求统一走此方法，即会统一调用
    
    //如果部分服务端的失败以成功的方式返回给客户端，那么可以重写- (void)setCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
    //failure:(nullable YTKRequestCompletionBlock)failure 方法，不过这个时候如果程序中有用到代理的话代理也要重写
    
    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
    
    NSError * error = self.error;
    
    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain])
    {
        //AFNetworking处理过的错误
        
    }else if ([error.domain isEqualToString:YTKRequestValidationErrorDomain])
    {
        //猿题库处理过的错误
        
    }else{
        //系统级别的domain错误，无网络等[NSURLErrorDomain]
        //根据error的code去定义显示的信息，保证显示的内容可以便捷的控制
    }
    //初始化httpError的值
    //self.httpError = [[ZCHTTPError alloc] initWithDomain:<#(nonnull NSErrorDomain)#> code:<#(NSInteger)#> userInfo:<#(nullable NSDictionary *)#>];
}

///  Called on the main thread when request failed.
- (void)requestFailedFilter
{
    [super requestFailedFilter];
    
//    if (![self isHideErrorToast]) {
//        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//        
//        UIViewController * controller = [self findBestViewController:window.rootViewController];
//        [NSObject showStr:self.error.localizedDescription];
//        [WMHUDUntil showFailWithMessage:self.error.localizedDescription toView:controller.view];
//    }
    
}

#pragma mark - private method
- (UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}
@end
