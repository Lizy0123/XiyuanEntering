//
//  NSString+Common.h
//  YLuxury
//
//  Created by Lzy on 2017/5/10.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
+ (NSString *)userAgentStr;
- (NSString *)URLEncoding;
- (NSString *)URLDecoding;
- (NSString *)md5Str;
- (NSString *)md5Encrypt;
- (NSString *)sha1Str;
+ (id)stringWithDate:(NSDate*)date format:(NSString *)format;
+ (NSString *)handelRef:(NSString *)ref path:(NSString *)path;
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
-(BOOL)containsEmoji;
+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte;





- (NSString *)stringByRemoveSpecailCharacters;
- (NSString *)trimWhitespace;
- (BOOL)isEmpty;
- (BOOL)isEmptyOrListening;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo;
- (BOOL)isEmail;
- (BOOL)isGK;

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

//转换拼音
- (NSString *)transformToPinyin;

//是否包含语音解析的图标
- (BOOL)hasListenChar;



+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (NSString *)formatTimeBySecond:(NSInteger)second;

+(BOOL)isString:(id)str;
- (NSInteger)versionNumberValue;

- (NSString *)md5Encode;
- (NSString *)md516Encode;
+ (NSString*)stringWithDateIntervalFromBase:(unsigned long long)interval;
+ (NSString*)stringWithDateInterval:(unsigned long long)interval;
+ (NSString*)stringWithFileSize:(unsigned long long)size;

- (BOOL)containChineseWord;

- (BOOL)containCapitalWord;

- (BOOL)containNumeralWord;

- (BOOL)containBlankSpace;

- (BOOL)includeString:(NSString *)string;

//如果只输入www.baidu.com，该方法也会认为不合法。
//如果确认url的协议，则使用此方法。
- (BOOL)isLegalURL;

// 从一片内存数据中得到一个十六进制字符串
+ (NSString*)hexStringFromBytes:(const void*)data withLength:(NSUInteger)length;
- (NSData*)hexStringToDataBytes;




//清除非法字符串
- (NSString *)clearIllegalCharacter;

- (NSString*) base64Encode;
- (NSString *) base64Decode;

// 这个才是base64的正确使用方式  同时在NSData的扩展里头有encode方法

- (NSData*)base64Decode2;


- (NSString *)encodeString;
- (NSString *)decodeString;

// 确保上报的字段合法（中文字符加%Encode，字段长度255截取）
- (NSString *)legalReportFieldString;

// 从字符串中计算出urlhash
- (int64_t)urlHashFromString;

// 获取系统时间戳
+ (NSString *)timeStampAtNow;

//去掉前后空格和换行符
- (NSString *)trim;





/**
 随机字符串
 
 @return 随机字符串
 */
+(instancetype)randomStr;
/**
 适合的高度-通过宽度和字体
 
 @param font 字体
 @param width 宽度
 @return 适合的高度，默认 systemFontOfSize:font
 */
-(CGFloat)heightWithFont:(NSInteger)font width:(CGFloat)width;
/**
 适合的宽度- 通过高度和字体
 
 @param font 字体
 @param height 高度
 @return 适合的宽度 默认 systemFontOfSize:font
 */
-(CGFloat)widthWithFont:(NSInteger)font height:(CGFloat)height;

@end
