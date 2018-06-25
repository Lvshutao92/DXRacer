//
//  ITEMCell.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickCars)(UIImageView *goodImage);

@interface ITEMCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *imageViewpic;
@property (strong, nonatomic)  UILabel *labone;
@property (strong, nonatomic)  UILabel *labtwo;
@property (strong, nonatomic)  UILabel *labthree;
@property (strong, nonatomic)  UILabel *labfour;
@property (strong, nonatomic)  UILabel *labfive;

@property (strong, nonatomic)  UIButton *addBtn;

@property (strong , nonatomic)clickCars clickCars;

@end
