//
//  SearchDisplayController.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/2.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

typedef NS_ENUM(NSUInteger, kSearchType) {
    kSearchType_ProductName=0,
    kSearchType_ProductModelNo,
    kSearchType_ProductCreUser,    
};




#import <UIKit/UIKit.h>

@interface SearchDisplayController : UISearchDisplayController
@property (nonatomic,weak)UIViewController *parentVC;
@property (nonatomic,assign)kSearchType curSearchType;
-(void)reloadDisplayData;

@end
