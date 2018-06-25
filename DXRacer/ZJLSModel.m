//
//  ZJLSModel.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/6.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ZJLSModel.h"

@implementation ZJLSModel


+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"mymoney"]) propertyName = @"new_money";
    return propertyName;
}

@end
