//
//  FYLCityModel.m
//  QinYueHui
//
//  Created by FuYunLei on 2017/4/14.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "FYLCityModel.h"


@implementation FYLProvince

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v",
             @"city" : @"n",
             @"code1" : @"k"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city" : [FYLCity class]};
}

@end

@implementation FYLCity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v",
             @"town" : @"n",
             @"code2" : @"k"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"town" : [FYLTown class]};
}

@end

@implementation FYLTown

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"v",
             @"coder" : @"k"};
}

@end
