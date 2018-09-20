//
//  AddProductModel.h
//  XYGPWuZi
//
//  Created by Lzy on 2018/1/12.
//  Copyright © 2018年 xiaoRan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//#import "ProductCategoryModel.h"

@interface AddProductModel: JSONModel
//addProductM.
@property (nonatomic,copy)NSString <Optional> *token/*登录令牌*/,
*piPics/*图片集合（1.jpg,2.jpg,3.jpg...）*/,
*piName/*品名*/,
//*category_proCategoryId/*category.proCategoryId：对应类别I*/,
*piNumber/*数量*/,
*piUnit/*单位*/,
*piCpxh/*产品型号*/,
*piCpcd/*品牌*/,
*piXjcd/*新旧程度*/,
*piDqzt/*当前状态(0,正常使用，1故障，2报废，3其它)*/,
*piGzxs/*工作小时*/,
*piScDate/*生产日期*/,
*piMinPrice/*最低出售底价*/,

//*piCateFirst_proCategoryId/*一级类别ID*/,
//*piCateSecond_proCategoryId/*二级类别ID*/,
//*piCateThird_proCategoryId/*三级类别ID*/,

*piId/*主键ID（此参数修改需要，添加不需要）*/,
*piWarehouse/*仓库*/,
*piJjfs/*计价方式*/,

*piCch/*仓储号*/,
*piGlh/*管理号*/,
*piKbh/*捆包号*/,
*piZyh/*资源号*/,
*piRkDate/*入库日期*/,
*piCcgg/*尺寸规格*/,
*piYyhgz/*有无合格证（0、无 1、有）*/,
*piCczl/*产品重量*/,
*piYwdx/*有无大修（0、无 1、有）*/,
*piZyms/*资源描述 */,
*piKeyword/*关键字*/,
*piMark/*备注*/,
*piNewPrice/*产品原价*/,

*piProvince/*省*/,//id
*piCity/*市*/,//id
*piCounty/*县*/,//id
*piAddress/*详细地址*/,//省市县乡名字
*gpsAddress/*产品自动坐标值*/;

//token：登录令牌 | piPics：图片集合（1.jpg,2.jpg,3.jpg...）| piId：主键ID（此参数修改需要，添加不需要） | category.proCategoryId：对应类别ID | piName：品名 | piMinPrice：最低出售底价 | piNumber：数量 | piUnit：单位 | piWarehouse：仓库 | piCch：仓储号 | piGlh：管理号 | piKbh：捆包号 | piZyh：资源号 | piScDate：生产日期 | piRkDate：入库日期 | piXjcd：新旧程度 | piDqzt：当前状态(0,正常使用，1故障，2报废，3其它) | piCpxh：产品型号 | piCpcd：品牌 | piCcgg：尺寸规格 | piYyhgz：有无合格证（0、无 1、有）| piCczl：产品重量 | piGzxs：工作小时 | piYwdx：有无大修（0、无 1、有）| piJjfs：计价方式 | piZyms：资源描述 | piKeyword：关键字 | piMark：备注 | piNewPrice：产品原价 | piProvince：省 | piCity：市 | piCounty：县 | piAddress：详细地址 | piCateFirst.proCategoryId：一级类别ID | piCateSecond.proCategoryId：二级类别ID | piCateThird.proCategoryId ：三级类别ID | gpsAddress ：产品自动坐标值



@property (nonatomic,copy)NSString <Optional>
*cateFirst,
*cateFirstId,
*cateSecond,
*cateSecondId,
*cateThird,
*cateThirdId,
*piModtime
;
@property(strong, nonatomic)NSArray <Optional>*picUrls;
//@property(strong, nonatomic)ProductCategoryModel* listCategory;
//@property(strong, nonatomic)NSArray<ProductCategoryModel>* listCategory;
@end
