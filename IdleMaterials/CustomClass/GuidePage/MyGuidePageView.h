//
//  MyGuidePageView.h
//  MyGuidePageView
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 dingding3w. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BOOLFORKEY @"GuidePage"

@interface MyGuidePageView : UIView
/**
 *  是否支持滑动进入APP(默认为NO-不支持滑动进入APP | 只有在buttonIsHidden为YES-隐藏状态下可用; buttonIsHidden为NO-显示状态下直接点击按钮进入)
 *  新增视频引导页同样不支持滑动进入APP
 */
@property (nonatomic, assign) BOOL slideInto;
typedef void(^callBack)(void);
@property(copy, nonatomic)callBack block;




/**
 *  MyGuidePageView(图片引导页 | 可自动识别动态图片和静态图片)
 *
 *  @param frame      位置大小
 *  @param imageNameArray 引导页图片数组(NSString)
 *  @param isHidden   开始体验按钮是否隐藏(YES:隐藏-引导页完成自动进入APP首页; NO:不隐藏-引导页完成点击开始体验按钮进入APP主页)
 *
 *  @return DHGuidePageHUD对象
 */
- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray isButtonHidden:(BOOL)isHidden;
/**
 *  MyGuidePageView(视频引导页)
 *
 *  @param frame    位置大小
 *  @param videoURL 引导页视频地址
 *
 *  @return DHGuidePageHUD对象
 */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL;





#pragma mark -
/**
 *  通过图片Data数据第一个字节来获取图片扩展名(严谨)
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

/**
 *  通过图片URL的截取来获取图片的扩展名(不严谨)
 */
+ (NSString *)contentTypeForImageURL:(NSString *)url;

/**
 *  自定义播放Gif图片(Path)
 *
 *  @param frame        位置和大小
 *  @param gifImagePath Gif图片路径
 *
 *  @return Gif图片对象
 */
- (id)initWithFrame:(CGRect)frame gifImagePath:(NSString *)gifImagePath;

/**
 *  自定义播放Gif图片(Data)(本地+网络)
 *
 *  @param frame        位置和大小
 *  @param gifImageData Gif图片Data
 *
 *  @return Gif图片对象
 */
- (id)initWithFrame:(CGRect)frame gifImageData:(NSData *)gifImageData;

/**
 *  自定义播放Gif图片(Name)
 *
 *  @param frame        位置和大小
 *  @param gifImageName Gif图片Name
 *
 *  @return Gif图片对象
 */
- (id)initWithFrame:(CGRect)frame gifImageName:(NSString *)gifImageName;

@end
