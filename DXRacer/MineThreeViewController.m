//
//  MineThreeViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineThreeViewController.h"
#import "AddAddressViewController.h"
#import "AddressCell.h"
#import "AddressListModel.h"


@interface MineThreeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *selectedBtn;
    NSInteger page;
    NSInteger totolNum;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation MineThreeViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
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
    [self.tableview registerClass:[AddressCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setUpReflash];
}

- (void)clickAddAddress {
//    AddAddressViewController *add = [[AddAddressViewController alloc]init];
//    add.navigationItem.title = @"添加新地址";
//    [self.navigationController pushViewController:add animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [Manager sharedManager].addressName = cell.namelabel.text;
    [Manager sharedManager].addressPhone = cell.phonelabel.text;
    [Manager sharedManager].addressDetails = cell.addresslabel.text;
   
    if (self.str != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AddressListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = RGBACOLOR(245, 246, 248, 1.0);
    cell.morenbtn.tag = indexPath.row;
    [cell.morenbtn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.bianjibtn.tag = indexPath.row;
    [cell.bianjibtn addTarget:self action:@selector(clickbtnedit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.shanchubtn.tag = indexPath.row;
    [cell.shanchubtn addTarget:self action:@selector(clickbtndelate:) forControlEvents:UIControlEventTouchUpInside];
 
    if (indexPath.row == 0) {
        selectedBtn.enabled = YES;
        cell.morenbtn.enabled = NO;
        selectedBtn = cell.morenbtn;
    }

    cell.namelabel.text = model.shipping_person;
    cell.phonelabel.text = model.telephone;
    cell.addresslabel.text = model.detailaddress;
    
    return cell;
}

- (void)clickbtn:(UIButton *)sender {
//    AddressCell *cell = (AddressCell *)[[[sender superview]superview] superview];
//    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
//    NSLog(@"---%ld",indexpath.row);
    selectedBtn.enabled = YES;
    sender.enabled = NO;
    selectedBtn = sender;
}
- (void)clickbtnedit:(UIButton *)sender {
//    AddressCell *cell = (AddressCell *)[[[sender superview]superview] superview];
//    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
//    NSLog(@"---%ld",indexpath.row);
}

- (void)clickbtndelate:(UIButton *)sender {
//    AddressCell *cell = (AddressCell *)[[[sender superview]superview] superview];
//    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
//    NSLog(@"---%ld",indexpath.row);
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
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],@"page":[NSString stringWithFormat:@"%ld",page]};
   
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"user_address",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"^^^^^^%@",dic);
        totolNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        
        [self.dataArray removeAllObjects];;
        
        for (NSDictionary *dic in arr) {
            AddressListModel *model = [AddressListModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
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
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],@"page":[NSString stringWithFormat:@"%ld",page]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"user_address", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totolNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        
        for (NSDictionary *dic in arr) {
            AddressListModel *model = [AddressListModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:model];
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
@end
