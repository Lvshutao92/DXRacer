//
//  ITEMCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ITEMCell.h"



@implementation ITEMCell

- (UIImageView *)imageViewpic {
    if (_imageViewpic == nil) {
        self.imageViewpic = [[UIImageView alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            self.imageViewpic.frame = CGRectMake(10, 10, 100, 130);
        }else {
            self.imageViewpic.frame = CGRectMake(10, 10, 100, 180);
        }
        self.imageViewpic.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViewpic;
}
- (UILabel *)labone {
    if (_labone == nil) {
        self.labone = [[UILabel alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
            self.labone.frame = CGRectMake(115, 10, SCREEN_WIDTH-125, 30);
        }else{
            self.labone.frame = CGRectMake(115, 5, SCREEN_WIDTH-125, 30);
        }
        self.labone.font = [UIFont systemFontOfSize:13];
    }
    return _labone;
}
- (UILabel *)labtwo {
    if (_labtwo == nil) {
        self.labtwo = [[UILabel alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
            self.labtwo.frame = CGRectMake(0, 0, 0, 0);
        }else{
            self.labtwo.frame = CGRectMake(115, 45, SCREEN_WIDTH-125, 30);
        }
        self.labtwo.font = [UIFont systemFontOfSize:13];
        self.labtwo.textColor = RGBACOLOR(32, 157, 149, 1.0);
    }
    return _labtwo;
}
- (UILabel *)labthree {
    if (_labthree == nil) {
        self.labthree = [[UILabel alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
            self.labthree.frame = CGRectMake(0, 0, 0, 0);
        }else{
            self.labthree.frame = CGRectMake(115, 85, SCREEN_WIDTH-125, 30);
        }
        self.labthree.font = [UIFont systemFontOfSize:13];
        
    }
    return _labthree;
}
- (UILabel *)labfour {
    if (_labfour == nil) {
        self.labfour = [[UILabel alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
            self.labfour.frame = CGRectMake(115, 60, SCREEN_WIDTH-125, 30);
        }else{
            self.labfour.frame = CGRectMake(115, 125, SCREEN_WIDTH-125, 30);
        }
        self.labfour.font = [UIFont systemFontOfSize:13];
    }
    return _labfour;
}
- (UILabel *)labfive {
    if (_labfive == nil) {
        self.labfive = [[UILabel alloc]init];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
            self.labfive.frame = CGRectMake(115, 110, SCREEN_WIDTH-125, 30);
        }else{
            self.labfive.frame = CGRectMake(115, 165, SCREEN_WIDTH-125, 30);
        }
        self.labfive.font = [UIFont systemFontOfSize:13];
    }
    return _labfive;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            self.addBtn.frame = CGRectMake(SCREEN_WIDTH-40, 60, 30, 30);
        }else {
            self.addBtn.frame = CGRectMake(SCREEN_WIDTH-40, 85, 30, 30);
        }
        UIImage *theImage = [UIImage imageNamed:@"gouwu"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.addBtn setImage:theImage forState:UIControlStateNormal];
        [self.addBtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
        [self.addBtn addTarget:self action:@selector(clickAddCurt:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addBtn;
}






- (void)clickAddCurt:(UIButton *)sender {
    if (_clickCars) {
        _clickCars(_imageViewpic);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageViewpic];
        [self.contentView addSubview:self.labone];
        [self.contentView addSubview:self.labtwo];
        [self.contentView addSubview:self.labthree];
        [self.contentView addSubview:self.labfour];
        [self.contentView addSubview:self.labfive];
        [self.contentView addSubview:self.addBtn];
    }
    return self;
}

@end
