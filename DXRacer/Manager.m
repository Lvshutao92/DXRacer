//
//  Manager.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/14.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "Manager.h"
//引入IOS自带密码库


static Manager *manager = nil;
@implementation Manager

+ (Manager *)sharedManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[Manager alloc] init];
    });
    return manager;
}
- (NSMutableArray *)totolimgArray {
    if (_totolimgArray == nil) {
        self.totolimgArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _totolimgArray;
}
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}
//base加解密
+ (NSString*)encodeBase64String:(NSString* )input {
    
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 encodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)decodeBase64String:(NSString* )input {
    
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)encodeBase64Data:(NSData*)data {
    
    data = [GTMBase64 encodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

+ (NSString*)decodeBase64Data:(NSData*)data {
    
    data = [GTMBase64 decodeData:data];
    
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    return base64String;
    
}

//字典转json字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//金额转大写
+(NSString *)digitUppercase:(NSString *)numstr{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix = [NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar  objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        NSInteger flag = valstr.length - 2;
        NSString *head=[valstr substringToIndex:flag - 1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar  objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}
- (void)writewenjianming:(NSString *)wenjianming content:(NSString *)content {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path = [documents stringByAppendingPathComponent:wenjianming];
    NSString *str = content;
    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)redingwenjianming:(NSString *)wenjianming {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path = [documents stringByAppendingPathComponent:wenjianming];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return str;
}
//时间戳转时间
+ (NSString *)TimeCuoToTimes:(NSString *)str{
    long long time=[str longLongValue] / 1000;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}


+(AFSecurityPolicy *)customSecurityPolicy {
//    //先导入证书，找到证书的路径
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"dms.dxracer.com.cn" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//
//    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
//    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

+ (NSString *)jinegeshi:(NSString *)text {
//    float money = [string floatValue];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle =kCFNumberFormatterCurrencyStyle;
//    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:money]];
//    return newAmount;
    
    if(!text || [text floatValue] == 0){
        return @"¥0.00";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"¥%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [NSString stringWithFormat:@"¥%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]]];
}

+ (NSString *)timezhuanhuan:(NSString *)str {
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"MMM dd,yyyy HH:mm:ss aa";
    NSDate *createDate = [fmt dateFromString:str];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * times = [fmt stringFromDate:createDate];
    return times;
}
//网络请求
+ (AFHTTPSessionManager *)returnsession{
    //https处理
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"dms.dxracer.com.cn" ofType:@".cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
    //适配https
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    [securityPolicy setPinnedCertificates:cerSet];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    
    
    
    //参数格式处理
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    //网络处理LoginViewController
    
    // 设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 60.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return session;
}
@end
