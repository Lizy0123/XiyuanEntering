//
//  ZZTableViewController.h
//  ZZFoldCell
//
//  Created by 郭旭赞 on 2017/7/6.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LeibieNameBlock)(NSString*,NSString*,NSString*);
typedef void (^LeibieIdBlock)(NSString*,NSString*,NSString*);
@interface ZZTableViewController : UITableViewController


@property(nonatomic)LeibieNameBlock nameBlock;
@property(nonatomic)LeibieIdBlock idBlock;
@property(nonatomic, assign)BOOL isEquipment;
@end
