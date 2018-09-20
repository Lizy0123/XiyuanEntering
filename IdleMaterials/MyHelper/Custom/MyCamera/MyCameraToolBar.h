//
//  MyCameraToolBar.h
//  LGPhotoBrowser
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 L&G. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MyImageOrientation) {
    XGImageOrientationUp,            // default orientation
    XGImageOrientationDown,          // 180 deg rotation
    XGImageOrientationLeft,          // 90 deg CCW
    XGImageOrientationRight,         // 90 deg CW
    XGImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
    XGImageOrientationDownMirrored,  // horizontal flip
    XGImageOrientationLeftMirrored,  // vertical flip
    XGImageOrientationRightMirrored, // vertical flip
};

@protocol MyCameraToolBarDelegate <NSObject>
- (void)useBtnClicked;
- (void)cancleBtnClicked;
@end

@interface MyCameraToolBar : UIImageView
@property (nonatomic, weak) id<MyCameraToolBarDelegate>delegate;
@property (nonatomic, strong) UIImage *imageToDisplay;
@property (nonatomic, assign) MyImageOrientation imageOrientation;
@end






@interface MyCameraModel : NSObject

//@property (copy,nonatomic) NSString *imagePath;
@property (strong,nonatomic) UIImage *thumbImage;
@property (strong,nonatomic) UIImage *photoImage;

@end

@class MyCameraImgView;
@protocol MyCameraImgViewDelegate <NSObject>

@optional
/**
 *  根据index来删除照片
 */
-(void)deleteImgView:(MyCameraImgView *)imgView;
@end

@interface MyCameraImgView : UIImageView
@property(weak, nonatomic)id <MyCameraImgViewDelegate> delegatge;
/**
 *  是否是编辑模式 , YES 代表是
 */
@property (assign, nonatomic, getter = isEdit) BOOL edit;


@end
