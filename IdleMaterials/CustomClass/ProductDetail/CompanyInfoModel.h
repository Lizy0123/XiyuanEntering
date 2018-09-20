//
//  CompanyInfoModel.h
//  LzyTool
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 熙元科技有限公司. All rights reserved.
//

#import "JSONModel.h"

@interface CompanyInfoModel : JSONModel
@property (nonatomic,copy)NSString <Optional> *address/*产品ID*/,
//*creTime/*公司主键*/,
//*modUserName/*产品名称*/,
//*xzLoginName/*规格型号*/,
//*headPic/*尺寸*/,
//*adminMobile/*材质*/,
//*companyAddress/*原重*/,
//*modTime/*实重*/,
//*adminName/*所在区域*/,
//*delFlag/*详细地址*/,
//*salt/*省份编码*/,
//*countyId/*市编码*/,
//*openAccFlag/*县区编码*/,
//*cityId/*数量*/,
//*provinceId/*数量单位*/,
//*linkmanNumbers/*数量单位*/,
//*map/*数量单位*/,
//*xzPassword/*数量单位*/,
*companyName/*数量单位*/
//*cpId/*数量单位*/,
//*accType/*数量单位*/,
//*loginName/*数量单位*/,
//*pCpId/*数量单位*/,
//*password/*数量单位*/,
//*facUserid/*数量单位*/,
//*xzToken/*数量单位*/
;


@end
