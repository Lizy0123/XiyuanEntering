//
//  UIImage+Common.m
//  ImgStretching
//
//  Created by Lzy on 2017/9/15.
//  Copyright © 2017年 Lzy. All rights reserved.
//
#define CONTENT_MAX_WIDTH   300.0f
#import "UIImage+Common.h"
static BOOL SAImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
    
    return hasAlpha;
}

@implementation UIImage (Common)

//是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//是否为iOS8及以上系统
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

/**
 *  争对ios7以上的系统适配新的图片资源
 *
 *  @param imageName 图片名称
 *
 *  @return 新的图片
 */
+ (UIImage *)imageWithName:(NSString *)imageName
{
    UIImage *newImage = nil;
    if (iOS7) {
        newImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_os7"]];
    }
    if (newImage == nil) {
        newImage = [UIImage imageNamed:imageName];
    }
    return newImage;
    
}
+ (UIImage *)resizableImageWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

/**
 *  实现图片的缩小或者放大
 *
 *  @param size  大小范围
 *
 *  @return 新的图片
 */

-(UIImage*) scaleImageWithSize:(CGSize)size
{
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

/**
 *  Description
 *
 *  @param width  <#width description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height {
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}





+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Stretch

-(UIImage *)scaleImageToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//展开画图，设定大小
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    return scaleImage;
}

-(UIImage *)clicpImageWithRect:(CGRect)clipRect{
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(self.CGImage, clipRect);
    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, clipImageRef);
    
    UIImage *clipImage = [UIImage imageWithCGImage:clipImageRef];
    UIGraphicsEndImageContext();
    return clipImage;
}

+(UIImage *)combineWithImages:(NSArray *)imageArr orientation:(ImageCombineOrientation)orientation{
    NSMutableArray *sizeArr = [NSMutableArray new];
    CGFloat maxHeight = 0, maxWidth = 0;
    for (id image in imageArr) {
        CGSize size = ((UIImage *)image).size;
        if (orientation == ImageCombineHorizental) {
            maxWidth += size.width;
            maxHeight = (size.height > maxHeight) ? size.height : maxHeight;
        }
        else{
            maxWidth = (size.width > maxWidth) ? size.width : maxWidth;
            maxHeight += size.height;
        }
        [sizeArr addObject:[NSValue valueWithCGSize:size]];
    }
    CGFloat lastLength = 0;//记录上一次的最右或者最下边值
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth, maxHeight));
    for (int i = 0; i < sizeArr.count; i++){
        CGSize size = [[sizeArr objectAtIndex:i] CGSizeValue];
        CGRect currentRect;
        if(orientation == ImageCombineHorizental){//横向
            currentRect = CGRectMake(lastLength, (maxHeight - size.height) / 2.0, size.width, size.height);
            [[imageArr objectAtIndex:i] drawInRect:currentRect];
            lastLength = CGRectGetMaxX(currentRect);
        }
        else{
            currentRect = CGRectMake((maxWidth - size.width) / 2.0, lastLength, size.width, size.height);
            [[imageArr objectAtIndex:i] drawInRect:currentRect];
            lastLength = CGRectGetMaxY(currentRect);
        }
    }
    UIImage* combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return combinedImage;
    
}

-(UIImage *)shrinkImageWithCapInsets:(UIEdgeInsets)capInsets actualSize:(CGSize)actualSize{
    //默认拉伸好了 暂时不处理平铺的情况
    //分为三块 两边不变 中间收缩
    UIImage *myImage = self;
    NSMutableArray *imageArr = [NSMutableArray new];
    //左侧
    if (actualSize.width < self.size.width) {
        if (capInsets.left > 0) {
            UIImage *leftImage = [myImage clicpImageWithRect:CGRectMake(0, 0, capInsets.left, myImage.size.height)];
            [imageArr addObject:leftImage];
        }
    }
    //中间
    //缩短到的距离
    CGFloat shrinkWidth = actualSize.width - capInsets.left - capInsets.right;
    if (shrinkWidth > 0) {
        UIImage *centerImage = [myImage clicpImageWithRect:CGRectMake(capInsets.left, 0, myImage.size.width - capInsets.left - capInsets.right, myImage.size.height)];
        [imageArr addObject:centerImage];
    }
    //右侧
    if (capInsets.right > 0) {
        UIImage *rightImage = [myImage clicpImageWithRect:CGRectMake(myImage.size.width - capInsets.right, 0, capInsets.right, myImage.size.height)];
        [imageArr addObject:rightImage];
    }
    //拼接
    if (imageArr.count > 0) {
        myImage = [UIImage combineWithImages:imageArr orientation:ImageCombineHorizental];
        if (actualSize.height >= self.size.height) {
            return myImage;
        }
    }
    
    
    if (actualSize.height < self.size.height) {
        NSMutableArray *imageArr = [NSMutableArray new];
        //顶部
        if (capInsets.top > 0) {
            UIImage *topImage = [myImage clicpImageWithRect:CGRectMake(0, 0, self.size.width, capInsets.top)];
            [imageArr addObject:topImage];
        }
        //中间
        //缩短到的距离
        CGFloat shrinkHeight = actualSize.height - capInsets.top - capInsets.bottom;
        if (shrinkHeight > 0) {
            UIImage *centerImage = [myImage clicpImageWithRect:CGRectMake(0, capInsets.top, myImage.size.width, myImage.size.height - capInsets.bottom - capInsets.top)];
            centerImage = [centerImage scaleImageToSize:CGSizeMake(myImage.size.width, shrinkHeight)];
            [imageArr addObject:centerImage];
        }
        //底部
        if (capInsets.bottom > 0) {
            UIImage *bottonImage = [myImage clicpImageWithRect:CGRectMake(0, myImage.size.height - capInsets.bottom, myImage.size.width, capInsets.bottom)];
            [imageArr addObject:bottonImage];
        }
        //拼接
        if (imageArr.count > 0) {
            myImage = [UIImage combineWithImages:imageArr orientation:ImageCombineVertical];
            return myImage;
        }
    }
    return nil;
}

+ (UIImage *)placeholderImage:(NSString *)placeholderImgStr withSize:(CGSize)size withBackgroundColor:(UIColor *)backgroundColor{
    // 中间LOGO图片
    UIImage *image = [UIImage imageNamed:placeholderImgStr];
    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resImage;
}


//+(UIImage *)imageWithColor:(UIColor *)color withFrame:(CGRect)frame{
//    UIGraphicsBeginImageContext(frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, frame);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}







- (UIImage *)imageCroppedToRect:(CGRect)rect {
    // CGImageCreateWithImageInRect's `rect` parameter is in pixels of the image's coordinates system. Convert from points.
    CGFloat scale = self.scale;
    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}
- (UIImage*)scaleToNewSize:(CGSize)newSize {
    size_t destWidth = (size_t)(newSize.width * self.scale);
    size_t destHeight = (size_t)(newSize.height * self.scale);
    if (self.imageOrientation == UIImageOrientationLeft
        || self.imageOrientation == UIImageOrientationLeftMirrored
        || self.imageOrientation == UIImageOrientationRight
        || self.imageOrientation == UIImageOrientationRightMirrored) {
        size_t temp = destWidth;
        destWidth = destHeight;
        destHeight = temp;
    }
    
    static CGColorSpaceRef rgbColorSpace = NULL;
    if (!rgbColorSpace) {
        rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    /// Create an ARGB bitmap context
    CGImageAlphaInfo alphaInfo = (SAImageHasAlpha(self.CGImage) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst);
    CGContextRef bmContext = CGBitmapContextCreate(NULL, destWidth, destHeight, 8/*Bits per component*/, destWidth * 4, rgbColorSpace, kCGBitmapByteOrderDefault | alphaInfo);
    
    if (!bmContext)
        return nil;
    
    /// Image quality
    CGContextSetShouldAntialias(bmContext, true);
    CGContextSetAllowsAntialiasing(bmContext, true);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    /// Draw the image in the bitmap context
    
    UIGraphicsPushContext(bmContext);
    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
    UIGraphicsPopContext();
    
    /// Create an image object from the context
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];
    
    /// Cleanup
    CGImageRelease(scaledImageRef);
    CGContextRelease(bmContext);
    
    return scaled;
}
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
        if (contentMode == UIViewContentModeLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTop) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottom) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeCenter) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + (rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y,
                              
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeScaleAspectFill) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
                
            } else {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
            
        } else if (contentMode == UIViewContentModeScaleAspectFit) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
                
            } else {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
        }
    }
    return rect;
}

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
    BOOL clip = NO;
    CGRect originalRect = rect;
    if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
        clip = contentMode != UIViewContentModeScaleAspectFill
        && contentMode != UIViewContentModeScaleAspectFit;
        rect = [self convertRect:rect withContentMode:contentMode];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (clip) {
        CGContextSaveGState(context);
        CGContextAddRect(context, originalRect);
        CGContextClip(context);
    }
    
    [self drawInRect:rect];
    
    if (clip) {
        CGContextRestoreGState(context);
    }
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius {
    [self drawInRect:rect radius:radius contentMode:UIViewContentModeScaleToFill];
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (radius) {
        [self addRoundedRectToPath:context rect:rect radius:radius];
        CGContextClip(context);
    }
    
    [self drawInRect:rect contentMode:contentMode];
    
    CGContextRestoreGState(context);
}
#pragma mark - Private
- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0) {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
        
    } else {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}





//对图片尺寸进行压缩--
-(UIImage*)scaledToSize:(CGSize)targetSize{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"could not scale image");
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

-(UIImage *)scaledToMaxSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

+ (UIImage *)fullScreenImageALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];//fullScreenImage已经调整过方向了
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    return img;
}

+ (UIImage *)imageWithFileType:(NSString *)fileType{
    fileType = [fileType lowercaseString];
    NSString *iconName;
    //XXX(s)
    if ([fileType hasPrefix:@"doc"]) {
        iconName = @"icon_file_doc";
    }else if ([fileType hasPrefix:@"ppt"]) {
        iconName = @"icon_file_ppt";
    }else if ([fileType hasPrefix:@"pdf"]) {
        iconName = @"icon_file_pdf";
    }else if ([fileType hasPrefix:@"xls"]) {
        iconName = @"icon_file_xls";
    }
    //XXX
    else if ([fileType isEqualToString:@"txt"]) {
        iconName = @"icon_file_txt";
    }else if ([fileType isEqualToString:@"ai"]) {
        iconName = @"icon_file_ai";
    }else if ([fileType isEqualToString:@"apk"]) {
        iconName = @"icon_file_apk";
    }else if ([fileType isEqualToString:@"md"]) {
        iconName = @"icon_file_md";
    }else if ([fileType isEqualToString:@"psd"]) {
        iconName = @"icon_file_psd";
    }
    //XXX||YYY
    else if ([fileType isEqualToString:@"zip"] || [fileType isEqualToString:@"rar"] || [fileType isEqualToString:@"arj"]) {
        iconName = @"icon_file_zip";
    }else if ([fileType isEqualToString:@"html"]
              || [fileType isEqualToString:@"xml"]
              || [fileType isEqualToString:@"java"]
              || [fileType isEqualToString:@"h"]
              || [fileType isEqualToString:@"m"]
              || [fileType isEqualToString:@"cpp"]
              || [fileType isEqualToString:@"json"]
              || [fileType isEqualToString:@"cs"]
              || [fileType isEqualToString:@"go"]) {
        iconName = @"icon_file_code";
    }else if ([fileType isEqualToString:@"avi"]
              || [fileType isEqualToString:@"rmvb"]
              || [fileType isEqualToString:@"rm"]
              || [fileType isEqualToString:@"asf"]
              || [fileType isEqualToString:@"divx"]
              || [fileType isEqualToString:@"mpeg"]
              || [fileType isEqualToString:@"mpe"]
              || [fileType isEqualToString:@"wmv"]
              || [fileType isEqualToString:@"mp4"]
              || [fileType isEqualToString:@"mkv"]
              || [fileType isEqualToString:@"vob"]) {
        iconName = @"icon_file_movie";
    }else if ([fileType isEqualToString:@"mp3"]
              || [fileType isEqualToString:@"wav"]
              || [fileType isEqualToString:@"mid"]
              || [fileType isEqualToString:@"asf"]
              || [fileType isEqualToString:@"mpg"]
              || [fileType isEqualToString:@"tti"]) {
        iconName = @"icon_file_music";
    }
    //unknown
    else{
        iconName = @"icon_file_unknown";
    }
    return [UIImage imageNamed:iconName];
}

- (NSData *)dataSmallerThan:(NSUInteger)dataLength{
    CGFloat compressionQuality = 1.0;
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    while (data.length > dataLength) {
        CGFloat mSize = data.length / (1024 * 1000.0);
        compressionQuality *= pow(0.7, log(mSize)/ log(3));//大概每压缩 0.7，mSize 会缩小为原来的三分之一
        data = UIImageJPEGRepresentation(self, compressionQuality);
    }
    return data;
}
- (NSData *)dataForCodingUpload{
    return [self dataSmallerThan:1024 * 1000];
}

//+(UIImage *)imageFromText:(NSArray*) arrContent withFont: (CGFloat)fontSize{
//    // set the font type and size
//    UIFont *font = [UIFont systemFontOfSize:fontSize];
//    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
//
//    CGFloat fHeight = 0.0f;
//    for (NSString *sContent in arrContent) {
//        //boundingRectWithSize:options:attributes:context:
//         NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
//         CGSize stringSize = [sContent boundingRectWithSize:CGSizeMake(100, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
////        CGSize stringSize1 = [sContent boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSAttributedStringKey,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
////        CGSize stringSize = [sContent sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_MAX_WIDTH, 10000) lineBreakMode:NSLineBreakByWordWrapping];
//        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
//
//        fHeight += stringSize.height;
//    }
//
//
//    CGSize newSize = CGSizeMake(CONTENT_MAX_WIDTH+20, fHeight+50);
//
//    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetCharacterSpacing(ctx, 10);
//    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
//    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
//    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
//
//    int nIndex = 0;
//    CGFloat fPosY = 20.0f;
//    for (NSString *sContent in arrContent) {
//        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
//        CGRect rect = CGRectMake(10, fPosY, CONTENT_MAX_WIDTH , [numHeight floatValue]);
//
//
//        [sContent drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
//
//        fPosY += [numHeight floatValue];
//        nIndex++;
//    }
//    // transfer image
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

+(UIImage *)imageFromText:(NSArray*) arrContent withImageSize:(CGSize)imageSize withFont: (CGFloat)fontSize{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
    CGFloat fHeight = 0.0f;
    for (NSString *sContent in arrContent) {
        CGSize stringSize = [sContent sizeWithFont:font constrainedToSize:imageSize lineBreakMode:UILineBreakModeWordWrap];
        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
        fHeight += stringSize.height;
    }
    CGSize newSize = imageSize;
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(ctx, 10);
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    int nIndex = 0;
    CGFloat fPosY = 20.0f;
    for (NSString *sContent in arrContent) {
        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
        CGRect rect = CGRectMake(10, fPosY, 100 , [numHeight floatValue]);
        [sContent drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
        fPosY += [numHeight floatValue];
        nIndex++;
    }

    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}

+(UIImage *)imageFromText1:(NSString*)text withFont:(CGFloat)fontSize{
    // set the font type and size
    //加载图像
    UIImage *sourceImage = [UIImage imageNamed:@"transFormPic.jpg"];
    //图像尺寸
    CGSize imageSize;
    imageSize = [sourceImage size];
    //比例1:1
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 1.0);
    //绘制点
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);// 设置画笔宽度
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = imageSize.width;
    //画 自己想要画的内容
    //[UIFont fontWithName:@"TRENDS" size:nameFont]
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGSize strSize = [text sizeWithAttributes:attributes];
    CGFloat marginTop = (sourceImage.size.width - strSize.width)/2;
    NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
    CGContextSetAllowsAntialiasing(context,NO);// 关闭锯齿
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

    [text drawInRect:CGRectMake(0, -marginTop-2, sourceImage.size.width, sourceImage.size.height) withAttributes:attributes];
    // [text drawAtPoint:CGPointMake(0,0) withAttributes:attributes];

    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    NSString *pngPath =[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/kuitu.bmp"];
    [UIImagePNGRepresentation(newImage) writeToFile:pngPath atomically:YES];
    UIGraphicsEndImageContext();

    return newImage;
}

+(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //设置字体样式
    UIFont*font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:32];
    NSDictionary*dict =@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor redColor]};
    CGSize textSize = [text1 sizeWithAttributes:dict];
    //绘制上下文
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0,0, img.size.width, img.size.height)];
    int border =10;
    CGRect re = {CGPointMake(img.size.width- textSize.width- border, img.size.height- textSize.height- border), textSize};
    //此方法必须写在上下文才生效

    [text1 drawInRect:re withAttributes:dict];
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

+(UIImage *)getImage:(NSString *)text font:(UIFont *)textFont textColor:(UIColor *)textColor  size:(CGSize)imageSize{
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width , imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *headerimg = [self imageToAddText:img withText:text withFont:textFont textColor:(UIColor *)textColor];
    return headerimg;
}

//把文字绘制到图片上
+ (UIImage *)imageToAddText:(UIImage *)image withText:(NSString *)text withFont:(UIFont *)textFont textColor:(UIColor *)textColor{
    NSInteger stringWidth = [text getWidthWithFont:textFont constrainedToSize:CGSizeMake(80, 30)];
    CGSize size=CGSizeMake(image.size.width, image.size.height);//画布大小
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawAtPoint:CGPointMake(0, 0)];

    //获得一个位图图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);

    [text drawAtPoint:CGPointMake(image.size.width/2 - stringWidth/2, 5) withAttributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor}];
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;




//    //1.获取上下文
//    UIGraphicsBeginImageContext(img.size);
//    //2.绘制图片
//    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
//    //3.绘制文字
//    CGRect rect = CGRectMake(0,0, img.size.width, 25);
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.alignment = NSTextAlignmentCenter;
//    //文字的属性
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:kColorMain};
//    //将文字绘制上去
//    [text drawInRect:rect withAttributes:dic];
//    //4.获取绘制到得图片
//    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
//    //5.结束图片的绘制
//    UIGraphicsEndImageContext();
//
//    return watermarkImg;
}

//- (UIImage *)createShareImage:(NSString *)str name:(NSString *)name number:(NSString *)number grade:(NSString *)grade{
//    UIImage *image = [UIImage imageNamed:@"shareGrade"];
//    CGSize size=CGSizeMake(image.size.width, image.size.height);//画布大小
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
//    [image drawAtPoint:CGPointMake(0, 0)];
//
//    //获得一个位图图形上下文
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextDrawPath(context, kCGPathStroke);
//
//    //画 打败了多少用户
//    [str drawAtPoint:CGPointMake(30, image.size.height*0.65) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:30],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    //画自己想画的内容。。。。。
//
//    //返回绘制的新图形
//    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

@end
