//
//  AddressManageerViewController.m
//  hhhhhhh
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 xiaoRan. All rights reserved.
//

#import "AddressManageerViewController.h"
#import "XR_CityView.h"


@interface AddressManageerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *provinces;
    NSArray *citiesArray;
    NSDictionary *wholeAera;
}
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation AddressManageerViewController
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-kSafeAreaTopHeight-kSafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    
    wholeAera = [[NSDictionary alloc]init];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //加载数据
    //provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"provice.json" ofType:nil];
    provinces = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];

    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"cities.json" ofType:nil];
    citiesArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path2] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"----%@",citiesArray);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return provinces.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // NSLog(@"%@",provinces);
    cell.textLabel.text = provinces[indexPath.row][@"ProName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XR_CityView *city = [[XR_CityView alloc]init];
    int str = [provinces[indexPath.row][@"ProID"]intValue];
    NSLog(@"-----%d",str);
    NSMutableArray *cityarray = [[NSMutableArray alloc]init];
    for (NSDictionary *temp in citiesArray) {
        int cityid =[temp[@"ProID"] intValue];
        if (cityid == str) {
            
            [cityarray addObject:temp];
        }
    }
    [city getCities:cityarray];
    city.blockCity = ^(NSDictionary *area) {
        if (area.count == 4) {
            wholeAera = @{
                          @"area":area[@"area"],@"thirdAddress":area[@"thirdAddress"],
                          @"city":area[@"city"],@"secondAddress":area[@"secondAddress"],
                          @"province":provinces[indexPath.row][@"ProName"],@"firstAddress":provinces[indexPath.row][@"ProID"]
                          };
        }
        else if (area.count == 2){
            wholeAera = @{
                          @"city":area[@"city"],@"secondAddress":area[@"secondAddress"],
                          @"province":provinces[indexPath.row][@"ProName"],@"firstAddress":provinces[indexPath.row][@"ProID"]
                          };
        }
        NSLog(@"%@",wholeAera);
        if (_blockAddress) {
            self.blockAddress((NSDictionary *)wholeAera);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.view addSubview:city];
}

@end
