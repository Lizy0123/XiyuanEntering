//
//  XR_CityView.m
//  hhhhhhh
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import "XR_CityView.h"
#import "XR_AreaView.h"

@interface XR_CityView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *aeraArray;
    
}
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain) NSArray *arrayList;
@end


@implementation XR_CityView


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-100, kScreen_Height-kSafeAreaTopHeight-kSafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(100, 0, kScreen_Width-100, kScreen_Height);
        self.arrayList = [[NSArray alloc]init];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"xiancheng.json" ofType:nil];
        aeraArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path2] options:NSJSONReadingMutableLeaves error:nil];
    }
    return self;
}

-(void)getCities:(NSArray *)cities{
    self.arrayList = cities;
    [self addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayList.count ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.arrayList[indexPath.row][@"CityName"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.arrayList count] > 0){
        XR_AreaView *area = [[XR_AreaView alloc]init];
        int cityid = [self.arrayList[indexPath.row][@"CityID"]intValue];
        NSMutableArray *areaArray = [[NSMutableArray alloc]init];
        for (NSDictionary *temp in aeraArray) {
            int aeraId = [temp[@"CityID"]intValue];
            if (aeraId == cityid) {
                [areaArray addObject:temp];
            }  
        }
        [area getArea:areaArray];
        area.block = ^(NSDictionary *area) {
            NSDictionary *dic = @{
                                  @"area":area[@"area"],
                                  @"thirdAddress":area[@"thirdAddress"],
                                  @"city":self.arrayList[indexPath.row][@"CityName"],
                                  @"secondAddress":self.arrayList[indexPath.row][@"CityID"]
                                  };
            if (_blockCity) {
                self.blockCity((NSMutableDictionary*)dic);
            }
        };
        [self addSubview:area];
    }
}

@end
