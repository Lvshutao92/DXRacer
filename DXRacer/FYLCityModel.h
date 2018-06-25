//
//  FYLCityModel.h
//  QinYueHui
//
//  Created by FuYunLei on 2017/4/14.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYLProvince,FYLCity,FYLTown;

@interface FYLProvince : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, copy) NSString *code1;

@end

@interface FYLCity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *town;
@property (nonatomic, copy) NSString *code2;

@end


@interface FYLTown : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *coder;
@end
