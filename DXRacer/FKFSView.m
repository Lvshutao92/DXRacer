//
//  FKFSView.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/26.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "FKFSView.h"



@interface FKFSView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *vie;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UILabel *fkfslable;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation FKFSView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.vie];
        [self.vie addSubview:self.line];
        [self.vie addSubview:self.tableView];
        [self.vie addSubview:self.cancleBtn];
        [self.vie addSubview:self.fkfslable];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Lazyload
- (UITableView *)tableView {
    if (_tableView == NULL) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(self.frame) - 60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
- (UIView *)vie {
    if (_vie == nil) {
        _vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.frame))];
        _vie.backgroundColor = [UIColor whiteColor];
    }
    return _vie;
}
- (UILabel *)line {
    if (_line == nil) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
    }
    return _line;
}
- (UILabel *)fkfslable {
    if (_fkfslable == nil) {
        _fkfslable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, 5, 120, 40)];
        _fkfslable.text = @"选择付款方式";
        _fkfslable.textAlignment = NSTextAlignmentCenter;
    }
    return _fkfslable;
}
- (UIButton *)cancleBtn {
    if (_cancleBtn == NULL) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(20, 10, 30, 30);
        [_cancleBtn setImage:[UIImage imageNamed:@"finalcancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickCancle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        if ([self.delegate respondsToSelector:@selector(clickSelectedFuKuanFangshi)] ) {
//            [self.delegate clickSelectedFuKuanFangshi];
//        }
    
}

#pragma mark - EventResponse
- (void)clickCancle:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickCancle)] ) {
        [self.delegate clickCancle];
    }
}








@end
