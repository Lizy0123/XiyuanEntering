//
//  AddProductViewController.m
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/12.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import "AddProductViewController.h"
#import "BRPickerView.h"
#import "MyStepper.h"
#import "MyPhotoPickerView.h"
#import "ZZTableViewController.h"
#import "TitleTextFieldTView.h"
#import "ZZTableViewController.h"
#import "AddressManageerViewController.h"

#import "Api_SaveOrUpdate.h"
#import "Api_GetAllCategoryData.h"
#import "Api_UploadImage.h"
#import "YTKBatchRequest.h"
#import "YTKNetworkConfig.h"
#import "YTKBatchRequest+AnimatingAccessory.h"
#import "YTKChainRequest+AnimatingAccessory.h"

@interface AddProductViewController ()<UITextViewDelegate>

@property(strong, nonatomic)UIScrollView *myScrollView;
@property(strong, nonatomic)MyStepper *numberStepper;
@property(strong, nonatomic)NSMutableArray *imgUrlArray;
@property(strong, nonatomic)NSMutableArray *imgDataArray;
@property(assign, nonatomic)NSInteger contentViewHeight;
//仅用于取出cell用于block传值后进行更改，无实际用处
@property(strong, nonatomic)TitleTextFieldTView *view_i_0;
@property(strong, nonatomic)TitleTextFieldTView *view_i_1;
@property(strong, nonatomic)TitleTextFieldTView *view_i_2;
@property(strong, nonatomic)TitleTextFieldTView *view_i_3;
@property(strong, nonatomic)TitleTextFieldTView *view_i_4;
@property(strong, nonatomic)TitleTextFieldTView *view_i_5;
@property(strong, nonatomic)TitleTextFieldTView *view_i_6;
@property(strong, nonatomic)TitleTextFieldTView *view_i_7;
@property(strong, nonatomic)TitleTextFieldTView *view_i_8;
@property(strong, nonatomic)TitleTextFieldTView *view_i_9;
@property(strong, nonatomic)TitleTextFieldTView *view_i_10;
@property(strong, nonatomic)TitleTextFieldTView *view_i_11;
@property(strong, nonatomic)TitleTextFieldTView *view_i_12;
@property(strong, nonatomic)TitleTextFieldTView *view_i_13;
@property(strong, nonatomic)TitleTextFieldTView *view_i_14;
@property(strong, nonatomic)TitleTextFieldTView *view_i_15;
@property(strong, nonatomic)TitleTextFieldTView *view_i_16;
@property(strong, nonatomic)TitleTextFieldTView *view_i_17;
@property(strong, nonatomic)TitleTextFieldTView *view_i_18;
@property(strong, nonatomic)TitleTextFieldTView *view_i_19;
@property(strong, nonatomic)UITextView *myTextView;
@property(strong, nonatomic)UIView *sepView;
@property(strong, nonatomic)UIView *footerView;
@end

@implementation AddProductViewController
-(ProductModel *)productM{
    if (!_productM) {
        _productM = [[ProductModel alloc] init];
        if (_isEquipment) {
            _productM.cateType = @"1";
        }else{
            _productM.cateType = @"2";
        }
        _productM.unit = @"吨";
    }return _productM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isEquipment) {
        self.title = self.isEdit?@"编辑设备":@"添加设备";
    }else{
        self.title = self.isEdit?@"编辑材料":@"添加材料";
    }
    self.productM.categoryMap = nil;
    MyStepper *stepper = [[MyStepper alloc] initWithFrame:CGRectMake(100, 7, 120, 30)];
    [stepper setBorderColor:kColorMain];
    [stepper setTextColor:kColorMain];
    [stepper setButtonTextColor:kColorMain forState:UIControlStateNormal];
    self.numberStepper = stepper;
    
    self.imgDataArray = [NSMutableArray new];
    self.imgUrlArray = [NSMutableArray new];

    [self configSrcollView];
    [self configBottomView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _myScrollView.contentSize = CGSizeMake(kScreen_Width, self.contentViewHeight+50);
    if ([[UserManager readUserInfo].accType isEqualToString:@"1"]) {
        [NSObject showStr:@"该帐号不能发布设备和材料"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UI
-(UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _myScrollView.scrollEnabled = YES;
        _myScrollView.userInteractionEnabled = YES;
        _myScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
        _myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _myScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    }return _myScrollView;
}
-(void)configSrcollView{
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.myScrollView];
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (!self.headerView) {
        self.headerView = [self configHeaderView];
        [self.myScrollView addSubview:self.headerView];
    }
//    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    self.contentViewHeight = kScreen_Width/4;
    
    //灰色线条
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, 15)];
    self.contentViewHeight += 15;
    topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.myScrollView addSubview:topLineView];
    
    //for循环创建下方列表
    CGFloat lineNumber = 14;
    if (self.isEquipment) {
        lineNumber = 19;
    }
    for (int i = 0; i< lineNumber; i++) {
        //*产品类别
        if (i==0) {
            if (!self.view_i_0) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_0 = cell;
            }
            [self.view_i_0 setTitleStr:@"*产品类别" valueStr:[self.productM.categoryMap componentsJoinedByString:@"-"] placeHolder:@"必选"];
            self.view_i_0.tapAcitonBlock = ^{
                ZZTableViewController *vc = [[ZZTableViewController alloc]init];
                if (weakSelf.isEquipment) {
                    vc.isEquipment = YES;
                }else{
                    vc.isEquipment = NO;
                }
                vc.nameBlock = ^(NSString *firstName, NSString *secondName, NSString *thirdName) {
                    NSString *str = @"";
                    if ([NSObject isString:firstName]&&[NSObject isString:secondName]&&[NSObject isString:thirdName]) {
                        str = [NSString stringWithFormat:@"%@-%@-%@",firstName,secondName,thirdName];
                    }else if ([NSObject isString:firstName]&&[NSObject isString:secondName]){
                        str = [NSString stringWithFormat:@"%@-%@",firstName,secondName];
                    }else{
                        str = firstName;
                    }
                    [weakSelf.view_i_0 setTitleStr:@"*产品类别" valueStr:str placeHolder:@"必选"];
                };
                vc.idBlock = ^(NSString *firstId, NSString *secondId, NSString *thirdId) {
                    if ([NSObject isString:firstId]) {
                        weakSelf.productM.oneId = firstId;
                    }
                    if ([NSObject isString:secondId]) {
                        weakSelf.productM.twoId = secondId;
                    }
                    if ([NSObject isString:thirdId]) {
                        weakSelf.productM.threeId = thirdId;
                    }
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        //*产品名称
        else if (i== 1){
            if (!self.view_i_1) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_1 = cell;
            }
            [self.view_i_1 setTitleStr:@"*产品名称" valueStr:self.productM.name placeHolder:@"必填"];
            self.view_i_1.endEditBlock = ^(NSString *text) {
                weakSelf.productM.name = text;
            };
        }
        //*规格型号
        else if (i== 2){
            if (!self.view_i_2) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_2 = cell;
            }
            [self.view_i_2 setTitleStr:@"*规格型号" valueStr:self.productM.modelNo placeHolder:@"必填"];
            self.view_i_2.endEditBlock = ^(NSString *text) {
                weakSelf.productM.modelNo = text;
            };
        }
        //*图号
        else if (i== 3){
            if (!self.view_i_3) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_3 = cell;
            }
            [self.view_i_3 setTitleStr:@"*图号" valueStr:self.productM.figureNo placeHolder:@"必填"];
            self.view_i_3.endEditBlock = ^(NSString *text) {
                weakSelf.productM.figureNo = text;
            };
        }
        //*数量
        else if (i== 4){
            if (!self.view_i_4) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_4 = cell;
            }
            [self.view_i_4 setTitleStr:@"*数量" valueStr:self.productM.unit placeHolder:@"吨"];
            self.view_i_4.tapAcitonBlock = ^{
                NSArray *dataSources = @[@"吨", @"千克", @"公斤", @"斤", @"个", @"台", @"条", @"千米", @"米", @"厘米", @"毫米"];
                [BRStringPickerView showStringPickerWithTitle:@"数量" dataSource:dataSources defaultSelValue:@"吨" isAutoSelect:YES resultBlock:^(id selectValue) {
                    weakSelf.productM.unit = selectValue;
                    [weakSelf.view_i_4 setTitleStr:@"*数量" valueStr:weakSelf.productM.unit placeHolder:@"吨"];
                }];
            };
            
            if ([self.productM.num floatValue] == 0) {
                self.productM.num = @"1";
            }
            self.numberStepper.value = [self.productM.num floatValue];
                //        self.numberStepper.hidesDecrementWhenMinimum = YES;
                //        self.numberStepper.hidesIncrementWhenMaximum = YES;
            [self.view_i_4 addSubview:self.numberStepper];
            
            // plain
            self.numberStepper.valueChangedCallback = ^(MyStepper *stepper, float count) {
                NSLog(@"返回的数字%@",@(count));
                stepper.countTextField.text = weakSelf.productM.num = [NSString stringWithFormat:@"%.0f", count];
            };
            [self.numberStepper setup];
            
        }
        //*所在区域
        else if (i== 5){
            if (!self.view_i_5) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_5 = cell;
            }
            [self.view_i_5 setTitleStr:@"*所在区域" valueStr:self.productM.allAddress placeHolder:@"请选择地址"];
            self.view_i_5.tapAcitonBlock = ^{
                AddressManageerViewController *address = [[AddressManageerViewController alloc]init];
                address.blockAddress = ^(NSDictionary *newAddress){
                    NSLog(@"--地址和编码------%@",newAddress);
                    if (newAddress.count == 4) {
                        weakSelf.productM.allAddress  = [NSString stringWithFormat:@"%@,%@",newAddress[@"province"],newAddress[@"city"]];
                        weakSelf.productM.provinceId = [newAddress[@"firstAddress"] stringValue];
                        weakSelf.productM.cityId = [newAddress[@"secondAddress"] stringValue];
                        [weakSelf.view_i_5 setTitleStr:@"*所在区域" valueStr:weakSelf.productM.allAddress placeHolder:@"请选择地址"];

                    }
                    if (newAddress.count == 6){
                        weakSelf.productM.provinceId = [newAddress[@"firstAddress"] stringValue];
                        weakSelf.productM.cityId = [newAddress[@"secondAddress"] stringValue];
                        weakSelf.productM.countyId = [newAddress[@"thirdAddress"] stringValue];
                        weakSelf.productM.allAddress = [NSString stringWithFormat:@"%@,%@,%@",newAddress[@"province"],newAddress[@"city"],newAddress[@"area"]];
                        [weakSelf.view_i_5 setTitleStr:@"*所在区域" valueStr:weakSelf.productM.allAddress placeHolder:@"请选择地址"];
                    }
                    [TitleTextFieldTView refreshView];
                };
                [weakSelf.view endEditing:YES];
                [weakSelf.navigationController pushViewController:address animated:YES];
            };
        }
        //详细地址
        else if (i== 6){
            if (!self.view_i_6) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_6 = cell;
            }

            [self.view_i_6 setTitleStr:@"*详细地址" valueStr:self.productM.address placeHolder:@"必填"];
            self.view_i_6.endEditBlock = ^(NSString *text) {
                weakSelf.productM.address = text;

//                NSArray *dataSources = @[@"正常使用",@"故障",@"报废",@"其他"];
//                [BRStringPickerView showStringPickerWithTitle:@"当前状态" dataSource:dataSources defaultSelValue:@"正常使用" isAutoSelect:YES resultBlock:^(id selectValue) {
//                    if ([selectValue isEqualToString:@"正常使用"]) {
//                        weakSelf.addProductM.piDqzt = @"0";
//                    }else if ([selectValue isEqualToString:@"故障"]){
//                        weakSelf.addProductM.piDqzt = @"1";
//                    }else if ([selectValue isEqualToString:@"报废"]){
//                        weakSelf.addProductM.piDqzt = @"2";
//                    }else if ([selectValue isEqualToString:@"其他"]){
//                        weakSelf.addProductM.piDqzt = @"3";
//                    }
//                    [weakSelf.view_i_6 setTitleStr:@"当前状态" valueStr:selectValue placeHolder:@"请选择"];
//                }];
            };
        }
    //生产厂家
        else if (i== 7){
            if (!self.view_i_7) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_7 = cell;
            }
            [self.view_i_7 setTitleStr:@"生产厂家" valueStr:self.productM.manufacturer placeHolder:@"选填"];
            self.view_i_7.endEditBlock = ^(NSString *text) {
                weakSelf.productM.manufacturer = text;
            };
        }
    //供货厂家
        else if (i== 8){
            if (!self.view_i_8) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_8 = cell;
            }
            [self.view_i_8 setTitleStr:@"供货厂家 " valueStr:self.productM.supplier placeHolder:@"选填"];
            self.view_i_8.endEditBlock = ^(NSString *text) {
                weakSelf.productM.supplier = text;
            };
        }
        //材质
        else if (i== 9){
            if (!self.view_i_9) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_9 = cell;
            }
            [self.view_i_9 setTitleStr:@"材质" valueStr:self.productM.materialQuality placeHolder:@"选填"];
            self.view_i_9.endEditBlock = ^(NSString *text) {
                weakSelf.productM.materialQuality = text;
            };
        }
        //实重
        else if (i== 10){
            if (!self.view_i_10) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_10 = cell;
            }
            
            [self.view_i_10 setTitleStr:@"实重" valueStr:self.productM.nowWeight placeHolder:@"选填"];
            self.view_i_10.endEditBlock = ^(NSString *text) {
                weakSelf.productM.nowWeight = text;
            };
        }
        //品牌
        else if (i==11){
            if (!self.view_i_11) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_11 = cell;
            }
            [self.view_i_11 setTitleStr:@"品牌" valueStr:self.productM.brand placeHolder:@"选填"];
            self.view_i_11.endEditBlock = ^(NSString *text) {
                weakSelf.productM.brand = text;
            };
        }
        //出厂时间和有效期
        else if (i==12){
            if (!self.view_i_12) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_12 = cell;
            }
            NSString *titleStr = @"";
            NSString *valueStr = @"";
            
            if (self.isEquipment) {
                titleStr = @"出厂时间";
                valueStr = self.productM.useBeginTime;
                [self.view_i_12 setTitleStr:titleStr valueStr:valueStr placeHolder:@"请选择日期"];
                self.view_i_12.tapAcitonBlock = ^{
                    [BRDatePickerView showDatePickerWithTitle:titleStr dateType:UIDatePickerModeDate defaultSelValue:weakSelf.productM.useBeginTime minDateStr:nil maxDateStr:[NSObject currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                        weakSelf.productM.useBeginTime = selectValue;
                        [weakSelf.view_i_12 setTitleStr:titleStr valueStr:weakSelf.productM.useBeginTime placeHolder:@"请选择日期"];
                    }];
                };
            }else{
                titleStr = @"有效期";
                valueStr = self.productM.usefulDate;
                [self.view_i_12 setTitleStr:titleStr valueStr:valueStr placeHolder:@"请选择日期"];
                self.view_i_12.tapAcitonBlock = ^{
                    [BRDatePickerView showDatePickerWithTitle:titleStr dateType:UIDatePickerModeDate defaultSelValue:weakSelf.productM.usefulDate minDateStr:nil maxDateStr:[NSObject currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                        weakSelf.productM.usefulDate = selectValue;
                        [weakSelf.view_i_12 setTitleStr:titleStr valueStr:weakSelf.productM.usefulDate placeHolder:@"请选择日期"];
                    }];
                };
            }
            

        }
        //原值
        else if (i==13){
            if (!self.view_i_13) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                cell.myTtextField.keyboardType = UIKeyboardTypeNumberPad;
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_13 = cell;
            }
            NSString *titleStr = @"";
            NSString *valueStr = @"";
            if (self.isEquipment) {
                titleStr = @"*原值(元)";
                valueStr = @"必填";
            }else{
                titleStr = @"*原值(元)";
                valueStr = @"必填";
            }
            [self.view_i_13 setTitleStr:titleStr valueStr:[NSObject moneyStyle:self.productM.oldValue] placeHolder:valueStr];
            self.view_i_13.endEditBlock = ^(NSString *text) {
                weakSelf.productM.oldValue = text;
            };
        }
        //*原重
        else if (i==14){
            if (!self.view_i_14) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_14 = cell;
            }
            if (self.isEquipment) {
                [self.view_i_14 setTitleStr:@"*原重" valueStr:self.productM.oldWeight placeHolder:@"必填"];
                self.view_i_14.endEditBlock = ^(NSString *text) {
                    weakSelf.productM.oldWeight = text;
                };
            }
            else{
                if (!self.footerView) {
                    self.contentViewHeight += [TitleTextFieldTView cellHeight];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, 50)];
                    view.backgroundColor = [UIColor clearColor];
                    [self.myScrollView addSubview:view];
                    self.footerView = view;
                }
            }
        }
        //*新旧程度
        else if (i==15){
            if (!self.view_i_15) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_15 = cell;
            }
            if (self.isEquipment) {
                [self.view_i_15 setTitleStr:@"*新旧程度" valueStr:self.productM.oldDegree placeHolder:@"必填"];
                self.view_i_15.endEditBlock = ^(NSString *text) {
                    weakSelf.productM.oldDegree = text;
                };
            }
        }
        //*工作时长
        else if (i==16){
            if (!self.view_i_16) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                cell.myTtextField.keyboardType = UIKeyboardTypeNumberPad;

                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_16 = cell;
            }
            if (self.isEquipment) {
                [self.view_i_16 setTitleStr:@"*工作时长(月)" valueStr:self.productM.workLong placeHolder:@"必填"];
                self.view_i_16.endEditBlock = ^(NSString *text) {
                    weakSelf.productM.workLong = text;
                };
            }
        }
        //@"*闲置起始时间"
        else if (i==17){
            if (!self.view_i_17) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_17 = cell;
            }
            if (self.isEquipment) {
                [self.view_i_17 setTitleStr:@"*闲置起始时间" valueStr:self.productM.unuseBeginTime placeHolder:@"必选"];
                self.view_i_17.tapAcitonBlock = ^{
                    [BRDatePickerView showDatePickerWithTitle:@"*闲置起始时间" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.productM.unuseBeginTime minDateStr:nil maxDateStr:[NSObject currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                        weakSelf.productM.unuseBeginTime = selectValue;
                        [weakSelf.view_i_17 setTitleStr:@"*闲置起始时间" valueStr:weakSelf.productM.unuseBeginTime placeHolder:@"请选择日期"];
                    }];
                };
            }
        }
        //尺寸
        else if (i==18){
            if (!self.view_i_18) {
                TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
                self.contentViewHeight += [TitleTextFieldTView cellHeight];
                [self.myScrollView addSubview:cell];
                self.view_i_18 = cell;
            }
            if (self.isEquipment) {
                [self.view_i_18 setTitleStr:@"尺寸" valueStr:self.productM.size placeHolder:@"选填"];
                self.view_i_18.endEditBlock = ^(NSString *text) {
                    weakSelf.productM.size = text;
                };
            }
        }
    }
    if (!self.sepView) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, 10)];
        self.contentViewHeight += 10;
        sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.myScrollView addSubview:sepView];
        self.sepView = sepView;
    }
    
    if (!self.view_i_19) {
        TitleTextFieldTView *cell = [[TitleTextFieldTView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight, kScreen_Width, [TitleTextFieldTView cellHeight])];
        self.contentViewHeight += [TitleTextFieldTView cellHeight];
        [self.myScrollView addSubview:cell];
        self.view_i_19 = cell;
    }
    [self.view_i_19 setTitleStr:@"备注" valueStr:self.productM.remark placeHolder:@"选填"];
    self.view_i_19.endEditBlock = ^(NSString *text) {
        weakSelf.productM.remark = text;
    };
    if (!self.myTextView) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMyPadding, self.contentViewHeight, kScreen_Width - kMyPadding*2, 30)];
        titleLabel.text = @"资源描述:(选填)";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [self.myScrollView addSubview:titleLabel];
        self.contentViewHeight += 30;

        UITextView *cell = [[UITextView alloc] initWithFrame:CGRectMake(kMyPadding, self.contentViewHeight, kScreen_Width- kMyPadding*2, 200)];
        cell.delegate = self;
        self.contentViewHeight += 200;
        [self.myScrollView addSubview:cell];
        self.myTextView = cell;
    }
    self.myTextView.text = self.productM.desc;
    self.myScrollView.contentSize = CGSizeMake(kScreen_Width, 50 + self.contentViewHeight);
}



-(UIView *)configHeaderView{
    UIView *headerV = [UIView new];

    MyImgPickerView *pickerV = [MyImgPickerView ImgPickerViewWithFrame:CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, 0) CountOfRow:4];
    pickerV.isCustomCamera = YES;
    pickerV.type = MyImgType_PhotoAndCamera;
    pickerV.allowMultipleSelection = YES;
    pickerV.showAddButton = YES;
    pickerV.showDelete = YES;
    pickerV.maxImageSelected = 4;
    self.imgPickerView = pickerV;
    [self.myScrollView addSubview:pickerV];
    //拼接后的图片url数组
    NSMutableArray *completedImageUrlArray = [[NSMutableArray alloc]init];
    //拼接前的url数组
    NSArray *oriImgArr = [self.productM.pics componentsSeparatedByString:@","];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSString *str in oriImgArr) {
        if (!(str.length == 0)) {
            [imageArray addObject:str];
        }
    }
    //目前手机端只支持4张照片的编辑,但是pc端有的有5张照片,为了不大量修改代码,暂时选4张展示在手机端
    if (imageArray.count>0) {
        if (imageArray.count>4) {
            for (int i = 0; i<4; i++) {
                NSString *imageUrl = (NSString *)imageArray[i];
                NSString *completedUrl = [[YTKNetworkConfig sharedConfig].cdnUrl stringByAppendingString:imageUrl];
                [completedImageUrlArray addObject:completedUrl];
            }
        }else{
            for (NSString *imageUrl in imageArray) {
                NSString *completedUrl = [[YTKNetworkConfig sharedConfig].cdnUrl stringByAppendingString:imageUrl];
                [completedImageUrlArray addObject:completedUrl];
            }
        }
    }
    pickerV.preShowMedias =completedImageUrlArray;
    [pickerV observeSelectedMediaArray:^(NSArray<MyImgPickerModel *> *list) {
        for (MyImgPickerModel *model in list) {
            // 在这里取到模型的数据
            if (model.image) {
                [self.imgDataArray addObject:model.image];
            }else if (model.imageUrlString){
                [self.imgUrlArray addObject:model.imageUrlString];
            }
        }
//        self.addProductM.picUrls = list;
    }];
    // 如果在预览的基础上又要添加照片 则需要调用此方法 来动态变换高度
    [pickerV observeViewHeight:^(CGFloat height) {
        CGRect rect = headerV.frame;
        rect.size.height = CGRectGetMaxY(pickerV.frame);
        headerV.frame = rect;
    }];
//    self.pickerView = pickerV;
    [headerV addSubview:pickerV];
    headerV.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(pickerV.frame));
    return headerV;
}
-(void)configBottomView{
    //右上角按钮
    UIBarButtonItem *nextStepBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(actionSaveOrUpdate)];
    self.navigationItem.rightBarButtonItem = nextStepBtn;
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithStyle:StrapDefaultStyle andTitle:@"完成" andFrame:CGRectMake(16, 0, kScreen_Width-32, 44) target:self action:@selector(actionSaveOrUpdate)];
    [bottomView addSubview:button];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kViewAtBottomHeight));
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
}


#pragma mark - Action
-(void)actionSaveOrUpdate{
//    [NSObject showHUDQueryStr:@"正在上传..."];
    if (self.imgDataArray.count>0) {
        [self serveWithImgs:self.imgDataArray];
    }else{
        [self serveProduct:self.productM];
    }
}
-(void)serveWithImgs:(NSMutableArray *)imageDataArray{
    NSMutableArray *apiArr = [NSMutableArray array];
    NSMutableArray *imgNameArr = [NSMutableArray array];

    for (UIImage *img in imageDataArray) {
        [apiArr addObject:[[Api_UploadImage alloc] initWithImage:img]];
    }
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:apiArr];
    batchRequest.animatingText = @"正在上传图片...";
    batchRequest.animatingView = self.view;

    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
//        [NSObject hideHUDQuery];
        NSArray *requests = batchRequest.requestArray;
        for (int i = 0; i<apiArr.count; i++) {
            Api_UploadImage *a = (Api_UploadImage *)requests[i];
            

            NSLog(@"Api_UploadImage succeed");
            NSLog(@"Api_UploadImage succeed");
            NSLog(@"Api_UploadImage:requestArgument:%@",a.requestArgument);
            NSLog(@"Api_UploadImage:response:%@",a.response);
            NSLog(@"Api_UploadImage:responseString:%@",a.responseString);
            NSLog(@"Api_UploadImage:responseJSONObject:%@",a.responseJSONObject);
            if (!(a.responseImageId ==nil)) {
                [imgNameArr addObject:a.responseImageId];
            }
        }
        if (self.imgUrlArray.count>0) {
            for (NSString *imgUrl in self.imgUrlArray) {
                NSString *str = [imgUrl stringByReplacingOccurrencesOfString:[YTKNetworkConfig sharedConfig].cdnUrl withString:@""];
                [imgNameArr addObject:str];
            }
//            [imgNameArr addObjectsFromArray:self.imgUrlArray];
        }
        NSLog(@"保存图片名称的数组%@",imgNameArr);
        NSString *string = [imgNameArr componentsJoinedByString:@","];
        self.productM.pics = string;
        [self serveProduct:self.productM];
    } failure:^(YTKBatchRequest *batchRequest) {
//        [NSObject hideHUDQuery];
        NSLog(@"failed");
        NSArray *requests = batchRequest.requestArray;
        for (int i = 0; i<apiArr.count; i++) {
            Api_UploadImage *a = (Api_UploadImage *)requests[i];
            NSLog(@"requestArgument:%@",a.requestArgument);
            NSLog(@"responseHeaders:%@",a.responseHeaders);
            NSLog(@"response:%@",a.response);
            NSLog(@"responseData:%@",a.responseData);
            NSLog(@"responseString:%@",a.responseString);
            NSLog(@"responseJSONObject:%@",a.responseJSONObject);
            if (!(a.responseImageId ==nil)) {
                [imgNameArr addObject:a.responseImageId];
            }
        }
    }];
}
-(void)serveProduct:(ProductModel *)productM{
//    [NSObject showHUDQueryStr:@"正在上传..."];
    if (productM.unuseBeginTime.length>10) {
        productM.unuseBeginTime = [productM.unuseBeginTime substringToIndex:10];
    }
    if (productM.useBeginTime.length>10) {
        productM.useBeginTime = [productM.useBeginTime substringToIndex:10];
    }
//    if (self.isEdit) {
//        NSArray *arr = [self.productM.category.pids componentsSeparatedByString:@","];
//        if (arr.count ==3) {
//            productM.oneId = [arr objectAtIndex:0];
//            productM.twoId = [arr objectAtIndex:1];
//            productM.threeId = [arr objectAtIndex:2];
//        }
//        if (arr.count == 2) {
//            productM.oneId = [arr objectAtIndex:0];
//            productM.twoId = [arr objectAtIndex:1];
//        }
//        if (arr.count == 1) {
//            productM.oneId = [arr objectAtIndex:0];
//        }
//    }
    NSLog(@"%@",productM);
    if ([self.productM.pics componentsSeparatedByString:@","].count == 0) {
        [NSObject ToastShowStr:@"请至少选择一张图片"];
        return;
    }
    if (![NSObject isString:self.productM.oneId]) {
        [NSObject ToastShowStr:@"选择类别"];
        return;
    }
    Api_SaveOrUpdate *apiSaveOrUpdate = [[Api_SaveOrUpdate alloc] initWithProductModel:self.productM];
    apiSaveOrUpdate.animatingText = @"正在上传数据...";
    apiSaveOrUpdate.animatingView = self.view;

    [apiSaveOrUpdate startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject[@"code"] integerValue] == 0) {
//            [NSObject hideHUDQuery];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([request.responseJSONObject[@"code"] integerValue] == 500){
            NSString *str = request.responseJSONObject[@"msg"];
            [NSObject ToastShowStr:str];
        }
        NSLog(@"apiSaveOrUpdate succeed");
        NSLog(@"apiSaveOrUpdate succeed");
        NSLog(@"apiSaveOrUpdate:requestArgument:%@",request.requestArgument);
        NSLog(@"apiSaveOrUpdate:response:%@",request.response);
        NSLog(@"apiSaveOrUpdate:responseString:%@",request.responseString);
        NSLog(@"apiSaveOrUpdate:responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        
//        [NSObject hideHUDQuery];
        NSLog(@"apiSaveOrUpdate failed");
        NSLog(@"apiSaveOrUpdate failed");
        NSLog(@"apiSaveOrUpdate:requestArgument:%@",request.requestArgument);
        NSLog(@"apiSaveOrUpdate:response:%@",request.response);
        NSLog(@"apiSaveOrUpdate:responseString:%@",request.responseString);
        NSLog(@"apiSaveOrUpdate:responseJSONObject:%@",request.responseJSONObject);
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}

-(void)serveProductCategory{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"40288098472849cf0147284ed08e0002" forKey:@"proCategoryId"];
    [dict setObject:@"0" forKey:@"status"];
    
//    __weak typeof(self)weakSelf = self;
//    [[AFHTTPSessionManager manager] POST:[requestUrlHeader stringByAppendingString:@"xy/category/get.json"] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"----1-----%@",responseObject);
//        self.productCategoryM = [[ProductCategoryModel alloc] initWithDictionary:responseObject[@"object"][0] error:nil];
//        [NSObject archiverWithSomeThing:responseObject[@"object"][0] someName:kProductCategoryCacheAll];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
    Api_GetAllCategoryData *getAllCategoryDataApi = [[Api_GetAllCategoryData alloc] init];
    [getAllCategoryDataApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"getAllCategoryDataApi succeed");
        NSLog(@"getAllCategoryDataApi succeed");
        
//        NSLog(@"requestArgument:%@",request.requestArgument);
//        NSLog(@"responseHeaders:%@",request.responseHeaders);
//        NSLog(@"response:%@",request.response);
//        NSLog(@"responseData:%@",request.responseData);
//        NSLog(@"responseString:%@",request.responseString);
        NSLog(@"responseJSONObject:%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"getAllCategoryDataApi failed");
        if ([request.response.URL.path containsString:@"/login.jsp"]) {
            //            [BaseViewController goToLoginVC];
            [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:^{
                [BaseViewController configLogOutStatus];
            }];
        }
    }];
}

-(BOOL)configAlertMessage{
    if (![NSObject isString:self.productM.name]) {
        [NSObject ToastShowStr:@"请填写产品名称"];
        return NO;
    }
    if (![NSObject isString:self.productM.oneId]) {
        [NSObject ToastShowStr:@"请选择产品类别"];
        return NO;
    }
    if (![NSObject isString:self.productM.figureNo]) {
        [NSObject ToastShowStr:@"请填写图号"];
        return NO;
    }
    if (![NSObject isString:self.productM.modelNo]) {
        [NSObject ToastShowStr:@"请填写规格型号"];
        return NO;
    }
    if (![NSObject isString:self.productM.unit]) {
        [NSObject ToastShowStr:@"请选择产品单位"];
        return NO;
    }
    if (![NSObject isString:self.productM.num]) {
        [NSObject ToastShowStr:@"请填写产品数量"];
        return NO;
    }
    if (![NSObject isString:self.productM.provinceId]) {
        [NSObject ToastShowStr:@"请填写所在区域"];
        return NO;
    }
    if (![NSObject isString:self.productM.allAddress]) {
        [NSObject ToastShowStr:@"请填写详细地址"];
        return NO;
    }
    if (![NSObject isString:self.productM.oldValue]) {
        [NSObject ToastShowStr:@"请填写原值"];
        return NO;
    }
    if (self.isEquipment) {
        if (![NSObject isString:self.productM.oldWeight]) {
            [NSObject ToastShowStr:@"请填写原重"];
            return NO;
        }
        if (![NSObject isString:self.productM.oldDegree]) {
            [NSObject ToastShowStr:@"请填写新旧程度"];
            return NO;
        }
        if (![NSObject isString:self.productM.workLong]) {
            [NSObject ToastShowStr:@"请填写工作时长"];
            return NO;
        }
        if (![NSObject isString:self.productM.unuseBeginTime]) {
            [NSObject ToastShowStr:@"请选择闲置起始时间"];
            return NO;
        }
    }
    return YES;
}




#pragma mark DelegateUITerxtView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
//    else if(range.location >= 500)      //如果输入超过规定的字数20，就不再让输入
//    {
//        return  NO;
//    }
    self.productM.desc = self.myTextView.text;
    NSLog(@"输入的商品描述：%@",self.productM.desc);
    return YES;
}
@end
