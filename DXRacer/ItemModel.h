//
//  ItemModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/30.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpModel.h"
@interface ItemModel : NSObject

@property(nonatomic, strong)NSString *inventorys;
@property(nonatomic, strong)NSDictionary *map;
@property(nonatomic, strong)MpModel *model;
@end
