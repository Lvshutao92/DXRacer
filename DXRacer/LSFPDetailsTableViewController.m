//
//  LSFPDetailsTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/18.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "LSFPDetailsTableViewController.h"
#import "D1Cell.h"
#import "D2Cell.h"
#import "D3Cell.h"
@interface LSFPDetailsTableViewController ()
{
    float heigh;
}
@end

@implementation LSFPDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"D1Cell" bundle:nil] forCellReuseIdentifier:@"cellA"];
    [self.tableView registerNib:[UINib nibWithNibName:@"D2Cell" bundle:nil] forCellReuseIdentifier:@"cellB"];
    [self.tableView registerNib:[UINib nibWithNibName:@"D3Cell" bundle:nil] forCellReuseIdentifier:@"cellC"];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else {
        return 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        D1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellA" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.str1.length == 0) {
            cell.lab1.text = @"-";
        }else{
             cell.lab1.text = self.str1;
        }
        
        if (self.str2.length == 0) {
            cell.lab2.text = @"-";
        }else{
            cell.lab2.text = self.str2;
        }
        
        if (self.str3.length == 0) {
            cell.lab3.text = @"-";
        }else{
            cell.lab3.text = self.str3;
        }
        
        if (self.str4.length == 0) {
            cell.lab4.text = @"-";
        }else{
            cell.lab4.text = self.str4;
        }
        
        if (self.str5.length == 0) {
            cell.lab5.text = @"-";
        }else{
            cell.lab5.text = self.str5;
        }
        
        
        
        if (self.str6.length == 0) {
            cell.laab6.text = @"-";
        }else{
            cell.laab6.text = self.str6;
        }
        
        return cell;
    }else if (indexPath.section == 1) {
        D2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellB" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.str7.length == 0) {
            cell.lab1.text = @"-";
        }else{
            cell.lab1.text = self.str7;
        }
        
        if (self.str8.length == 0) {
            cell.lab2.text = @"-";
        }else{
            cell.lab2.text = self.str8;
        }
        if (self.str9.length == 0 || self.str9 == nil) {
            cell.lab3.text = @"-";
            heigh = 20;
        }else{
            cell.lab3.text = self.str9;
            cell.lab3.numberOfLines = 0;
            cell.lab3.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [cell.lab3 sizeThatFits:CGSizeMake(SCREEN_WIDTH-105, MAXFLOAT)];
            heigh = size.height;
            cell.heigh.constant = heigh;
        }
        
        return cell;
    }    
    D3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellC" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.str10.length == 0) {
        cell.lab1.text = @"-";
    }else{
        cell.lab1.text = self.str10;
    }
    
    if (self.str11.length == 0) {
        cell.lab2.text = @"-";
    }else{
        cell.lab2.text = self.str11;
    }
    if (self.str12.length == 0) {
        cell.lab3.text = @"-";
    }else{
       cell.lab3.text = self.str12;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }else if (indexPath.section == 1){
        return 90+heigh;
    }else {
      return 100;
    }
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"  发票详细信息";
        return view;
    }else if (section == 1) {
        label.text = @"  收票人信息";
        return view;
    }
    label.text = @"  物流信息";
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

@end
