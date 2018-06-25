//
//  MineSevenViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineSevenViewController.h"
#import "AddAccountViewController.h"
#import "SubAccountCell.h"
#import "SubAccountModel.h"
@interface MineSevenViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSInteger totalNum;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UITableView *tableview;
@end

@implementation MineSevenViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddAddress)];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"SubAccountCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    [self setUpReflash];
}

- (void)clickAddAddress {
    AddAccountViewController *account = [[AddAccountViewController alloc]init];
    account.navigationItem.title = @"添加账户";
    [self.navigationController pushViewController:account animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SubAccountModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
    cell.bgview.backgroundColor = [UIColor whiteColor];
    
    cell.userlab.text   = model.username;
    cell.namelab.text   = model.realname;
    cell.putonglab.text = model.roles;
    
    if ([model.status isEqualToString:@"Y"]) {
       cell.zhangchanglab.text = @"正常";
    }else {
       cell.zhangchanglab.text = @"停用";
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"MMM dd,yyyy HH:mm:ss aa";
    NSDate *createDate = [fmt dateFromString:model.create_time];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString * times = [fmt stringFromDate:createDate];
    cell.timalab.text = times;
    return cell;
}
//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totalNum) {
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
            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"myAccount",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totalNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
        //NSLog(@"==%@",dic);
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *dic in arr) {
            SubAccountModel *model = [SubAccountModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        
        page = 2;
        [weakSelf.tableview reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}
- (void)lodSL {
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"myAccount", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totalNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        
        for (NSDictionary *dic in arr) {
            SubAccountModel *model = [SubAccountModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        page ++;
        [weakSelf.tableview reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        SubAccountModel *model = [self.dataArray objectAtIndex:indexPath.row];
        AddAccountViewController *account = [[AddAccountViewController alloc]init];
        account.navigationItem.title = @"编辑账户";
        account.string   = @"bianji";
        account.idString = model.id;
        account.roleString = model.roles;
        
        
        account.username   = model.username;
        account.xingming   = model.realname;
        account.mima   = model.password;
        account.status   = model.status;
        
        account.showmoney   = model.showmoney;
        account.showorder   = model.showorder;
        [self.navigationController pushViewController:account animated:YES];
    }];
    edit.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    UITableViewRowAction *deleate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull deleate, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SubAccountModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self lod:model.id indexpath:indexPath];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ac];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    deleate.backgroundColor = RGBACOLOR(39, 194, 183, 1.0);
   
    return @[edit,deleate];
}






- (void)lod:(NSString *)l_id indexpath:(NSIndexPath *)indexpath{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (l_id != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"id":l_id,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"user",@"delete") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            
            
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                
                [weakSelf.dataArray removeObjectAtIndex:indexpath.row];
                [weakSelf.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"result_msg"] message:@"温馨提示" preferredStyle:1];
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
