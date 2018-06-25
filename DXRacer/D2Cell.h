//
//  D2Cell.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/18.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topheigh;

@end
