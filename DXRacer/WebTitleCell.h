//
//  WebTitleCell.h
//  AFEFactory
//
//  Created by ilovedxracer on 2018/1/4.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebTitleCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1height;


@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img1top;

@end
