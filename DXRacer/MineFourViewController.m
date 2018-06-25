//
//  MineFourViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineFourViewController.h"
#import "SQMenuShowView.h"
#import "ZJLSViewController.h"
#import "FKZHGLViewController.h"
#import "KKPDDViewController.h"
#import "WDFPViewController.h"
#import "MineFourModel.h"
#import "MinefourCell.h"
#import "LookPictureController.h"
#import "AddOrEditController.h"

@interface MineFourViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSInteger totalNum;
    UILabel *lab1;
    UILabel *lab;
    
    float height1;
    float height2;
}
@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property (assign, nonatomic)NSInteger num;
@property(nonatomic, assign)NSInteger indexNum;

@property(nonatomic, strong)ZJLSViewController *zjls;
@property(nonatomic, strong)FKZHGLViewController *fkzhgl;
@property(nonatomic, strong)KKPDDViewController *kkpdd;
@property(nonatomic, strong)WDFPViewController *wdfp;

@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MineFourViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setbtn];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"MinefourCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    vie.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.tableview.tableHeaderView = vie;
    
    
    
    lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
    lab.textColor = RGBACOLOR(32, 157, 149, 1.0);
    lab.textAlignment = NSTextAlignmentRight;
    [vie addSubview:lab];
    
    lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lab1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [vie addSubview:lab1];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    btn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickadd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.num = 0;
    self.indexNum = 0;
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
         [self setupbutton:index];
         [self.view bringSubviewToFront:view];
    }];
    
    [self setUpReflash];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
//    [self setUpReflash];
    [self lodHuiZong];
}

#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 335+height2+height1;
}
#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MinefourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MineFourModel *model =  [self.dataArray objectAtIndex:indexPath.row];
    [cell.btn setTitleColor:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forState:UIControlStateNormal];
    
    [cell.btn addTarget:self action:@selector(clickLookPicture:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn.tag = indexPath.row;
    cell.lab1.text = model.topuptype;
    cell.lab2.text = model.paytype;
    cell.lab3.text = model.payaccount;
    cell.lab3.numberOfLines=0;
    cell.lab3.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.lab3 sizeThatFits:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT)];
    height1 = size.height;
    cell.height1.constant = height1;
    cell.juli1.constant = height1 -10;
//    cell.juil2.constant = 10;
    
    
    
    cell.lab4.text  = [Manager jinegeshi:model.amount];
    cell.lab5.text  = [Manager digitUppercase:model.amount];
    cell.lab6.text = model.coltype;
    cell.lab7.text = model.colaccount;
     cell.lab7.numberOfLines=0;
    cell.lab7.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [cell.lab7 sizeThatFits:CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT)];
    height2 = size1.height;
    cell.height2.constant = height2;
    cell.julis1.constant = height2 -10;
//    cell.julis2.constant = 10;
    
    
    if ([model.status isEqualToString:@"A"]) {
        cell.lab8.text  = @"已创建";
    }else if ([model.status isEqualToString:@"B"]){
        cell.lab8.text  = @"已确认";
    }else if ([model.status isEqualToString:@"Y"]){
        cell.lab8.text  = @"财务审核通过";
    }else {
        cell.lab8.text  = @"财务审核未通过";
    }
    
    
    if (model.paytype.length ==0) {
        cell.lab9.text  = @"-";
    }else{
        cell.lab9.text  = model.payremark;
    }
    
    
    
    
    
   
    cell.lab10.text  = [Manager timezhuanhuan:model.createime];
     cell.lab11.text = [Manager timezhuanhuan:model.updatetime];
    return cell;
}

- (void)clickLookPicture:(UIButton *)sender {
    MinefourCell *cell = (MinefourCell *)[[sender superview]superview];
    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    MineFourModel *model =  [self.dataArray objectAtIndex:indexpath.row];
    LookPictureController *look = [[LookPictureController alloc]init];
    look.str = model.certificateurl;
    [self presentViewController:look animated:YES completion:nil];
}

//刷新数据
-(void)setUpReflash{
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
        totalNum = [[dic objectForKey:@"total"] integerValue];
        page = 2;
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *dic in arr) {
          MineFourModel *model =  [MineFourModel mj_objectWithKeyValues:dic];
          [weakSelf.dataArray addObject:model];
        }
    
        [self lodHuiZong];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
            MineFourModel *model =  [MineFourModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}
//汇总
- (void)lodHuiZong {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"topup",@"getAmount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSNumber *number = [[dic objectForKey:@"rows"] objectForKey:@"totalamount"];
        
        NSString *str=[Manager jinegeshi:[NSString stringWithFormat:@"%@",number]];
        NSMutableAttributedString *notestr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"充值统计   %@",str]];
        NSRange ran1 = NSMakeRange(0, 7);
        [notestr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran1];
        [lab setAttributedText:notestr1];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//删除
- (void)lodShanChu:(NSString *)L_id indexpath:(NSIndexPath *)indexpath{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (L_id != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"id":L_id,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"topup",@"delete") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                
                [weakSelf.dataArray removeObjectAtIndex:indexpath.row];
                [weakSelf.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"只能删除‘已创建’状态的条目" message:@"温馨提示" preferredStyle:1];
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
//余额充值列表审核
- (void)lodEnsure:(NSString *)L_id indexpath:(NSIndexPath *)indexpath{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (L_id.length != 0) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"id":L_id,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"topup",@"auditTopup") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            //        NSLog(@"++++++%@",[dic objectForKey:@"result_msg"]);
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已确认" message:@"温馨提示" preferredStyle:1];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
                [weakSelf setUpReflash];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已确认通过,不能二次确认！" message:@"温馨提示" preferredStyle:1];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *suer = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"确认" handler:^(UITableViewRowAction * _Nonnull sure, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
         MineFourModel *model =  [self.dataArray objectAtIndex:indexPath.row];
         [self lodEnsure:model.id indexpath:indexPath];
    }];
    suer.backgroundColor = RGBACOLOR(254, 91, 91, 1.0);
    UITableViewRowAction *dele = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull dele, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MineFourModel *model =  [self.dataArray objectAtIndex:indexPath.row];
            [self lodShanChu:model.id indexpath:indexPath];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ac];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
    dele.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull edit, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        
        MineFourModel *model =  [self.dataArray objectAtIndex:indexPath.row];
        if ([model.status isEqualToString:@"A"]) {
            AddOrEditController *bianji = [[AddOrEditController alloc]init];
            bianji.navigationItem.title = @"编辑";
            bianji.str             = @"bianji";
            
            bianji.strid           = model.id;
            bianji.strimg          = model.certificateurl;
            
            bianji.str1 = model.topuptype;
            bianji.str2 = model.amount;
            bianji.str3 = model.paytype;
            bianji.str4 = model.payaccount;
            bianji.str5 = model.coltype;
            bianji.str6 = model.colaccount;
            bianji.str7   = model.payremark;
            [self.navigationController pushViewController:bianji animated:YES];
        }else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"只能修改‘已创建’的条目" message:@"温馨提示" preferredStyle:1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    edit.backgroundColor = RGBACOLOR(39, 194, 183, 1.0);
    
    return @[suer,dele,edit];
}


- (void)clickadd {
    AddOrEditController *add = [[AddOrEditController alloc]init];
    add.navigationItem.title = @"新增";
    [self.navigationController pushViewController:add animated:YES];
}





- (void)clickSearch {
//    SeachShoopingTableViewController *searchVC = [[SeachShoopingTableViewController alloc]init];
//    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:searchVC];
//    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:na animated:YES completion:nil];
}

- (void)clickSelected{
    _isShow = !_isShow;
    if (_isShow) {
        [self.showView showView];
    }else{
        [self.showView dismissView];
    }
}
- (void)setupbutton:(NSInteger )index{
    self.num = index;
    if (index == 0) {
        
            [self.zjls.view removeFromSuperview];
            [self.fkzhgl.view removeFromSuperview];
            [self.kkpdd.view removeFromSuperview];
            [self.wdfp.view removeFromSuperview];
        
        self.navigationItem.title = @"余额充值";
        self.indexNum = 0;
    }
    if (index == 1) {
        [self.zjls.view removeFromSuperview];
        [self.fkzhgl.view removeFromSuperview];
        [self.kkpdd.view removeFromSuperview];
        [self.wdfp.view removeFromSuperview];
        self.navigationItem.title = @"资金流水";
        self.zjls = [[ZJLSViewController alloc]init];
        [self.view addSubview:self.zjls.view];
        self.indexNum = 1;
    }
    if (index == 2) {
        [self.zjls.view removeFromSuperview];
        [self.fkzhgl.view removeFromSuperview];
        [self.kkpdd.view removeFromSuperview];
        [self.wdfp.view removeFromSuperview];
        self.navigationItem.title = @"付款账户管理";
        self.fkzhgl = [[FKZHGLViewController alloc]init];
        [self.view addSubview:self.fkzhgl.view];
        self.indexNum = 2;
    }
    if (index == 3) {
        [self.zjls.view removeFromSuperview];
        [self.fkzhgl.view removeFromSuperview];
        [self.kkpdd.view removeFromSuperview];
        [self.wdfp.view removeFromSuperview];
        self.navigationItem.title = @"可开票订单";
        self.kkpdd = [[KKPDDViewController alloc]init];
        [self.view addSubview:self.kkpdd.view];
        self.indexNum = 3;
    }
    if (index == 4) {
        [self.zjls.view removeFromSuperview];
        [self.fkzhgl.view removeFromSuperview];
        [self.kkpdd.view removeFromSuperview];
        [self.wdfp.view removeFromSuperview];
        self.navigationItem.title = @"我的发票";
        self.wdfp = [[WDFPViewController alloc]init];
        [self.view addSubview:self.wdfp.view];
        self.indexNum = 4;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isShow = NO;
    [self.showView dismissView];
}
- (SQMenuShowView *)showView{
    if (_showView) {
        return _showView;
    }    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64,100,250}
                                               items:@[@"余额充值",@"资金流水",@"付款账户管理",@"可开票订单",@"我的发票"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-35,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (void)setbtn {
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 30, 30) ;
    [editbtn setImage:[UIImage imageNamed:@"change3"] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 30, 30) ;
//    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = bar;
}


@end
