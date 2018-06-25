//
//  MODELCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MODELCell.h"

@implementation MODELCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.lable];
    }
    return self;
}
- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-60)/2, 190)];
    }
    return _imageView;
}
- (UILabel *)lable {
    if (_lable == nil) {
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 195, (SCREEN_WIDTH-60)/2, 20)];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.font = [UIFont systemFontOfSize:13];
    }
    return _lable;
}



@end
