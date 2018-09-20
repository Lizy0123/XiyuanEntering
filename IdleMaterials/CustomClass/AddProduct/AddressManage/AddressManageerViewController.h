//
//  AddressManageerViewController.h
//  hhhhhhh
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^addressBlock)(NSDictionary *);

@interface AddressManageerViewController : UIViewController

@property(nonatomic,copy)addressBlock blockAddress;

@end
