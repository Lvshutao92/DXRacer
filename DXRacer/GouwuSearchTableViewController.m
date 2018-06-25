//
//  GouwuSearchTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "GouwuSearchTableViewController.h"

#import "GoodsDetailsViewController.h"
#import "ITEMCell.h"
#import "ItemModel.h"
#import "PurchaseCarAnimationTool.h"

@interface GouwuSearchTableViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *headerview;
    UIButton *btn;
    
    UITextField *itemtextfield1;
    UITextField *itemtextfield2;
    UITextField *itemtextfield3;
    UITextField *itemtextfield4;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    
     NSInteger page;
     NSInteger totalNum;
    BOOL itemisno;
    UIButton *btn3;
}
@property (strong , nonatomic) UIImageView *imageView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UITableView *tableview;
@end

@implementation GouwuSearchTableViewController
- (void)clickback {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clicksearch {
    [itemtextfield1 resignFirstResponder];
    [itemtextfield2 resignFirstResponder];
    [itemtextfield3 resignFirstResponder];
    [itemtextfield4 resignFirstResponder];
    
    if (itemtextfield4.text.length == 0) {
        itemtextfield4.text = @" ";
    }
    if (itemtextfield3.text.length == 0) {
        itemtextfield3.text = @" ";
    }
    if (itemtextfield2.text.length == 0) {
        itemtextfield2.text = @" ";
    }
    if (itemtextfield1.text.length == 0) {
        itemtextfield1.text = @" ";
    }
    lab1.hidden = YES;
    lab2.hidden = YES;
    lab3.hidden = YES;
    lab4.hidden = YES;
    btn3.hidden = YES;
    itemtextfield1.hidden = YES;
    itemtextfield2.hidden = YES;
    itemtextfield3.hidden = YES;
    itemtextfield4.hidden = YES;
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
    self.tableview.tableHeaderView = headerview;
    itemisno = !itemisno;
    
    [self.view bringSubviewToFront:btn];
    [self setUpReflash];
}

//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loditem];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totalNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loditem2];
        }
    }];
}


- (void)loditem {
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page],
            @"skucode":itemtextfield1.text,
            @"bizcode":itemtextfield2.text,
            @"skuname":itemtextfield3.text,
            @"productcode":itemtextfield4.text,
            };
    //NSLog(@"%@",dic);
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"partner_price", @"partner_priceList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];

        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
        //NSLog(@"ITEM====%@",dic);
       
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *temp in array) {
            ItemModel *model = [ItemModel mj_objectWithKeyValues:temp];
            MpModel *tempModel = [MpModel mj_objectWithKeyValues:model.map];
            model.model = tempModel;
            [weakSelf.dataArray addObject:model];
        }
        page = 2;
        [weakSelf.tableview reloadData];
        weakSelf.tableview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

        [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        weakSelf.tableview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    }];
}
- (void)loditem2 {
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page],
            @"skucode":itemtextfield1.text,
            @"bizcode":itemtextfield2.text,
            @"skuname":itemtextfield3.text,
            @"productcode":itemtextfield4.text,
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"partner_price", @"partner_priceList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
        //NSLog(@"ITEM====%@",dic);
        
        for (NSDictionary *temp in array) {
            ItemModel *model = [ItemModel mj_objectWithKeyValues:temp];
            MpModel *tempModel = [MpModel mj_objectWithKeyValues:model.map];
            model.model = tempModel;
            [weakSelf.dataArray addObject:model];
        }
        page ++;
        [weakSelf.tableview reloadData];
         [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}



- (void)addShoppingcart:(NSString *)skucode{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"sku_code":skucode,
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"amount":@"1",
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]};
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"shoppingcart", @"addBySkuCode") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        //        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
        //        NSLog(@"ITEM----Shoppingcart====%@",dic);
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}






-(void)clickCar
{
    
    [[PurchaseCarAnimationTool shareTool]startAnimationandView:_imageView andRect:_imageView.frame andFinisnRect:CGPointMake(ScreenWidth/4*2.5, ScreenHeight-49) andFinishBlock:^(BOOL finish) {
        [PurchaseCarAnimationTool shakeAnimation:btn];
    }];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"物品检索";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(0, 0, 30, 30);
//    [btn1 setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    self.navigationItem.leftBarButtonItem = bar;
    
//    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchbtn.frame = CGRectMake(0, 0, 30, 30) ;
//    [searchbtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [searchbtn addTarget:self action:@selector(clicksearch) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *searchbar = [[UIBarButtonItem alloc]initWithCustomView:searchbtn];
//    self.navigationItem.rightBarButtonItem = searchbar;
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/2+30, SCREEN_HEIGHT-100*SCALE_HEIGHT, 50, 50);
    UIImage *theImage = [UIImage imageNamed:@"3"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:theImage forState:UIControlStateNormal];
    [btn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [btn addTarget:self action:@selector(clickStipShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.tableview registerClass:[ITEMCell class] forCellReuseIdentifier:@"cellitem"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .01)];
    self.tableview.tableFooterView = vi;
    
    
    headerview = [[UIView alloc]init];
    headerview.backgroundColor = RGBACOLOR(42, 162, 153, 1.0);
    [self.view addSubview:btn];
    [self setupview];
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    [self.tableview reloadData];
}
- (void)setupview {
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
    
    self.tableview.tableHeaderView = headerview;
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    
    [btn2 setTitle:@"请输入检索信息" forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.backgroundColor = RGBACOLOR(42, 162, 153, 1.0);
    [btn2 addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [btn2.layer setBorderWidth:1];
    [btn2.layer setBorderColor:[UIColor colorWithWhite:.8 alpha:.25].CGColor];
    [headerview addSubview:btn2];
    
    for (int i = 0; i<4; i++) {
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20, 50+10*(i+1)+30*i, 100, 30)];
        switch (i) {
            case 0:
                lab1 = la;
                lab1.text = @"ITEMNO";
                break;
            case 1:
                lab2 = la;
                lab2.text = @"FCNO";
                break;
            case 2:
                lab3 = la;
                lab3.text = @"ITEM NAME";
                break;
            case 3:
                lab4 = la;
                lab4.text = @"MODEL";
                break;
            default:
                break;
        }
        la.hidden = YES;
        la.textColor = [UIColor whiteColor];
        [headerview addSubview:la];
    }
        for (int i = 0; i<4; i++) {
            UITextField *textf = [[UITextField alloc]initWithFrame:CGRectMake(125, 50+10*(i+1)+30*i, SCREEN_WIDTH-145, 30)];
            switch (i) {
                case 0:
                    itemtextfield1 = textf;
                    itemtextfield1.placeholder = @" ITEMNO";
                    break;
                case 1:
                    itemtextfield2 = textf;
                    itemtextfield2.placeholder = @" FCNO";
                    break;
                case 2:
                    itemtextfield3 = textf;
                    itemtextfield3.placeholder = @" ITEM NAME";
                    break;
                case 3:
                    itemtextfield4 = textf;
                    itemtextfield4.placeholder = @" MODEL";
                    break;
                default:
                    break;
            }
            textf.hidden = YES;
            textf.delegate = self;
            [textf.layer setBorderWidth:.5];
            [textf.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:1].CGColor];
            textf.borderStyle = UITextBorderStyleRoundedRect;
            textf.layer.masksToBounds = YES;
            textf.layer.cornerRadius = 5;
            [headerview addSubview:textf];
        }
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(20, 220, SCREEN_WIDTH-40, 40);
    
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



- (void)click{
    
     [itemtextfield1 resignFirstResponder];
     [itemtextfield2 resignFirstResponder];
     [itemtextfield3 resignFirstResponder];
     [itemtextfield4 resignFirstResponder];
        if (itemisno == NO) {
            lab1.hidden = NO;
            lab2.hidden = NO;
            lab3.hidden = NO;
            lab4.hidden = NO;
            itemtextfield1.hidden = NO;
            itemtextfield2.hidden = NO;
            itemtextfield3.hidden = NO;
            itemtextfield4.hidden = NO;
            btn3.hidden = NO;
            headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270) ;
            self.tableview.tableHeaderView = headerview;
        }else {
            lab1.hidden = YES;
            lab2.hidden = YES;
            lab3.hidden = YES;
            lab4.hidden = YES;
            btn3.hidden = YES;
            itemtextfield1.hidden = YES;
            itemtextfield2.hidden = YES;
            itemtextfield3.hidden = YES;
            itemtextfield4.hidden = YES;
            headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
            self.tableview.tableHeaderView = headerview;
        }
        itemisno = !itemisno;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
        return 150;
    }else {
        return 200;
    }
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITEMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellitem" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.labone.text   = model.model.skucode;
    cell.labtwo.text   = [NSString stringWithFormat:@"供货价：%@",[Manager jinegeshi:model.model.realprice]];
    cell.labthree.text = [NSString stringWithFormat:@"官方价：%@",[Manager jinegeshi:model.model.price]];
    cell.labfour.text  = model.inventorys;
    cell.labfive.text  = model.model.skuname;
    
    
    NSMutableAttributedString *notestr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"供货价：%@",[Manager jinegeshi:model.model.realprice]]];
    NSRange ran = NSMakeRange(0, 4);
    [notestr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran];
    [cell.labtwo setAttributedText:notestr];
    
    NSMutableAttributedString *notestr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"官方价：%@",[Manager jinegeshi:model.model.price]]];
    NSRange ran1 = NSMakeRange(0, 4);
    [notestr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran1];
    [cell.labthree setAttributedText:notestr1];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.imageViewpic sd_setImageWithURL:[NSURL URLWithString:NSString(model.model.img_url)]];
    });
    cell.clickCars = ^(UIImageView *imageView){
        [self addShoppingcart:model.model.skucode];
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        //获取当前cell 相对于self.view 当前的坐标
        rect.origin.y = rect.origin.y - [tableView contentOffset].y;
        CGRect imageViewRect = imageView.frame;
        imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y+50;
        [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageView andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/4*2.5, ScreenHeight-69) andFinishBlock:^(BOOL finisn){
            [PurchaseCarAnimationTool shakeAnimation:btn];
        }];
    };
    
    return cell;
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
- (void)clickStipShoppingCart {
    self.tabBarController.selectedIndex = 2;
    self.tabBarController.tabBar.hidden = NO;
}
@end
