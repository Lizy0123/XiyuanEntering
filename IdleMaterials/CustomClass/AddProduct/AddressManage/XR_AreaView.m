//
//  XR_AreaView.m
//  hhhhhhh
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import "XR_AreaView.h"

@interface XR_AreaView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic, copy) NSArray *arrayList;

@end


@implementation XR_AreaView

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
    }
    return self;
}
-(void)getArea:(NSArray *)areas
{
    self.arrayList = areas;
    [self addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.arrayList[indexPath.row][@"DisName"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = @{
                          @"area":self.arrayList[indexPath.row][@"DisName"],
                          @"thirdAddress":self.arrayList[indexPath.row][@"Id"]
                          };
    if (_block) {
        self.block((NSMutableDictionary*)dic);
    }
}

@end
