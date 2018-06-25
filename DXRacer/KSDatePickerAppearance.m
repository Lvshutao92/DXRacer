//
//  KSDatePickerAppearance.m
//  Bespeak
//
//  Created by kong on 16/3/4.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSDatePickerAppearance.h"

@implementation KSDatePickerAppearance

- (instancetype)init
{
    if (self = [super init]) {
        
        [self defultValue];
        
    }
    return self;
}

- (void)defultValue
{
    _datePickerBackgroundColor = [UIColor whiteColor];
    _radius = 0.;
    _maskBackgroundColor = [UIColor colorWithWhite:.3 alpha:.5];
    
    
    
    
    
    _currentDate = [NSDate date];
    
    _datePickerMode = UIDatePickerModeDate;
    
    _headerText = @"请选择日期";
    _headerTextColor = [UIColor whiteColor];
    _headerTextFont = [UIFont systemFontOfSize:15];
    _headerBackgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    _headerTextAlignment = NSTextAlignmentCenter;
    _headerHeight = 44.;
    
    _buttonHeight = 44.;
    
    _commitBtnTitle = @"确定";
    _commitBtnFont = [UIFont systemFontOfSize:15];
    _commitBtnTitleColor = RGBACOLOR(32, 157, 149, 1.0);
    _commitBtnBackgroundColor = [UIColor whiteColor];
    
    _cancelBtnTitle = @"取消";
    _cancelBtnFont = [UIFont systemFontOfSize:15];
    _cancelBtnTitleColor = [UIColor lightGrayColor];
    _cancelBtnBackgroundColor = [UIColor whiteColor];
    
    _lineColor = [UIColor colorWithRed:205/255. green:205/255. blue:205/255. alpha:1.];
    _lineWidth = 0.5;
    
}
@end
