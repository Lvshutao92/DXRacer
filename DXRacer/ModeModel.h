//
//  ModeModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/29.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"

@interface ModeModel : NSObject


@property (nonatomic ,strong)NSDictionary *product;
@property (nonatomic ,strong)NSArray *skuimgList;
@property (nonatomic ,strong)ProductModel *model;

@end


