//
//  RowsModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/4.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"
#import "skuImage0Model.h"

@interface RowsModel : NSObject
@property(nonatomic, strong)NSArray *chaircolorList;
@property(nonatomic, strong)NSArray *chairlogoList;
@property(nonatomic, strong)NSArray *clothescolorList;
@property(nonatomic, strong)NSArray *clothessizeList;
@property(nonatomic, strong)NSArray *invenList;
@property(nonatomic, strong)NSArray *skuImageList;

@property(nonatomic, strong)NSDictionary *product;
@property(nonatomic, strong)ProductModel *proModel;
@property(nonatomic, strong)NSDictionary *skuImage0;
@property(nonatomic, strong)skuImage0Model *skuImgModel;


@property(nonatomic, strong)NSString *product_id;
@property(nonatomic, strong)NSString *quantity;
@property(nonatomic, strong)NSString *type;

@end





