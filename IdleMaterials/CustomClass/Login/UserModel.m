//
//  UserModel.m
//  Taoyi
//
//  Created by Lzy on 2018/2/5.
//  Copyright © 2018年 Lzy. All rights reserved.
//

#import "UserModel.h"

#import "NSObject+Property.h"
@implementation UserModel

-(NSString<Optional> *)loginMobile{
    if (!_loginMobile) {
        _loginMobile = @"请登录";
    }return _loginMobile;
}
-(NSString<Optional> *)fullName{
    if (!_fullName) {
        _fullName = @"请登录";
    } return _fullName;
}
-(NSString<Optional> *)companyName{
    if (!_companyName) {
        _companyName = @"请登录";
    }return _companyName;
}
-(NSString<Optional> *)deptName{
    if (!_deptName) {
        _deptName = @"请登录";
    }return _deptName;
}
-(NSString<Optional> *)positionName{
    if (!_positionName) {
        _positionName = @"暂无";
    }return _positionName;
}


//归档（序列化）
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self enumerateProperties:^(id key) {
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }];
}
//解归档（反序列化）
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        __weak typeof(self) weakSelf = self;
        [self enumerateProperties:^(id key) {
            id value = [aDecoder decodeObjectForKey:key];
            [weakSelf setValue:value forKey:key];
        }];
    }
    return self;
}
@end


#define KUserArchivePathKey @"userInfo.archive"
#define KEY @"userInfo"
@implementation UserManager
#pragma mark 保存用户信息
+ (void)saveUserInfo:(UserModel *)model {
    BOOL success = [ArchiveTool archiveModel:model toPath:[ArchiveTool pathWithKey:KUserArchivePathKey] withKey:KEY];
    if (!success) {
        NSLog(@"存储用户信息失败");
    }
}
#pragma mark 取出用户信息
+ (UserModel *)readUserInfo {
    UserModel *model = [ArchiveTool unarchiveFromPath:[ArchiveTool pathWithKey:KUserArchivePathKey] withKey:KEY];
    if (!model) {
        model = [[UserModel alloc] init];
    }
    return model;
}
+ (void) clearUserInfo {
    UserModel *model = [[UserModel alloc] init];
    [self saveUserInfo:model];
}
@end




@implementation ArchiveTool
+ (BOOL)archiveModel:(id)aModel toPath:(NSString *)path withKey:(NSString *)archivingDataKey{
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // archivingDate的encodeWithCoder方法被调用
    [archiver encodeObject:aModel forKey:archivingDataKey];
    [archiver finishEncoding];
    //写入文件
    return [data writeToFile:path atomically:YES];
}
+ (id)unarchiveFromPath:(NSString *)path withKey:(NSString *)archivingDataKey{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //获得类
    //initWithCoder方法被调用
    id archivingData = [unarchiver decodeObjectForKey:archivingDataKey];
    [unarchiver finishDecoding];
    return archivingData;
}
+ (NSString *)pathWithKey:(NSString *)pathKey{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:pathKey];
    //NSLog(@"%@",filePath);
    return filePath;
}
@end
