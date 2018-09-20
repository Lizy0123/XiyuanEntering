//
//  CategorySearchBar.h
//  XYGPWuZi
//
//  Created by Lzy on 2017/12/27.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(void);

@interface CategorySearchBar : UISearchBar
-(void)patchWithCategoryWithSelectBlock:(SelectBlock)block;
-(void)setSearchCategory:(NSString*)title;
@end


@interface MainSearchBar : UISearchBar
@property (strong, nonatomic) UIButton *scanBtn;
@end
