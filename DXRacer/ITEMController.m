//
//  ITEMController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ITEMController.h"
#import "GoodsDetailsViewController.h"
#import "ITEMCell.h"
#import "ItemModel.h"
#import "PurchaseCarAnimationTool.h"

@interface ITEMController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *btn;
    NSInteger totolNum;
    NSInteger page;
}
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (strong , nonatomic) UIImageView *imageView;
@end

@implementation ITEMController

- (void)clickStipShoppingCart {
    self.tabBarController.selectedIndex = 2;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
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
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-108)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    
    
    [self.tableview registerClass:[ITEMCell class] forCellReuseIdentifier:@"cellitem"];
    [self.view addSubview:self.tableview];
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableview.tableFooterView = vie;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/2+30, SCREEN_HEIGHT-180*SCALE_HEIGHT, 70, 70);
    UIImage *theImage = [UIImage imageNamed:@"3"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:theImage forState:UIControlStateNormal];
    [btn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];    
    [btn addTarget:self action:@selector(clickStipShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self setUpReflash];
}


//- (void)clickAddShoppingCurt:(UIButton *)sender {
//    ITEMCell *cell = (ITEMCell *)[[sender superview]superview];
//    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
//    NSLog(@"---%ld",indexpath.row);
//    [btn setImage:[UIImage imageNamed:@"bg3"] forState:UIControlStateNormal];
//}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITEMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellitem" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.labone.text   = model.model.skucode;
    
    cell.labtwo.text   = [NSString stringWithFormat:@"供货价：%@", [Manager jinegeshi:model.model.realprice]];
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
        [[PurchaseCarAnimationTool shareTool]startAnimationandView:imageView andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/4*2.5, ScreenHeight-49) andFinishBlock:^(BOOL finisn){
            [PurchaseCarAnimationTool shakeAnimation:btn];
        }];
    };

    return cell;
}

- (void)addShoppingcart:(NSString *)skucode{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}






-(void)clickCar
{
    
    [[PurchaseCarAnimationTool shareTool]startAnimationandView:_imageView andRect:_imageView.frame andFinisnRect:CGPointMake(ScreenWidth/4*2.5, ScreenHeight-49) andFinishBlock:^(BOOL finish) {
        [PurchaseCarAnimationTool shakeAnimation:btn];
    }];
}


//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loddeItemList];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totolNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodXLItems];
        }
    }];
}
- (void)loddeItemList {
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],@"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],@"page":[NSString stringWithFormat:@"%ld",page]};
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    
    NSString *jsonStr = [Manager encodeBase64String:str];
    
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    
    [session POST:KURLNSString(@"partner_price", @"partner_priceList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
//        NSLog(@"ITEM====%@",dic);
        totolNum = [[dic objectForKey:@"total"] integerValue];
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *temp in array) {
            ItemModel *model = [ItemModel mj_objectWithKeyValues:temp];
            MpModel *tempModel = [MpModel mj_objectWithKeyValues:model.map];
            model.model = tempModel;
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
- (void)lodXLItems {
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],@"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],@"page":[NSString stringWithFormat:@"%ld",page]};
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    
    NSString *jsonStr = [Manager encodeBase64String:str];
    
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    
    [session POST:KURLNSString(@"partner_price", @"partner_priceList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
        //        NSLog(@"ITEM====%@",dic);
        
        
        for (NSDictionary *temp in array) {
            ItemModel *model = [ItemModel mj_objectWithKeyValues:temp];
            MpModel *tempModel = [MpModel mj_objectWithKeyValues:model.map];
            model.model = tempModel;
            [weakSelf.dataArray addObject:model];
        }
        page++;
        [weakSelf.tableview reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}


@end
