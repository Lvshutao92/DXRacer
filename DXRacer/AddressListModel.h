//
//  AddressListModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/5.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressListModel : NSObject
@property(nonatomic, strong)NSString *areacode;
@property(nonatomic, strong)NSString *areaname;
@property(nonatomic, strong)NSString *business_id;
@property(nonatomic, strong)NSString *citycode;
@property(nonatomic, strong)NSString *cityname;
@property(nonatomic, strong)NSString *detailaddress;
@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *mobile;
@property(nonatomic, strong)NSString *provincecode;
@property(nonatomic, strong)NSString *provincename;
@property(nonatomic, strong)NSString *shipping_person;
@property(nonatomic, strong)NSString *telephone;
@property(nonatomic, strong)NSString *user_id;
@property(nonatomic, strong)NSString *zip;

@end
