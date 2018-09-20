//
//  ProductModel.h
//  LzyTool
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "JSONModel.h"
#import "CompanyInfoModel.h"
#import "CategoryModel.h"

@interface ProductModel : JSONModel

@property (nonatomic,copy)NSString <Optional> *pdId/*产品ID*/,

*xzName,


*cpId/*公司主键*/,
*name/*产品名称*/,
*modelNo/*规格型号*/,
*size/*尺寸*/,
*materialQuality/*材质*/,
*oldWeight/*原重*/,
*nowWeight/*实重*/,
*allAddress/*所在区域*/,
*address/*详细地址*/,
*provinceId/*省份编码*/,
*cityId/*市编码*/,
*countyId/*县区编码*/,
*num/*数量*/,
*unit/*数量单位*/,

*brand/*品牌*/,
*manufacturer/*生产厂家*/,
*supplier/*供货厂家*/,
*oldDegree/*新旧程度*/,
*workLong/*工作时长*/,
*unuseBeginTime/*闲置起始时间(yyyy-MM-dd)*/,
*useBeginTime/*出厂时间(yyyy-MM-dd)*/,
*oldValue/*原值*/,
*remark/*备注*/,
*desc/*资源描述*/,
*cateType/*类别(1.设备2材料)*/,
*categoryId/*产品分类ID*/,
*oneId/*产品分类ID*/,
*twoId/*产品分类ID*/,
*threeId/*产品分类ID*/,

*usefulDate/*有效期(yyyy-MM-dd)*/,

*upDownStatus/*上下架状态(1上架0下架)*/,
*delFlag/*删除标识（0未删除1已删除）*/,
*creTime/*录入时间(yyyy-MM-dd)*/,
*modTime/*更新时间(yyyy-MM-dd)*/,
*creUser/*录入人*/,
*modUser/*更新人*/,
*xzPiId/*闲置产品id*/,
*pics/*图片组用逗号分割*/,
*code/*产品编号纯数字自增，数据库生成*/,
*figureNo/*图号*/;
@property(strong, nonatomic)NSArray <Optional>*categoryMap;
@property(strong, nonatomic)CompanyInfoModel<Optional>* companyInfo;
@property(strong, nonatomic)CategoryModel<Optional>* category;




@end
