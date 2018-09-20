//
//  BQCameraView.h
//  carame
//
//  Created by ZL on 14-9-24.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCameraView;
@protocol MyCameraViewDelegate <NSObject>
@optional
-(void)cameraDidSelected:(MyCameraView *)camera;
@end

@interface MyCameraView : UIView
@property(weak, nonatomic)id<MyCameraViewDelegate> delegate;

@end
