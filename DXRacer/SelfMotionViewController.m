//
//  SelfMotionViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/21.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "SelfMotionViewController.h"
#import "DingDanDetailsController.h"
#import "DDDetailsCell.h"
@interface SelfMotionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableview;

@end

@implementation SelfMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    self.tableview.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell3"];
    [self.view addSubview:self.tableview];
    for (int i=0; i<30; i++) {
        close[i] = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DingDanDetailsController *details = [[DingDanDetailsController alloc]init];
    [self.navigationController pushViewController:details animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
   
    cell.textLabel.text = @"自动订单";
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"编辑");
        self.tableview.editing = NO;
    }];
    edit.backgroundColor = [UIColor redColor];
    UITableViewRowAction *deleate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        self.tableview.editing = NO;
    }];
    deleate.backgroundColor = [UIColor orangeColor];
    
    UITableViewRowAction *daochu = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"导出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"导出");
        self.tableview.editing = NO;
    }];
    daochu.backgroundColor = [UIColor blackColor];
    UITableViewRowAction *xiugai = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"修改实销金额");
        self.tableview.editing = NO;
    }];
    xiugai.backgroundColor = [UIColor magentaColor];
    
    return @[edit,deleate,daochu,xiugai];
}


@end
