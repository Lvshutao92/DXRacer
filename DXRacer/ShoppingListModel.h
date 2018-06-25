//
//  ShoppingListModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/4.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListModel : NSObject
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *business_id;
@property (nonatomic,strong) NSString *chair_color_name;
@property (nonatomic,strong) NSString *chair_logo_name;
@property (nonatomic,strong) NSString *clothes_color_name;
@property (nonatomic,strong) NSString *clothes_size_name;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *listprice;
@property (nonatomic,strong) NSString *realprice;
@property (nonatomic,strong) NSString *shoppingcartid;
@property (nonatomic,strong) NSString *skucode;
@property (nonatomic,strong) NSString *skuname;
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString *price;

@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger number;
@end
