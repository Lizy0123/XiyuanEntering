//
//  NSString+Common.m
//  YLuxury
//
//  Created by Lzy on 2017/5/10.
//  Copyright © 2017年 YLuxury. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"


@implementation NSString (Common)
+ (NSString *)userAgentStr{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
}

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}
- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSString *)md5Encrypt
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString*) sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (id)stringWithDate:(NSDate*)date format:(NSString *)format {
    assert(format != nil);
    if (date == nil)
        return nil;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString* result = [[NSString alloc] initWithFormat:@"%@", [df stringFromDate:date]];
    return result;
}






















+ (NSString *)handelRef:(NSString *)ref path:(NSString *)path{
    if (ref.length <= 0 && path.length <= 0) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString new];
    if (ref.length > 0) {
        [result appendString:ref];
    }
    if (path.length > 0) {
        [result appendFormat:@"%@%@", ref.length > 0? @"/": @"", path];
    }
    return [result URLEncoding];
}
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
//    [style setLineSpacing:3];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

-(BOOL)containsEmoji{
    if (!self || self.length <= 0) {
        return NO;
    }
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte{
    NSString *sizeDisplayStr;
    if (sizeOfByte < 1024) {
        sizeDisplayStr = [NSString stringWithFormat:@"%.2f bytes", sizeOfByte];
    }else{
        CGFloat sizeOfKB = sizeOfByte/1024;
        if (sizeOfKB < 1024) {
            sizeDisplayStr = [NSString stringWithFormat:@"%.2f KB", sizeOfKB];
        }else{
            CGFloat sizeOfM = sizeOfKB/1024;
            if (sizeOfM < 1024) {
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f M", sizeOfM];
            }else{
                CGFloat sizeOfG = sizeOfKB/1024;
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f G", sizeOfG];
            }
        }
    }
    return sizeDisplayStr;
}

- (NSString *)stringByRemoveSpecailCharacters{
    static NSCharacterSet *specailCharacterSet;
    if (!specailCharacterSet) {
        NSMutableString *specailCharacters = @"\u2028\u2029".mutableCopy;
        specailCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specailCharacters];
    }
    return [[self componentsSeparatedByCharactersInSet:specailCharacterSet] componentsJoinedByString:@""];
}

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

- (BOOL)isEmptyOrListening{
    return [self isEmpty] || [self hasListenChar];
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo{
    //    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSString *phoneRegex = @"[0-9]{1,15}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isGK{
    NSString *gkRegex = @"[A-Z0-9a-z-_]{3,32}";
    NSPredicate *gkTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gkRegex];
    return [gkTest evaluateWithObject:self];
}


- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (location = 0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingLeftCharactersInSet:characterSet]];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingRightCharactersInSet:characterSet]];
}

//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSString *tempString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempString uppercaseString];
}

//是否包含语音解析的图标
- (BOOL)hasListenChar{
    BOOL hasListenChar = NO;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (charBuffer[length -1] == 65532) {//'\U0000fffc'
            hasListenChar = YES;
            break;
        }
    }
    return hasListenChar;
}


+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isString:(id)str{
    if (!str) {
        return NO;
    }
    if ((NSNull *)str == [NSNull null]) {
        return NO;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([str isEqualToString:@""]) {
        return NO;
    }
    if (((NSString *)str).length == 0) {
        return NO;
    }
    if ([str isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([str isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

// 将秒数时间转为00:00:00的形式
+ (NSString *)formatTimeBySecond:(NSInteger)second
{
    int diff = second;
    
    int iHour = diff / (60.0f * 60.0f);;
    
    diff = diff % (60 * 60);
    
    int iMinute = diff / 60.0f;
    
    int iSecond = diff % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", iHour, iMinute, iSecond];
}



- (NSInteger)versionNumberValue
{
    const char * ver_str = [self UTF8String];
    const char* flag = ver_str;
    
    int result = 0;
    int i = 4;
    int tem = 0;
    
    while (i--) {
        tem = atoi(flag);
        result = result | tem;
        if (i == 0) {
            break;
        }
        result = result<<8;
        do {
            flag++;
        } while (tem /= 10);
        flag++;
    }
    return result;
}

- (NSString *)md5Encode
{
    
    NSString *toEncode = self;
    const char *cStr = [toEncode UTF8String];
    unsigned char result[16] = {0};
    
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            
            ];
}
- (NSString *)md516Encode
{
    
    NSString *toEncode = self;
    const char *cStr = [toEncode UTF8String];
    unsigned char result[16] = {0};
    
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11]];
}

+ (NSString*)stringWithDateIntervalFromBase:(unsigned long long)interval//单位是秒
{
    unsigned long long time = [[NSDate date]timeIntervalSince1970]-interval;
    if (time == 0)
    {
        return @"";
    }
    if(time<60)//不足一分钟
    {
        return [NSString stringWithFormat:@"%zd秒", time];
    }
    if (time < 60*60)//不足一个小时
    {
        return [NSString stringWithFormat:@"%zd分", time/60];
    }
    else if(time < 24*60*60)//不足一天
    {
        NSInteger hours = (int)time/3600;
        return [NSString stringWithFormat:@"%zd小时", hours];
    }
    else if(time <30*24*60*60)//超过一天,不足一个月
    {
        NSInteger days = (int)time/86400;
        return [NSString stringWithFormat:@"%zd天", days];
    }
    else if(time<365*30*24*60*60)//超过一个月，不足一年
    {
        NSInteger months = (int)time/(24*30*3600);
        return [NSString stringWithFormat:@"%zd月", months];
    }
    else //超过一年。
    {
        NSInteger years = (int)time/(365*24*30*3600);
        return [NSString stringWithFormat:@"%zd年", years];
    }
}

+ (NSString*)stringWithDateInterval:(unsigned long long)interval//单位是秒
{
    if (interval/60 < 60)//不足一个小时,60分钟以内
    {
        return [NSString stringWithFormat:@"%zd分", interval/60];
    }
    else if(interval/3600 < 24)//不足一天
    {
        NSInteger hours = (int)interval/3600;
        NSInteger minutes = (interval %3600)/60;
        if (minutes <1)
        {
            minutes = 1;
        }
        return [NSString stringWithFormat:@"%zd小时%zd分", hours,minutes];
    }
    else //超过一天
    {
        NSInteger days = (int)interval/86400;
        NSInteger hours = (interval %86400)/3600;
        if (hours <1)
        {
            hours = 1;
        }
        return [NSString stringWithFormat:@"%zd天%zd小时", days,hours];
    }
}
+ (NSString*)stringWithFileSize:(unsigned long long)size
{
    if (size == 0)
    {
        return @"无缓存";
    }
    else if (size < 1000)
    {
        return [NSString stringWithFormat:@"%lluB", size];
    }
    else if(size < 1024 * 1024)
    {
        return [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    }
    else if(size < 1024 * 1024 * 1024)
    {
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024)];
    }
    else if(size < 1024 * 1024 * 1024 * 1024ull)
    {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024 * 1024)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2fTB", size / (1024.0 * 1024 * 1024 * 1024)];
    }
    
}

- (BOOL)containChineseWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar > 0xE0)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containNumeralWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar >= '0' && indexChar <= '9')
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containCapitalWord
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar >= 'A' && indexChar <= 'Z')
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)includeString:(NSString *)string
{
    
    NSRange range = [self rangeOfString:string];
    if (range.location!=NSNotFound)
    {
        return YES;
    }else{
        
        return NO;
    }
}

- (BOOL)containBlankSpace
{
    for (NSInteger index = 0; index < self.length; index++)
    {
        unichar indexChar = [self characterAtIndex:index];
        if (indexChar == ' ')
        {
            return YES;
        }
    }
    return NO;
    
}



//如果只输入www.baidu.com，该方法也会认为不合法。
//如果确认url的协议，则使用此方法。
- (BOOL)isLegalURL
{
    NSURL *candidateURL = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // WARNING > "test" is an URL according to RFCs, being just a path
    
    NSLog(@"URL string : %@, scheme : %@, host : %@", self, candidateURL.scheme, candidateURL.host);
    
    // RFC定义的合法URL
    BOOL legalInRFC = candidateURL && candidateURL.scheme && candidateURL.host;
    
    // 额外条件
    if (legalInRFC && [self rangeOfString:@"."].length > 0) {
        return YES;
    }
    
    return NO;
}

// 从一片内存数据中得到一个十六进制字符串
+ (NSString*)hexStringFromBytes:(const void*)data withLength:(NSUInteger)length
{
    // 查表
    const unsigned char t[16] = "0123456789ABCDEF";
    unsigned char* dataChar = (unsigned char*)data;
    // 多一位用来存放0
    NSUInteger dstLen = 2*length + 1;
    unsigned char* dstString = (unsigned char*)malloc(dstLen);
    memset(dstString, 0, dstLen);
    int j = 0;
    for (int i = 0; i < length; i++)
    {
        dstString[j++] = t[dataChar[i]>>4];
        dstString[j++] = t[dataChar[i]&0x0F];
    }
    dstString[j] = '\0';
    NSString* strRtn =[ NSString stringWithUTF8String:(const char*)dstString];
    if (dstString)
    {
        free(dstString);
        dstString = NULL;
    }
    return strRtn;
}

- (NSData*)hexStringToDataBytes
{
    NSMutableData* data = [NSMutableData data];
    int idx = 0;
    for (idx = 0; idx < self.length; idx+=2)
    {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}



//清除非法字符串
- (NSString *)clearIllegalCharacter
{
    if (self == nil) {
        return nil;
    }
    
    NSString *resultString = self;
    
    resultString = [resultString stringByReplacingOccurrencesOfString:@"<" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@">" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"/" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\\" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"|" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@":" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\"" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"*" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"?" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\t" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\r" withString:@"□"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\n" withString:@"□"];
    
    return resultString;
}

- (NSString*) base64Encode
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    
    int length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    if (lentext < 1)
        return @"";
    
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [[self dataUsingEncoding:NSUTF8StringEncoding]bytes];
    
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        ixtext += 3;
        charsonline += 4;
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (NSString *) base64Decode
{
    
    return [[NSString alloc]initWithData:[self base64Decode2] encoding:NSUTF8StringEncoding];
}
- (NSData*)base64Decode2
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (self == nil) {
        return nil;
    }
    
    ixtext = 0;
    tempcstring = (const unsigned char *)[self UTF8String];
    lentext = [self length];
    theData = [NSMutableData dataWithCapacity: lentext];
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        ch = tempcstring [ixtext++];
        flignore = false;
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                ixinbuf = 3;
                flbreak = true;
            }
            inbuf [ixinbuf++] = ch;
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}




- (NSString *) encodeString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,NULL, CFSTR("\\!*';:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

-(NSString*) decodeString {
    NSString* decodeString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (decodeString == nil)
    {
        decodeString = @"";
    }
    return decodeString;
}


// 确保上报的字段合法（中文字符加%Encode，字段长度255截取）
- (NSString *)legalReportFieldString
{
    if (self == nil) {
        return nil;
    }
    
    NSString *resultString = self;
    
    resultString = [[self decodeString]encodeString];
    if ( nil == resultString) {
        resultString = self;
    }
    
    
    if ([resultString lengthOfBytesUsingEncoding:NSUTF8StringEncoding] >= 255) {
        resultString = [resultString substringToIndex:254];
    }
    
    return resultString;
}

// 从字符串中计算出urlhash
- (int64_t)urlHashFromString
{
    NSString* strNoPercentUrl = [self decodeString];
    return mmhash_64([strNoPercentUrl UTF8String], [strNoPercentUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
}
#define FNV_32_PRIME 0x01000193ULL
uint64_t mmhash_64(const void *key, size_t len) {
    const uint64_t m = 0xc6a4a7935bd1e995ULL;
    const uint64_t r = 47;
    uint64_t h = FNV_32_PRIME ^ (len * m);
    
    
    const uint64_t * tmp_data = malloc(len);
    memset((void*)tmp_data, 0, len);
    memcpy((void*)tmp_data, key, len);
    
    const uint64_t * data = (const uint64_t *)tmp_data;
    const uint64_t * end = data + (len/sizeof(uint64_t));
    
    
    uint64_t k ;
    while (data != end) {
        
        k = *data++;
        
        k *= m;
        k ^= k >> r;
        k *= m;
        h ^= k;
        h *= m;
    };
    
    const unsigned char * data2 = (const unsigned char*)data;
    switch (len & 7) {
        case 7: h ^= (uint64_t)(data2[6]) << 48;
        case 6: h ^= (uint64_t)(data2[5]) << 40;
        case 5: h ^= (uint64_t)(data2[4]) << 32;
        case 4: h ^= (uint64_t)(data2[3]) << 24;
        case 3: h ^= (uint64_t)(data2[2]) << 16;
        case 2: h ^= (uint64_t)(data2[1]) << 8;
        case 1: h ^= (uint64_t)(data2[0]);
            h *= m;
    }
    h ^= h >> r;
    h *= m;
    h ^= h >> r;
    
    free((void*)tmp_data);
    return h;
}

// 获取系统时间戳
+ (NSString *)timeStampAtNow
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%lld", (long long)interval];
    
    return timeStamp;
}

//去掉前后空格和换行符
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(instancetype)randomStr{
    NSMutableString *string = [NSMutableString string];
    int stringLength = (arc4random() % 100) + 50;
    for (int i = 0; i < stringLength; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

/**
 适合的高度-通过宽度和字体
 
 @param font 字体
 @param width 宽度
 @return 适合的高度，默认 systemFontOfSize:font
 */
- (CGFloat)heightWithFont:(NSInteger)font width:(CGFloat)width {
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font] } context:nil].size.height;
}

/**
 适合的宽度- 通过高度和字体
 
 @param font 字体
 @param height 高度
 @return 适合的宽度 默认 systemFontOfSize:font
 */
- (CGFloat)widthWithFont:(NSInteger)font height:(CGFloat)height {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font] } context:nil].size.width;
}

@end

