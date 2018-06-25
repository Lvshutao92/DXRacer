//
//  MineSixViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineSixViewController.h"
#import "LSFPCell.h"
#import "ItemsModel.h"
#import "LsfpModel.h"
#import "LSFPDetailsTableViewController.h"
#import "LSFPsearchTableViewController.h"
#import "LSFPKaipiaoViewController.h"
@interface MineSixViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,UITextFieldDelegate>
{
    NSInteger page;
    NSInteger totalNum;
    NSString *stringid;
    UIView *bgview;
    UITextField *textf;
    
    float height1;
    float height2;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation MineSixViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)clickSearch {
    LSFPsearchTableViewController *searchVC = [[LSFPsearchTableViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //self.navigationItem.rightBarButtonItem = bar;
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 30, 30) ;
    [btn1 setImage:[UIImage imageNamed:@"edittime"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickedittime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItems = @[bar1,bar];
    
    [self shizhitimezhiqian];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"LSFPCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self setUpReflash];
    [self setupvie];
}
- (void)setupvie {
    bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgview.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    bgview.hidden = YES;
    [self.view addSubview:bgview];
    [self.view bringSubviewToFront:bgview];
    UIView *iew = [[UIView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-100, SCREEN_WIDTH-60, 160)];
    iew.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:iew];
    
   
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    lab2.text = @"设置开票日期";
    [iew addSubview:lab2];
    textf = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-80, 30)];
    textf.placeholder = @" 开票日期";
    textf.delegate = self;
    textf.keyboardType = UIKeyboardTypeNumberPad;
    [textf.layer setBorderWidth:.5];
    [textf.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [iew addSubview:textf];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH-200, 110, 60, 30);
    [btn1 setTitle:@"关闭" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickcancle) forControlEvents:UIControlEventTouchUpInside];
    [iew addSubview:btn1];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(SCREEN_WIDTH-130, 110, 60, 30);
    btn2.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [btn2 setTitle:@"保存" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clicksave) forControlEvents:UIControlEventTouchUpInside];
    [iew addSubview:btn2];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [textf resignFirstResponder];
}
- (void)clickcancle{
     bgview.hidden = YES;
    self.tableview.scrollEnabled = YES;
     [textf resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSFPDetailsTableViewController *details = [[LSFPDetailsTableViewController alloc]init];
    LsfpModel *model = [self.dataArray objectAtIndex:indexPath.row];
    details.navigationItem.title = @"详情";
    details.str1 = model.mapmodel.code;
    details.str2 = model.mapmodel.addr;
    details.str3 = model.mapmodel.phone;
    details.str4 = model.mapmodel.bank;
    details.str5 = model.mapmodel.bank_no;
    details.str6 = model.mapmodel.invoice_no;
    
    details.str7 = model.mapmodel.name;
    details.str8 = model.mapmodel.phonenum;
    
    if ([model.mapmodel.province isEqual:[NSNull null]] || model.mapmodel.province == nil) {
        model.mapmodel.province = @"-";
    }
    if ([model.mapmodel.city isEqual:[NSNull null]] || model.mapmodel.city == nil) {
        model.mapmodel.city = @"-";
    }
    if ([model.mapmodel.district isEqual:[NSNull null]] || model.mapmodel.district == nil) {
        model.mapmodel.district = @"-";
    }
    if ([model.mapmodel.address isEqual:[NSNull null]] || model.mapmodel.address == nil) {
        model.mapmodel.address = @"-";
    }
    details.str9 = [NSString stringWithFormat:@"%@ %@ %@ %@",model.mapmodel.province,model.mapmodel.city,model.mapmodel.district,model.mapmodel.address];
    
    
    details.str10 = model.mapmodel.expres;
    details.str11 = model.mapmodel.logistics_no;
    details.str12 = model.mapmodel.logistics_postage;
    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  340+height1+height2;
}
#pragma mark---------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSFPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LsfpModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ItemsModel *mo = [model.orderItems firstObject];
    
    
    cell.lab1.text = model.mapmodel.order_no;
    if (model.mapmodel.type.length == 0) {
        cell.lab2.text = @"-";
    }else{
        cell.lab2.text = model.mapmodel.type;
    }
    
    
    cell.lab3.text = [NSString stringWithFormat:@"%@",[Manager jinegeshi:model.mapmodel.money]];
    cell.lab4.text = [NSString stringWithFormat:@"%@X%@",mo.skucode,mo.quantity];
    
    
    
    if (model.mapmodel.title.length == 0) {
        cell.lab5.text = @"-";
        height1 = 20;
        cell.juli1.constant = 10;
//        cell.juli2.constant = 10;
    }else {
        cell.lab5.text = model.mapmodel.title;
        cell.lab5.numberOfLines = 0;
        cell.lab5.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [cell.lab5 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
        height1 = size.height;
        cell.height1.constant = height1;
        cell.juli1.constant = height1 - 10;
//        cell.juli2.constant = 10;
    }
    
    
    
    
    
    
    
    
    
    if (model.mapmodel.code.length == 0) {
        cell.lab6.text = @"-";
    }else {
        cell.lab6.text = model.mapmodel.code;
    }
 
    
    
    if (model.mapmodel.addr.length == 0) {
        cell.lab7.text = @"-";
        height2 = 20;
    }else {
        cell.lab7.text = model.mapmodel.addr;
        cell.lab7.numberOfLines = 0;
        cell.lab7.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [cell.lab7 sizeThatFits:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT)];
        height2 = size.height;
        cell.height2.constant = height2;
    }
    cell.julis1.constant = height2 - 10;
//    cell.julis2.constant = 10;
    
    
    
    
    if (model.mapmodel.phone.length == 0) {
        cell.lab8.text = @"-";
    }else {
        cell.lab8.text = model.mapmodel.phone;
    }
    
    if (model.mapmodel.bank.length == 0) {
        cell.lab9.text = @"-";
    }else {
        cell.lab9.text = model.mapmodel.bank;
    }
    
    if (model.mapmodel.bank_no.length == 0) {
        cell.lab10.text = @"-";
    }else {
        cell.lab10.text = model.mapmodel.bank_no;
    }
    
    if (model.mapmodel.invoice_no.length == 0) {
        cell.lab11.text = @"-";
    }else {
        cell.lab11.text = model.mapmodel.invoice_no;
    }
    
    if ([model.mapmodel.status isEqualToString:@"1"]) {
        cell.lab12.text = @"未开票";
    }else if ([model.mapmodel.status isEqualToString:@"2"]) {
        cell.lab12.text = @"已开票";
    }else {
        cell.lab12.text = @"已取消";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"开票" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        LsfpModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([model.mapmodel.status isEqualToString:@"1"]) {
            if (model.mapmodel.id.length != 0) {
                [self lodGetAddress:model.mapmodel.id indexpath:indexPath];
            }
        }else if ([model.mapmodel.status isEqualToString:@"2"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该发票已开票" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该发票已取消" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    
    kaipiao.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    
  
    return @[kaipiao];
}


- (void)lodGetAddress:(NSString *)idString indexpath:(NSIndexPath *)indexpath{
    LsfpModel *model = [self.dataArray objectAtIndex:indexpath.row];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"id":idString,
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice", @"getOrderAddressInfo") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [[dicc objectForKey:@"rows"] objectForKey:@"order_address"];
        //NSLog(@"------%@",dicc);
        
        if ([[dicc objectForKey:@"result_code"]isEqualToString:@"success"]) {
           
                LSFPKaipiaoViewController *ddd = [[LSFPKaipiaoViewController alloc]init];
                ddd.navigationItem.title = @"开票";
                ddd.dingdanbianhao = model.mapmodel.order_no;
                ddd.fapiaoleixing = model.mapmodel.type;
            
                ddd.name = [dic objectForKey:@"receiver_name"];
                ddd.mobile = [dic objectForKey:@"receiver_phone"];
                ddd.shengshiqu = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"receiver_state"],[dic objectForKey:@"receiver_city"],[dic objectForKey:@"receiver_district"]];
                ddd.sheng = [dic objectForKey:@"receiver_state"];
                ddd.shi = [dic objectForKey:@"receiver_city"];
                ddd.qu = [dic objectForKey:@"receiver_district"];
                ddd.address = [dic objectForKey:@"receiver_address"];
            
                ddd.kaipiao_id = model.mapmodel.id;
                ddd.fptitle   = model.mapmodel.title;
                ddd.fpcode    = model.mapmodel.code;
                ddd.fpaddress = model.mapmodel.addr;
                ddd.fpphone   = model.mapmodel.phone;
                ddd.fpbank    = model.mapmodel.bank;
                ddd.fpbankno  = model.mapmodel.bank_no;
                //            NSLog(@"%@",model.mapmodel.expres);
                [weakSelf.navigationController pushViewController:ddd animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

}


- (void)clickedittime {
    self.tableview.scrollEnabled = NO;
    bgview.hidden = NO;
    
}
- (void)clicksave{
    
    if (stringid.length != 0 && textf.text.length != 0) {
        
        [self lodEditKaiPiaoTime:stringid];
    }else {
        
    }
}
- (void)shizhitimezhiqian {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];

    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice_time", @"innitTime") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            stringid = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"rows"] objectForKey:@"order_invoice_time"]objectForKey:@"id"]];
//            textf.placeholder = [NSString stringWithFormat:@" %@",stringid];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


- (void)lodEditKaiPiaoTime:(NSString *)strid {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                @"invoice_time":textf.text,
                @"id":strid,
                };
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice_time", @"update") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
        
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            bgview.hidden = YES;
            [textf resignFirstResponder];
            weakSelf.tableview.scrollEnabled = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开票日期设置成功" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice", @"Invoicelist") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totalNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
//        NSLog(@"=====%@",dic);
        [weakSelf.dataArray removeAllObjects];
       
        
        [LsfpModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"orderItems" : [ItemsModel class],
                     };
        }];
        for (NSDictionary *temp in arr) {
            LsfpModel *model = [LsfpModel mj_objectWithKeyValues:temp];
            LsfpDicModel *mapmodel = [LsfpDicModel mj_objectWithKeyValues:model.map];
            model.mapmodel = mapmodel;
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
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice", @"Invoicelist") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        totalNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        
        [LsfpModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"orderItems" : [ItemsModel class],
                     };
        }];
        for (NSDictionary *temp in arr) {
            LsfpModel *model = [LsfpModel mj_objectWithKeyValues:temp];
            LsfpDicModel *mapmodel = [LsfpDicModel mj_objectWithKeyValues:model.map];
            model.mapmodel = mapmodel;
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




- (void)createXLSFile {
    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    [xlsDataMuArr addObject:@"订单编号"];
    [xlsDataMuArr addObject:@"发票类型"];
    [xlsDataMuArr addObject:@"发票总金额"];
    [xlsDataMuArr addObject:@"发票抬头"];
    [xlsDataMuArr addObject:@"纳税人识别码"];
    [xlsDataMuArr addObject:@"注册地址"];
    
    [xlsDataMuArr addObject:@"注册电话"];
    [xlsDataMuArr addObject:@"开户银行"];
    [xlsDataMuArr addObject:@"银行账户"];
    [xlsDataMuArr addObject:@"发票物流公司"];
    [xlsDataMuArr addObject:@"物流单号"];
    [xlsDataMuArr addObject:@"发票运费"];
    
    [xlsDataMuArr addObject:@"发票单据号"];
    [xlsDataMuArr addObject:@"收票人"];
    [xlsDataMuArr addObject:@"收票电话"];
    [xlsDataMuArr addObject:@"收票省份"];
    [xlsDataMuArr addObject:@"收票城市"];
    [xlsDataMuArr addObject:@"收票区域"];
    [xlsDataMuArr addObject:@"收票地址"];
    [xlsDataMuArr addObject:@"发票状态"];
    
    
    // 100行数据
    for (int i = 0; i < 1; i ++) {
        if (i == 0) {
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
        }
    }
    // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
    NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
    // 字符串转换为可变字符串，方便改变某些字符
    NSMutableString *muStr = [fileContent mutableCopy];
    // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
    NSMutableArray *subMuArr = [NSMutableArray array];
    for (int i = 0; i < muStr.length; i ++) {
        NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
        if (range.length == 1) {
            [subMuArr addObject:@(range.location)];
        }
    }
    // 替换末尾\t
    for (NSUInteger i = 0; i < subMuArr.count; i ++) {
    //20列数
        if ( i > 0 && (i%20 == 0) ) {
            [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
        }
    }
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/export.xls"];
    NSLog(@"文件路径：\n%@",filePath);
    // 生成xls文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    
    //导出xls文件
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    self.documentInteractionController.delegate = self;
    [self.documentInteractionController presentPreviewAnimated:YES];
    
}

- ( UIViewController *)documentInteractionControllerViewControllerForPreview:( UIDocumentInteractionController *)interactionController
{
    return self;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}




@end
