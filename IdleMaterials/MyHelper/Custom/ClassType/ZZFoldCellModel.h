//
//  ZZFoldCellModel.h
//  ZZFoldCell
//
//  Created by 郭旭赞 on 2017/7/6.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZFoldCellModel : JSONModel

@property(nonatomic,copy) NSString * _Nullable text;
@property(nonatomic,copy) NSString * _Nullable level;
@property(nonatomic,copy) NSString * _Nullable proCategoryId;
//...

@property(nonatomic,assign) NSUInteger belowCount;
@property(nullable,nonatomic) ZZFoldCellModel *supermodel;
@property(nonatomic,strong) NSMutableArray<__kindof ZZFoldCellModel *> * _Nullable submodels;

+ (instancetype _Nullable )modelWithDic:(NSDictionary *_Nonnull)dic;
- (NSArray *_Nullable)open;
- (void)closeWithSubmodels:(NSArray *_Nullable)submodels;

@end
