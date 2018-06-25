//
//  DDDModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/3.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"
#import "MapModel.h"

@interface DDDModel : NSObject

@property(nonatomic, strong)NSDictionary *map;
@property(nonatomic, strong)MapModel *mapmodel;

@property(nonatomic, strong)NSDictionary *orderAddress;
@property(nonatomic, strong)AddressModel *addressmodel;

@property(nonatomic, strong)NSArray *orderItems;


@end
