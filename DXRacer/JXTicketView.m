//
//  FinalTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//
#import "JXTicketView.h"

// 屏幕大小
#define kScreenBounds [UIScreen mainScreen].bounds
// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface JXTicketView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *vie;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *fklable;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *ensureBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *problomeBtn;
@end

@implementation JXTicketView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.vie];
        [self.vie addSubview:self.line];
        [self.vie addSubview:self.tableView];
        [self.vie addSubview:self.cancleBtn];
        [self.vie addSubview:self.ensureBtn];
        [self.vie addSubview:self.fklable];
        [self.vie addSubview:self.problomeBtn];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"支付宝账号";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, kScreenWidth-140, 44)];
        lable.text = @"156******71";
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lable];
    }
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"付款方式";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, kScreenWidth-155, 44)];
        lable.text = @"中原银行储蓄卡(2823)";
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = [UIColor grayColor];
        lable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lable];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"需付款";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, kScreenWidth-140, 44)];
        lable.text = @"¥9999.00";
        lable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lable];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if ([self.delegate respondsToSelector:@selector(clickSelectedFuKuanFangshi)] ) {
            [self.delegate clickSelectedFuKuanFangshi];
        }
    }
}

#pragma mark - EventResponse
- (void)closeBtnDidClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(closeBtnDidClicked)] ) {
         [self.delegate closeBtnDidClicked];
    }
}
- (void)ensureBtnDidClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ensureBtnDidClicked)]) {
        [self.delegate ensureBtnDidClicked];
    }
}
- (void)problomeBtnDidClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(problomeBtnDidClicked)]) {
        [self.delegate problomeBtnDidClicked];
    }
}

#pragma mark - Lazyload
- (UITableView *)tableView {
    if (_tableView == NULL) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, CGRectGetHeight(self.frame) - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        
    }
    
    return _tableView;
}
- (UIView *)vie {
    if (_vie == nil) {
        _vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame))];
        _vie.backgroundColor = [UIColor whiteColor];
    }
    return _vie;
}
- (UILabel *)line {
    if (_line == nil) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
    }
    return _line;
}
- (UILabel *)fklable {
    if (_fklable == nil) {
        _fklable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-50, 5, 100, 40)];
        _fklable.text = @"付款详情";
        _fklable.textAlignment = NSTextAlignmentCenter;
    }
    return _fklable;
}
- (UIButton *)cancleBtn {
    if (_cancleBtn == NULL) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(20, 10, 30, 30);
        [_cancleBtn setImage:[UIImage imageNamed:@"finalcancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
- (UIButton *)problomeBtn {
    if (_problomeBtn == NULL) {
        _problomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _problomeBtn.frame = CGRectMake(kScreenWidth-50, 10, 30, 30);
        [_problomeBtn setImage:[UIImage imageNamed:@"finalproblome"] forState:UIControlStateNormal];
        [_problomeBtn addTarget:self action:@selector(problomeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _problomeBtn;
}



- (UIButton *)ensureBtn {
    if (_ensureBtn == NULL) {
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 55, kScreenWidth-20, 40);
        [_ensureBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        [_ensureBtn setBackgroundColor:[UIColor blueColor]];
        _ensureBtn.layer.masksToBounds = YES;
        _ensureBtn.layer.cornerRadius = 5;
        _ensureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ensureBtn;
}
@end
