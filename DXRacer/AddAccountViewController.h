//
//  AddAccountViewController.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/21.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usertex;
@property (weak, nonatomic) IBOutlet UITextField *nametex;
@property (weak, nonatomic) IBOutlet UITextField *Passwordtext;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;

@property (weak, nonatomic) IBOutlet UITextField *roleText;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;
@property (weak, nonatomic) IBOutlet UILabel *statusl;




@property (weak, nonatomic) IBOutlet UITextField *statustext;


//"business_id" = 10001;
//"create_time" = "Jul 18, 2017 7:26:13 PM";
//id = 194;
//"partner_id" = "\U5f6d\U4e91";
//password = 25f9e794323b453885f5181f1b624d0b;
//realname = "\U5f6d\U4e91\U98de";
//roles = "\U9ad8\U7ea7\U5b50\U8d26\U6237";
//status = Y;
//username = "\U5f6d\U4e91\U98de";
@property (weak, nonatomic) NSString *showorder;
@property (weak, nonatomic) NSString *showmoney;


@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSString *xingming;

@property (weak, nonatomic) NSString *mima;
@property (weak, nonatomic) NSString *status;

@property (weak, nonatomic) NSString *string;
@property (weak, nonatomic) NSString *idString;
@property (weak, nonatomic) NSString *roleString;
@end
