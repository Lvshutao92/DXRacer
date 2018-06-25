//
//  resultList1Model.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/6.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface resultList1Model : NSObject

@property(nonatomic, strong)NSString *business_id;
@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *order_id;
@property(nonatomic, strong)NSString *receiver_address;
@property(nonatomic, strong)NSString *receiver_city;
@property(nonatomic, strong)NSString *receiver_district;
@property(nonatomic, strong)NSString *receiver_mobile;
@property(nonatomic, strong)NSString *receiver_name;
@property(nonatomic, strong)NSString *receiver_phone;
@property(nonatomic, strong)NSString *receiver_state;
@property(nonatomic, strong)NSString *receiver_zip;


@property(nonatomic, strong)NSString *logistics;
@property(nonatomic, strong)NSString *express_order;
@property(nonatomic, strong)NSString *jxs_postage_cj;
@end
