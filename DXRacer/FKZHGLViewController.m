//
//  FKZHGLViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/22.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "FKZHGLViewController.h"
#import "FKZHCell.h"
#import "FKZHModel.h"

#import "AddViewController.h"


@interface FKZHGLViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSInteger totolNum;
    float height;
    
}
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation FKZHGLViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"FKZHCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    btn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [btn setTitle:@"添加新账户" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickadd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
   
    [self setUpReflash];
}



#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230+height;
}

#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FKZHCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
    FKZHModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([model.status isEqualToString:@"Y"]) {
        cell.lab5.text = @"已启用";
    }else {
        cell.lab5.text = @"已禁用";
    }
    
    
    if ([model.type isEqualToString:@"支付宝"]) {
        cell.lab1.text = model.type;
        
        if (model.payaccount.length == 0) {
            cell.lab2.text = @"-";
        }else{
            cell.lab2.text = model.payaccount;
        }
        if (model.company_name.length == 0) {
            cell.lab3.text = @"-";
        }else{
            cell.lab3.text = model.company_name;
        }
     
        
        if (model.field1.length == 0) {
            cell.lab4.text = @"-";
            cell.heigh1.constant = 20;
//            cell.juli2.constant  = 10;
            cell.juli1.constant = 15;
        }else{
            cell.lab4.text = model.field1;
            cell.lab4.numberOfLines = 0;
            cell.lab4.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [cell.lab4 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
            height = size.height;
            cell.heigh1.constant = height;
//            cell.juli2.constant = height -10;
            cell.juli1.constant = height -5;
        }
        
        
        
        cell.lab6.text = model.partnername;
        cell.lab7.text = [Manager timezhuanhuan:model.createtime];
        cell.mingcheng.text = @"支付宝名称";
    }else {
        cell.lab1.text = model.type;
        if (model.payaccount.length == 0) {
            cell.lab2.text = @"-";
        }else{
            cell.lab2.text = model.payaccount;
        }
        if (model.company_name.length == 0) {
            cell.lab3.text = @"-";
        }else{
            cell.lab3.text = model.company_name;
        }
        
        if (model.bank_name.length == 0){
            cell.lab4.text = @"-";
            cell.heigh1.constant = 20;
//            cell.juli2.constant  = 10;
            cell.juli1.constant = 15;
        }else{
            cell.lab4.text = model.bank_name;
            cell.lab4.numberOfLines = 0;
            cell.lab4.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [cell.lab4 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
            height = size.height;
            cell.heigh1.constant = height;
//            cell.juli2.constant = height -10;
            cell.juli1.constant = height - 5;
        }
        
        
        
        cell.lab6.text = model.partnername;
        cell.lab7.text = [Manager timezhuanhuan:model.createtime];
        cell.mingcheng.text = @"银行名称";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        FKZHModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
       
            AddViewController *add = [[AddViewController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
            add.idstr = model.id;
            add.string = @"bianji";
            add.str1 = model.type;
            add.str2 = model.payaccount;
            add.str3 = model.company_name;
            add.str4 = model.field1;
            add.str5 = model.bank_name;
            add.navigationItem.title = @"编辑";
            [self presentViewController:na animated:YES completion:nil];
          
        
    }];
    kaipiao.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull edit, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        FKZHModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self loddeleate:model.id indexpath:indexPath];
    }];
    edit.backgroundColor = RGBACOLOR(254, 91, 91, 1.0);
    UITableViewRowAction *zt = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"状态" handler:^(UITableViewRowAction * _Nonnull edit, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        FKZHModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self lodstate:model.id status:model.status];
    }];
    zt.backgroundColor = RGBACOLOR(39, 194, 183, 1.0);
    return @[edit,kaipiao,zt];
}
//添加新账户
- (void)clickadd {
    AddViewController *add = [[AddViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
    add.navigationItem.title = @"添加账户";
    [self presentViewController:na animated:YES completion:nil];
    
}
//刷新数据
-(void)setUpReflash{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totolNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodSL];
        }
    }];
}
- (void)lodXL {
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"payaccount", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totolNum = [[dic objectForKey:@"total"] integerValue];
        page = 2;
//        NSLog(@"%@",dic);
        [weakSelf.dataArray removeAllObjects];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            FKZHModel *model = [FKZHModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        
//        NSLog(@"dic=======%@",dic);
        
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}
- (void)lodSL {
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"payaccount", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        page ++;
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            FKZHModel *model = [FKZHModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
        }
//        NSLog(@"dic=======%@",dic);
        
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

//删除
- (void)loddeleate:(NSString *)ids indexpath:(NSIndexPath *)indexpath{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (ids != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"id":ids,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"payaccount",@"delete") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                
                [weakSelf.dataArray removeObjectAtIndex:indexpath.row];
                [weakSelf.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除成功" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
 
    
}
//状态
- (void)lodstate:(NSString *)L_id status:(NSString *)status{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (L_id != nil && status != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"status":status,
                @"id":L_id,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"payaccount",@"updateStatus") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [weakSelf setUpReflash];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功修改状态" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
 
}


@end
