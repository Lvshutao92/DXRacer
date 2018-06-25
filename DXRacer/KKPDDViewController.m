//
//  KKPDDViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/22.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "KKPDDViewController.h"
#import "AddressModel.h"
#import "DDDModel.h"
#import "MapModel.h"
#import "ItemsModel.h"
#import "KKPDDCell.h"
#import "DingDanDetailsController.h"
#import "KKPModel.h"
@interface KKPDDViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger page;
    NSInteger totalNum;
    NSString  *idd;
}
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)UITableView *tableview1;

@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;


@property(nonatomic, strong)NSMutableArray *array;
@end

@implementation KKPDDViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"KKPDDCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    vie.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.tableview.tableHeaderView = vie;
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-40, 40)];
    [self.textfield.layer setBorderWidth:0];
    self.textfield.delegate = self;
    
    [self.textfield.layer setBorderColor:[UIColor colorWithWhite:.8 alpha:.4].CGColor];
    [vie addSubview:self.textfield];
    
    
    self.tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(1, 50, SCREEN_WIDTH-2, 150)];
    [self.tableview1.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.tableview1.layer setBorderWidth:1];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.hidden = YES;
    [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableview addSubview:self.tableview1];
    [self.tableview bringSubviewToFront:self.tableview1];
    
    
     [self lod];
    
    
    
}

- (void)lod{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order",@"innitwarehourse") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"-------%@",dic);
        [weakSelf.array removeAllObjects];
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            
            NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"userStore"];
            for (NSDictionary *dicc in arr) {
                KKPModel *model = [KKPModel mj_objectWithKeyValues:dicc];
                [weakSelf.array addObject:model];
            }
            
            KKPModel *model = [weakSelf.array firstObject];
            weakSelf.textfield.text = model.name;
            [weakSelf setUpReflash:model.id];
        }
        [weakSelf.tableview1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    if (self.tableview1.hidden == NO) {
        self.tableview1.hidden = YES;
    }else {
        self.tableview1.hidden = NO;
    }
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableview]) {
        
        return 315;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableview1]) {
        self.tableview1.hidden = YES;
        [self.tableview.mj_header endRefreshing];
        KKPModel *model = [self.array objectAtIndex:indexPath.row];
        self.textfield.text = model.name;
        
        [self setUpReflash:model.id];
    }
    if ([tableView isEqual:self.tableview]) {
        DingDanDetailsController *details = [[DingDanDetailsController alloc]init];
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
        details.oderid = model.addressmodel.order_id;
        details.str = @"nobtn";
        [self presentViewController:na animated:YES completion:nil];
    }
    self.tableview1.hidden = YES;
}
#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableview]) {
        return self.dataArray.count;
    }
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([tableView isEqual:self.tableview1]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        KKPModel *model = [self.array objectAtIndex:indexPath.row];
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = model.name;
        return cell;
    }
    
    
    KKPDDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    ItemsModel *mo = [model.orderItems firstObject];
    cell.lab1.text = model.mapmodel.order_no;
    cell.lab2.text = model.mapmodel.orderItems;
    cell.lab3.text = model.addressmodel.receiver_name;
    
    if (model.mapmodel.order_resource_num.length == 0) {
        cell.lab4.text =  @"-";
    }else {
        cell.lab4.text = model.mapmodel.order_resource_num;
    }
    if (model.mapmodel.buyer_note.length == 0) {
        cell.lab5.text =  @"-";
    }else {
        cell.lab5.text = model.mapmodel.buyer_note;
    }
    
    
    if ([model.mapmodel.jxs_order_status isEqualToString:@"A"] || [model.mapmodel.order_status isEqualToString:@"N"]) {
        cell.lab6.text = @"订单异常";
    } if ([model.mapmodel.jxs_order_status isEqualToString:@"C"]){
        cell.lab6.text = @"订单已创建";
    } if ([model.mapmodel.jxs_order_status isEqualToString:@"E"]){
        cell.lab6.text = @"订单已发货";
    } if ([model.mapmodel.jxs_order_status isEqualToString:@"I"]){
        cell.lab6.text = @"订单已确认";
    } if ([model.mapmodel.jxs_order_status isEqualToString:@"J"]){
        cell.lab6.text = @"订单已分配";
    } if ([model.mapmodel.jxs_order_status isEqualToString:@"L"]){
        cell.lab6.text = @"订单已取消";
    }
    
    
    cell.lab7.text = [Manager timezhuanhuan:model.mapmodel.order_deliver_time];
    cell.lab9.text = model.mapmodel.warehourse;
    cell.lab8.text = [Manager jinegeshi:model.mapmodel.jxs_total_fee];
    cell.lab10.text= model.mapmodel.buyer_nick;
    
    return cell;
 
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"申请开票" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.tableview.editing = NO;
        [self lodShenQingKaiPiao:model.mapmodel.id];
    }];
    kaipiao.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    
    return @[kaipiao];
}



//刷新数据
-(void)setUpReflash:(NSString *)idds
{
    NSString *str = [NSString stringWithFormat:@"%@",idds];
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL:str];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totalNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodSL:str];
        }
    }];
}
- (void)lodXL:(NSString *)iddss {
    NSString *string;
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([[Manager sharedManager] redingwenjianming:@"showorder.text"].length == 0) {
        string = @" ";
    }else {
        string = [[Manager sharedManager] redingwenjianming:@"showorder.text"];
    }
    if (iddss != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"page":[NSString stringWithFormat:@"%ld",page],
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                @"warehourse":iddss,
                @"showorder":string,
                };
        
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"order",@"invoicelist") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//                    NSLog(@"可开票订单=-=-=-=-=-=%@",dic);
            NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultMapList"];
            totalNum = [[dic objectForKey:@"total"] integerValue];
            [weakSelf.dataArray removeAllObjects];
            
            [DDDModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"orderItems" : [ItemsModel class],
                         };
            }];
            for (NSDictionary *temp in array) {
                DDDModel *model = [DDDModel mj_objectWithKeyValues:temp];
                AddressModel *addressmodel = [AddressModel mj_objectWithKeyValues:model.orderAddress];
                MapModel *mapmodel = [MapModel mj_objectWithKeyValues:model.map];
                model.addressmodel = addressmodel;
                model.mapmodel = mapmodel;
                [weakSelf.dataArray addObject:model];
            }
            //        NSLog(@"%ld",self.dataArray.count);
            page = 2;
            [weakSelf.tableview reloadData];
            _tableview.contentInset = UIEdgeInsetsZero;
            _tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
            [weakSelf.tableview.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf.tableview.mj_header endRefreshing];
            _tableview.contentInset = UIEdgeInsetsZero;
            _tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
        }];
    }
}
- (void)lodSL:(NSString *)iddsss {
    NSString *string;
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([[Manager sharedManager] redingwenjianming:@"showorder.text"].length == 0) {
        string = @" ";
    }else {
        string = [[Manager sharedManager] redingwenjianming:@"showorder.text"];
    }
    if (iddsss != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"page":[NSString stringWithFormat:@"%ld",page],
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                @"warehourse":iddsss,
                @"showorder":string,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"order",@"invoicelist") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultMapList"];
            
            [DDDModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"orderItems" : [ItemsModel class],
                         };
            }];
            for (NSDictionary *temp in array) {
                DDDModel *model = [DDDModel mj_objectWithKeyValues:temp];
                AddressModel *addressmodel = [AddressModel mj_objectWithKeyValues:model.orderAddress];
                MapModel *mapmodel = [MapModel mj_objectWithKeyValues:model.map];
                model.addressmodel = addressmodel;
                model.mapmodel = mapmodel;
                [weakSelf.dataArray addObject:model];
            }
            page ++;
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf.tableview.mj_footer endRefreshing];
        }];
    }
    
}


//申请开票
- (void)lodShenQingKaiPiao:(NSString *)strIds {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (strIds != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"strIds":strIds,
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"]
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"order",@"applyInvoice") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"result_code"] isEqualToString:@"success"]) {
                NSString *str = [dic objectForKey:@"result_msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}


@end
