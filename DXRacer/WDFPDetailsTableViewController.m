//
//  WDFPDetailsTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/14.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "WDFPDetailsTableViewController.h"
#import "WDFPDCell.h"
#import "WDFPDModel.h"


@interface WDFPDetailsTableViewController ()
{
    NSInteger page;
    NSInteger totalNum;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation WDFPDetailsTableViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.tableView registerNib:[UINib nibWithNibName:@"WDFPDCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableView.tableFooterView = v;
    [self setUpReflash];
}
- (void)click {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDFPDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WDFPDModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.lab1.text = model.order_no;
    cell.lab2.text = model.sku_code;
    cell.lab3.text = model.quantity;
    cell.lab4.text = [Manager jinegeshi:model.total_fee];
    
    return cell;
}
//刷新数据
-(void)setUpReflash{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.dataArray.count == totalNum) {
            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodSL];
        }
    }];
}
- (void)lodXL {
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"group_id":self.idStr,
            @"page":[NSString stringWithFormat:@"%ld",page]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"invoice_group_item", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totalNum = [[dic objectForKey:@"total"] integerValue];
        page = 2;

        [weakSelf.dataArray removeAllObjects];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            WDFPDModel *model = [WDFPDModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)lodSL {
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"group_id":self.idStr,
            @"page":[NSString stringWithFormat:@"%ld",page]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"topup", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        page ++;
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            WDFPDModel *model = [WDFPDModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


@end
