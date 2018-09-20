//
//  UserModel.h
//  Taoyi
//
//  Created by Lzy on 2018/2/5.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel
//Detail
@property(copy, nonatomic)NSString<Optional> *loginMobile;//登录手机
@property(copy, nonatomic)NSString<Optional> *fullName;//登录人
@property(copy, nonatomic)NSString<Optional> *deptName;//部门
@property(copy, nonatomic)NSString<Optional> *positionName;//职位
@property(copy, nonatomic)NSString<Optional> *headPic;//头像
@property(copy, nonatomic)NSString<Optional> *companyName;//公司名
@property(copy, nonatomic)NSString<Optional> *cpId;
@property(copy, nonatomic)NSString<Optional> *accType;

//@property(strong, nonatomic)NSNumber<Optional> *companyName;//

//SessionID
@property(copy, nonatomic)NSString<Optional> *sessionId;//sessionid.Detail并没有，只是本地使用

@end



@interface UserManager : NSObject
+(void)saveUserInfo:(UserModel *)model;
+(UserModel *)readUserInfo;
+(void)clearUserInfo;
@end



@interface ArchiveTool : NSObject
//归档
+ (BOOL)archiveModel:(id)aModel toPath:(NSString *)path withKey:(NSString *)archivingDataKey;
//从指定位置解档
+ (id)unarchiveFromPath:(NSString *)path withKey:(NSString *)archivingDataKey;
//根据key获得存储地址
+ (NSString *)pathWithKey:(NSString *)pathKey;
@end

