//
//  MyImgPicker.h
//  MyImgPickerView
//
//  Created by Lzy on 2018/1/15.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/** 媒体库管理中心 */
@interface MyImgPicker : NSObject

/**
 初始化单例
 
 @return 返回 ACMediaManager 的一个实例
 */
+ (instancetype)manager;

/**
 传入 Image 和 PHAsset，得到该图片的原图名称、上传类型NSData
 
 @param image 传入的图片
 @param asset PHAsset对象，没有原图则传入nil
 @param completion 成功的回调
 */
- (void)getImageInfoFromImage: (UIImage *)image PHAsset: (PHAsset *)asset completion: (void(^)(NSString *name, NSData *data))completion;

/**
 根据 URL 等获取视频封面、名称 和 上传类型(优先路径 或 NSData)
 
 @param videoURL   视频URL
 @param asset      视频PHAsset（本地存在原图才有这个属性值，不然传入nil）
 @param enableSave 对于本地没有的是否保存到本地
 @param completion 成功回调，不保存的话，返回的NSData
 */
- (void)getVideoPathFromURL: (NSURL *)videoURL PHAsset: (PHAsset *)asset enableSave: (BOOL)enableSave completion: (void(^)(NSString *name, UIImage *screenshot, id pathData))completion;

/**
 根据 PHAsset 来获取 媒体文件(视频或图片)相关信息：文件名、文件上传类型（data 或 path）
 
 @param asset  PHAsset对象
 @param completion 成功回调
 */
- (void)getMediaInfoFromAsset: (PHAsset *)asset completion: (void(^)(NSString *name, id pathData))completion;










#pragma mark - 常用判断
/**
 判断该字符串是不是一个有效的URL
 
 @return YES：是一个有效的URL or NO
 */
+ (BOOL)isValidUrl:(NSString *)str;

/** 根据图片名 判断是否是gif图 */
+ (BOOL)isGifImage:(NSString *)str;

/** 根据图片data 判断是否是gif图 */
+ (BOOL)isGifWithImageData: (NSData *)data;

/**
 根据image的data 判断图片类型
 
 @param data 图片data
 @return 图片类型(png、jpg...)
 */
+ (NSString *)contentTypeWithImageData: (NSData *)data;


/**
 寻找当前view所在的主视图控制器
 
 @return 返回当前主视图控制器
 */
+ (UIViewController *)getViewControllerWithView:(UIView *)view;


/**
 快速创建AlertController：包括Alert 和 ActionSheet
 
 @param title       标题文字
 @param message     消息体文字
 @param actions     可选择点击的按钮（不包括取消）
 @param cancelTitle 取消按钮（可自定义按钮文字）
 @param style       类型：Alert 或者 ActionSheet
 @param completion  完成点击按钮之后的回调（不包括取消）
 */

+ (void)showAlertWithTitle: (NSString *)title message: (NSString *)message actionTitles: (NSArray<NSString *> *)actions cancelTitle: (NSString *)cancelTitle style: (UIAlertControllerStyle)style completion: (void(^)(NSInteger index))completion;
















@end
