//
//  AddressCell.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/26.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property(nonatomic, strong)UIView *addressBgView;

@property(nonatomic, strong)UILabel *namelabel;
@property(nonatomic, strong)UILabel *phonelabel;
@property(nonatomic, strong)UILabel *addresslabel;


@property(nonatomic, strong)UILabel *line;



@property(nonatomic, strong)UIButton *morenbtn;
@property(nonatomic, strong)UILabel *morenlabel;

@property(nonatomic, strong)UIButton *bianjibtn;
@property(nonatomic, strong)UIButton *shanchubtn;
@end
