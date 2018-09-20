//
//  SearchBarView.h
//  XYGPWuZi
//
//  Created by Lzy on 2017/12/27.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarViewDelegate;

@interface SearchBarView : UIView
@property (nonatomic) NSString *placeholder;
@property (nonatomic, weak) id <SearchBarViewDelegate> delegate;
@end

@protocol SearchBarViewDelegate <NSObject>
@optional
- (void)searchBarAudioButtonClicked:(SearchBarView *)searchBarView;
- (void)searchBarSearchButtonClicked:(SearchBarView *)searchBarView;
@end

@interface RoundedView : UIView
@end
