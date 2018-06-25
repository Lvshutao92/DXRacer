//
//  SubAccountModel.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/11.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubAccountModel : NSObject

@property(nonatomic, strong)NSString *business_id;
@property(nonatomic, strong)NSString *create_time;
@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *partner_id;
@property(nonatomic, strong)NSString *password;
@property(nonatomic, strong)NSString *realname;
@property(nonatomic, strong)NSString *roles;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *username;

@property(nonatomic, strong)NSString *showmoney;
@property(nonatomic, strong)NSString *showorder;
@property(nonatomic, strong)NSString *mainaccount;
@end
