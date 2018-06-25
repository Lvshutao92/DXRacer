//
//  SYCollectionViewCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "SYCollectionViewCell.h"

@implementation SYCollectionViewCell
- (UIImageView *)imageview {
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30*SCALE_WIDTH, 10, SCREEN_WIDTH/4-60*SCALE_WIDTH, SCREEN_WIDTH/4-60*SCALE_WIDTH)];
        self.imageview.layer.cornerRadius = (SCREEN_WIDTH/4-60*SCALE_WIDTH)/2;
        self.imageview.layer.masksToBounds = YES;
        //_imageview.backgroundColor = [UIColor redColor];
    }
    return _imageview;
}

- (UILabel *)lable {
    if (_lable == nil) {
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/4-60*SCALE_WIDTH+20, SCREEN_WIDTH/4, 20)];
                //_lable.backgroundColor = [UIColor redColor];
        self.lable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.lable];
        [self.contentView addSubview:self.imageview];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
