//
//  AddressCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/26.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
        [self.contentView addSubview:self.addressBgView];
        [self.addressBgView addSubview:self.namelabel];
        [self.addressBgView addSubview:self.phonelabel];
        [self.addressBgView addSubview:self.addresslabel];
        [self.addressBgView addSubview:self.line];
        [self.addressBgView addSubview:self.morenbtn];
        [self.addressBgView addSubview:self.morenlabel];
        [self.addressBgView addSubview:self.bianjibtn];
        [self.addressBgView addSubview:self.shanchubtn];
        
    }
    return self;
}
- (UIView *)addressBgView {
    if (_addressBgView == nil) {
        self.addressBgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-10, 140)];
        self.addressBgView.layer.masksToBounds = YES;
        self.addressBgView.layer.cornerRadius = 4;
        self.addressBgView.backgroundColor = [UIColor whiteColor];
    }
    return _addressBgView;
}


- (UILabel *)namelabel {
    if (_namelabel == nil) {
        self.namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        self.namelabel.textAlignment = NSTextAlignmentLeft;
//        self.namelabel.text = @"吕书涛";
    }
    return _namelabel;
}
- (UILabel *)phonelabel {
    if (_phonelabel == nil) {
        self.phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, SCREEN_WIDTH-130, 30)];
        self.phonelabel.textAlignment = NSTextAlignmentRight;
//        self.phonelabel.text = @"15637812971";
    }
    return _phonelabel;
}
- (UILabel *)addresslabel {
    if (_addresslabel == nil) {
        self.addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-30, 60)];
//        self.addresslabel.text = @"河南省洛阳市汝阳县";
        self.addresslabel.numberOfLines = 0;
        self.addresslabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addresslabel;
}





- (UILabel *)line {
    if (_line == nil) {
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH-10, 1)];
        self.line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    }
    return _line;
}
- (UIButton *)morenbtn {
    if (_morenbtn == nil) {
        self.morenbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.morenbtn.frame = CGRectMake(10, 105,30, 30);
        [self.morenbtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
        [self.morenbtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateDisabled];
    }
    return _morenbtn;
}
- (UILabel *)morenlabel {
    if (_morenlabel == nil) {
        self.morenlabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 105, 60, 30)];
        self.morenlabel.text = @"默认地址";
        self.morenlabel.font = [UIFont systemFontOfSize:13];
    }
    return _morenlabel;
}
- (UIButton *)bianjibtn {
    if (_bianjibtn == nil) {
        self.bianjibtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bianjibtn.frame = CGRectMake(SCREEN_WIDTH-115, 105,50, 30);
        [self.bianjibtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.bianjibtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.bianjibtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.bianjibtn setImage:[UIImage imageNamed:@"addressedit"] forState:UIControlStateNormal];
    }
    return _bianjibtn;
}
- (UIButton *)shanchubtn {
    if (_shanchubtn == nil) {
        self.shanchubtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shanchubtn.frame = CGRectMake(SCREEN_WIDTH-65, 105,50, 30);
        [self.shanchubtn setTitle:@"删除" forState:UIControlStateNormal];
        self.shanchubtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.shanchubtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.shanchubtn setImage:[UIImage imageNamed:@"addressdelete"] forState:UIControlStateNormal];
    }
    return _shanchubtn;
}

@end
