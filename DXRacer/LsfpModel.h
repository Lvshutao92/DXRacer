//
//  LsfpModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/17.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LsfpDicModel.h"
@interface LsfpModel : NSObject
@property(nonatomic, strong)NSDictionary *map;
@property(nonatomic, strong)LsfpDicModel *mapmodel;

@property(nonatomic, strong)NSArray *orderItems;
@end
