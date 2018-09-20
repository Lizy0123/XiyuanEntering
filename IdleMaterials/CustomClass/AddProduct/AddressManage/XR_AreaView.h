//
//  XR_AreaView.h
//  hhhhhhh
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^areaBlock)(NSDictionary *);

@interface XR_AreaView : UIView


@property(nonatomic,copy)areaBlock block;

-(void)getArea:(NSArray *)areas;

@end
