//
//  Manager.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/14.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface Manager : NSObject
//声明单例方法
+ (Manager *)sharedManager;

/*
 属性
 */
@property(nonatomic, strong)NSString  *addressName;//收货人姓名
@property(nonatomic, strong)NSString  *addressPhone;//收货人电话
@property(nonatomic, strong)NSString  *addressDetails;//收货人地址

@property(nonatomic, strong)NSString  *mobile;
@property(nonatomic, strong)NSString  *youbian;
@property(nonatomic, strong)NSString  *addr2;


@property(nonatomic, strong)NSString  *shenga;
@property(nonatomic, strong)NSString  *shia;
@property(nonatomic, strong)NSString  *qua;




@property(nonatomic, assign)NSInteger searchIndex;//判断检索界面

@property(nonatomic, strong)NSMutableArray *totolimgArray;//存储轮播图片
/*
 方法
 */
//MD5加密
- (NSString *)md5:(NSString *)str;
//base加解密
+ (NSString*)encodeBase64String:(NSString*)input;

+ (NSString*)decodeBase64String:(NSString*)input;

+ (NSString*)encodeBase64Data:(NSData*)data;

+ (NSString*)decodeBase64Data:(NSData*)data;
//字典转json字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict;
//金额转大写
+(NSString *)digitUppercase:(NSString *)numstr;
//存取数据
- (void)writewenjianming:(NSString *)wenjianming content:(NSString *)content;
- (NSString *)redingwenjianming:(NSString *)wenjianming;

@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)NSMutableArray *arr;

+ (AFSecurityPolicy *)customSecurityPolicy;

+ (NSString *)timezhuanhuan:(NSString *)str;
+ (NSString *)jinegeshi:(NSString *)text;
@property(nonatomic, assign)float height;

+ (AFHTTPSessionManager *)returnsession;
+ (NSString *)TimeCuoToTimes:(NSString *)str;
@end
