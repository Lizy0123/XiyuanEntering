//
//  UIImage+Common.h
//  ImgStretching
//
//  Created by Lzy on 2017/9/15.
//  Copyright © 2017年 Lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, ImageCombineOrientation){
    ImageCombineHorizental,
    ImageCombineVertical
};

@interface UIImage (Common)
+ (UIImage*) imageWithName:(NSString *) imageName;
+ (UIImage*) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;


+(UIImage *)imageWithColor:(UIColor *)aColor;
//+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

#pragma mark - Stretch

/**
 缩放图片到指定大小
 
 @param size 指定大小
 @return 返回缩放后图片
 */
-(UIImage *)scaleImageToSize:(CGSize)size;

/**
 裁剪图片到指定大小
 
 @param clipRect 裁剪尺寸
 @return 返回裁剪的图片
 */
-(UIImage *)clicpImageWithRect:(CGRect)clipRect;


/**
 根据数组中的图片拼接图片
 
 @param imageArr 图片数组
 @param orientation 拼接方向
 @return 返回拼接后的图片
 */
+(UIImage *)combineWithImages:(NSArray *)imageArr orientation:(ImageCombineOrientation)orientation;

/**
 局部收缩图片
 
 @param capInsets 保留的capInsets
 @param actualSize 实际的大小
 @return 返回的图片
 */
-(UIImage *)shrinkImageWithCapInsets:(UIEdgeInsets)capInsets actualSize:(CGSize)actualSize;

/**
 据不同大小返回占位图
 
 @param placeholderImgStr 图片
 @param size 想要的大小
 @param backgroundColor 自动填充的颜色（占位图的颜色）
 @return 返回规定尺寸的占位图
 */
+ (UIImage *)placeholderImage:(NSString *)placeholderImgStr withSize:(CGSize)size withBackgroundColor:(UIColor *)backgroundColor;

#pragma mark - 创建图片

/**
 根据颜色创建图片
 
 @param color 想要创建的图片的颜色
 @param frame 想要创建的图片的frame
 @return 颜色创建的图片
 */
+(UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)frame;



#pragma mark - 其他人的方法
-(UIImage *)imageCroppedToRect:(CGRect)rect;
-(UIImage*)scaleToNewSize:(CGSize)newSize;
-(CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;
-(void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;
-(void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
-(void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;
-(UIImage *)scaledToSize:(CGSize)targetSize;
-(UIImage *)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage *)scaledToMaxSize:(CGSize )size;
+(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+(UIImage *)fullScreenImageALAsset:(ALAsset *)asset;
+(UIImage *)imageWithFileType:(NSString *)fileType;
-(NSData *)dataSmallerThan:(NSUInteger)dataLength;
-(NSData *)dataForCodingUpload;


+(UIImage *)imageFromText:(NSArray*)arrContent withImageSize:(CGSize)imageSize withFont:(CGFloat)fontSize;
+(UIImage *)imageFromText1:(NSString*)text withFont:(CGFloat)fontSize;
+(UIImage *)addText:(UIImage *)img text:(NSString *)text1;
+(UIImage *)getImage:(NSString *)text font:(UIFont *)textFont textColor:(UIColor *)textColor size:(CGSize)imageSize;



@end
