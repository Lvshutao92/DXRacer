//
//  LSFPsearchTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "LSFPsearchTableViewController.h"
#import "LSFPCell.h"
#import "ItemsModel.h"
#import "LsfpModel.h"
#import "LSFPDetailsTableViewController.h"

#import "LSFPKaipiaoViewController.h"
#import "SQMenuShowView.h"

@interface LSFPsearchTableViewController ()<UITextFieldDelegate>
{
        UIView *headerview;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    
        UITextField *textfield1;
        UITextField *textfield2;
        UITextField *textfield3;
    
        NSInteger page;
        NSInteger totalNum;
        NSString *stringid;
        UIView *bgview;
        UITextField *textf;
        BOOL isno;
    
    float height1;
    float height2;
    UIButton *btn3;

}
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property(nonatomic, strong)SQMenuShowView *showView1;
@property(nonatomic, assign)BOOL isShow1;
@end

@implementation LSFPsearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发票检索";
    [self.tableView registerNib:[UINib nibWithNibName:@"LSFPCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchbtn.frame = CGRectMake(0, 0, 30, 30) ;
//    [searchbtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [searchbtn addTarget:self action:@selector(clicksearch) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *searchbar = [[UIBarButtonItem alloc]initWithCustomView:searchbtn];
//    self.navigationItem.rightBarButtonItem = searchbar;
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .01)];
    self.tableView.tableFooterView = vi;
    [self shizhitimezhiqian];
    headerview = [[UIView alloc]init];
    headerview.backgroundColor = RGBACOLOR(42, 162, 153, 1.0);
    
    
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        [weakSelf setupbutton:index];
        [self.view bringSubviewToFront:_showView];
        
    }];
    [self.showView1 selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow1 = NO;
        [weakSelf setupbutton1:index];
        [self.view bringSubviewToFront:_showView1];
        
    }];
    [self setupview];
    [self setupvie];
    
}

//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totalNum) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodSL];
        }
    }];
}
- (void)lodXL {
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    if ([textfield3.text isEqualToString:@"全部"]) {
        textfield3.text = @" ";
    }
    if (textfield2.text.length == 0) {
        textfield2.text = @" ";
    }
    if ([textfield1.text isEqualToString:@"全部"]) {
        textfield1.text = @" ";
    }
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"page":[NSString stringWithFormat:@"%ld",page],
            @"status":textfield1.text,
            @"order_no":textfield2.text,
            @"detail":textfield3.text,
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
        [weakSelf.tableView reloadData];
        weakSelf.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }];
}
- (void)lodSL {
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    if ([textfield3.text isEqualToString:@"全部"]) {
        textfield3.text = @" ";
    }
    if (textfield2.text.length == 0) {
        textfield2.text = @" ";
    }
    if ([textfield1.text isEqualToString:@"全部"]) {
        textfield1.text = @" ";
    }
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"page":[NSString stringWithFormat:@"%ld",page],
            @"status":textfield1.text,
            @"order_no":textfield2.text,
            @"detail":textfield3.text,
            };
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
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


- (void)click{
    [self.showView dismissView];
    [self.showView1 dismissView];
    [textfield2 resignFirstResponder];
    if (isno == NO) {
        lab1.hidden = NO;
        lab2.hidden = NO;
        lab3.hidden = NO;
        textfield1.hidden = NO;
        textfield2.hidden = NO;
        textfield3.hidden = NO;
        btn3.hidden = NO;
        headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230) ;
        self.tableView.tableHeaderView = headerview;
    }else {
        lab1.hidden = YES;
        lab2.hidden = YES;
        lab3.hidden = YES;
        textfield1.hidden = YES;
        textfield2.hidden = YES;
        textfield3.hidden = YES;
        btn3.hidden = YES;
        headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
        self.tableView.tableHeaderView = headerview;
    }
    isno = !isno;
}
- (void)clicksearch {
    [self.showView dismissView];
    [self.showView1 dismissView];
    [textfield2 resignFirstResponder];
    
    
   
    textfield3.hidden = YES;
    textfield2.hidden = YES;
    textfield1.hidden = YES;
    lab1.hidden = YES;
    lab2.hidden = YES;
    lab3.hidden = YES;
    btn3.hidden = YES;
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
    self.tableView.tableHeaderView = headerview;
    isno = !isno;
  
    [self setUpReflash];
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
    
    
    UILabel *lab9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    lab9.text = @"设置开票日期";
    [iew addSubview:lab9];
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
    self.tableView.scrollEnabled = YES;
    bgview.hidden = YES;
    [textf resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"开票" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableView.editing = NO;
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
    [textfield2 resignFirstResponder];
    if (self.dataArray.count > 0) {
        bgview.hidden = NO;
        self.tableView.scrollEnabled = NO;
    }
}
- (void)clicksave{
    [textfield2 resignFirstResponder];
    if (stringid.length != 0 && textf.text.length != 0) {
        
        [self lodEditKaiPiaoTime:stringid];
    }else {
        
    }
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
            weakSelf.tableView.scrollEnabled = YES;
            [textf resignFirstResponder];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开票日期设置成功" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 340+height1+height2;
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


- (SQMenuShowView *)showView{
    if (_showView) {
        return _showView;
    }
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){90,92,SCREEN_WIDTH-100,120}
                                               items:@[@"全部",@"未开票",@"已开票"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-60,120}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    [self.view bringSubviewToFront:_showView];
    return _showView;
}
- (void)setupbutton:(NSInteger )index{
    if (index == 0) {
        textfield1.text = @"全部";
    }
    if (index == 1) {
        textfield1.text = @"未开票";
    }
    if (index == 2) {
        textfield1.text = @"已开票";
    }
}
- (SQMenuShowView *)showView1{
    if (_showView1) {
        return _showView1;
    }
    _showView1 = [[SQMenuShowView alloc]initWithFrame:(CGRect){90,172,SCREEN_WIDTH-100,80}
                                                items:@[@"全部",@"电脑椅",@"办公椅",@"配件"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-60,160}];
    _showView1.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView1];
    [self.view bringSubviewToFront:_showView1];
    return _showView1;
}
- (void)setupbutton1:(NSInteger )index{
    if (index == 0) {
        textfield3.text = @"全部";
    }
    if (index == 1) {
        textfield3.text = @"电脑椅";
    }
    if (index == 2) {
        textfield3.text = @"办公椅";
    }
    if (index == 3) {
        textfield3.text = @"配件";
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:textfield1]) {
        [self.showView1 dismissView];
        [textfield2 resignFirstResponder];
        _isShow = !_isShow;
        if (_isShow) {
            [self.view bringSubviewToFront:self.showView];
            [self.showView showViewlsfpsearch1];
        }else{
            [self.showView dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield2]){
        [self.showView dismissView];
        [self.showView1 dismissView];
        return YES;
    }
    if ([textField isEqual:textfield3]) {
        [self.showView dismissView];
        [textfield2 resignFirstResponder];
        _isShow1 = !_isShow1;
        if (_isShow1) {
            [self.view bringSubviewToFront:self.showView1];
            [self.showView1 showViewlsfpsearch2];
        }else{
            [self.showView1 dismissView];
        }
        return NO;
    }
   
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)setupview {
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
    self.tableView.tableHeaderView = headerview;
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 50);
    [btn0 setTitle:@"设置开票日期" forState:UIControlStateNormal];
    btn0.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn0.backgroundColor = RGBACOLOR(42, 162, 153, 1.0);
    [btn0 addTarget:self action:@selector(clickedittime) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:btn0];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 0, 1, 50)];
    lab.backgroundColor = [UIColor whiteColor];
    [headerview addSubview:lab];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50);
    
    [btn2 setTitle:@"请输入检索信息" forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.backgroundColor = RGBACOLOR(42, 162, 153, 1.0);
    [btn2 addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:btn2];
    
    
    for (int i = 0; i<3; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50+10*(i+1)+30*i, 80, 30)];
        switch (i) {
            case 0:
                lab1 = lab;
                lab1.text = @"发票状态";
                break;
            case 1:
                lab2 = lab;
                lab2.text = @"订单编号";
                break;
            case 2:
                lab3 = lab;
                lab3.text = @"发票明细";
                break;
            default:
                break;
        }
        lab.hidden = YES;
        lab.textColor = [UIColor whiteColor];
        [headerview addSubview:lab];
    }
    
    for (int i = 0; i<3; i++) {
        UITextField *tex = [[UITextField alloc]initWithFrame:CGRectMake(90, 50+10*(i+1)+30*i, SCREEN_WIDTH-100, 30)];
        switch (i) {
            case 0:
                textfield1 = tex;
                textfield1.text = @"全部";
//                textfield1.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
                break;
            case 1:
                textfield2 = tex;
                textfield2.placeholder = @"订单编号";
                break;
            case 2:
                textfield3 = tex;
                textfield3.text = @"全部";
//                textfield3.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
                break;
            default:
                break;
        }
        tex.hidden = YES;
        tex.delegate = self;
        [tex.layer setBorderWidth:.5];
        [tex.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:1].CGColor];
        tex.borderStyle = UITextBorderStyleRoundedRect;
        tex.layer.masksToBounds = YES;
        tex.layer.cornerRadius = 5;
        [headerview addSubview:tex];
    }
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(20, 180, SCREEN_WIDTH-40, 40);
    
    [btn3 setTitle:@"开始检索" forState:UIControlStateNormal];
    btn3.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor colorWithWhite:.8 alpha:.25];
    btn3.hidden = YES;
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 5;
    [btn3 addTarget:self action:@selector(clicksearch) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:btn3];
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


@end
