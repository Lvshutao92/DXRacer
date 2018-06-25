//
//  SYOneCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/16.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "SYOneCell.h"
#import "LLGridView.h"
@implementation SYOneCell

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 200)];
        
        self.scrollView.backgroundColor = [UIColor lightGrayColor];
        
        NSArray *columns = @[@"期次",@"还款日",@"应还本息(元)",@"本金(元)",@"利息(元)",@"www"];
        NSArray *rows = @[@[@"1",@"2017-02-15",@"1741.25",@"16858.33",@"82.92",@"444"],
                          @[@"2",@"2017-02-15",@"1741.25",@"16858.33",@"82.92",@"444"],
                          @[@"3",@"2017-02-15",@"1741.25",@"16858.33",@"82.92",@"444"],
                          @[@"4",@"2017-02-15",@"1741.25",@"16858.33",@"82.92",@"444"]];
        LLGridView *gridView = [[LLGridView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24+44*rows.count)];
        gridView.backgroundColor = [UIColor whiteColor];
        gridView.borderColor = [UIColor grayColor];
        gridView.textColor = [UIColor blackColor];
        gridView.columns = columns;
        gridView.rows = rows;
        
        self.scrollView.contentSize = CGSizeMake(24+44*rows.count, 200);
        [self.scrollView addSubview:gridView];
    }
    return _scrollView;
}
- (UILabel *)line {
    if (_line == nil) {
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        self.line.backgroundColor = [UIColor colorWithWhite:.8 alpha:0.5];
    }
    return _line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.scrollView];
        [self.contentView addSubview:self.line];
    }
    return self;
}
@end
