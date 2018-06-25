//
//  MODELController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MODELController.h"
#import "GoodsDetailsViewController.h"
#import "MODELCell.h"
#import "ModeModel.h"
#import "ProductModel.h"
#import "SkuimgModel.h"

@interface MODELController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger totolNum;
    NSInteger page;
}
@property(nonatomic, strong)UICollectionView *collectionview;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *imgdataArray;



@end

@implementation MODELController
- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (NSMutableArray *)imgdataArray {
    if (_imgdataArray == nil) {
        self.imgdataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imgdataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self setUpReflash];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/2-25, 220);
    //最小行间距(默认为10)
    layout.minimumLineSpacing = 10;
    //最小item间距（默认为10）
    layout.minimumInteritemSpacing = 10;
    //设置senction的内边距
    layout.sectionInset = UIEdgeInsetsMake(5, 20, 0, 15);
    
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100*SCALE_HEIGHT) collectionViewLayout:layout];
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    _collectionview.backgroundColor = [UIColor colorWithWhite:.9 alpha:.15];
    [_collectionview registerClass:[MODELCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionview];
}
#pragma mark---------UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsDetailsViewController *goods = [[GoodsDetailsViewController alloc]init];
    ModeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    goods.str1    = model.model.productcode;
    goods.str2    = model.model.catalog;
    goods.str3    = model.model.brand;
    goods.str4    = model.model.packagessize;
    goods.strType = model.model.type;
    
    goods.S_business_id = model.model.business_id;
    goods.S_id = model.model.id;
   
    
    goods.arr = [self.imgdataArray objectAtIndex:indexPath.row];
    [Manager sharedManager].totolimgArray = nil;
    [self.navigationController pushViewController:goods animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark---------UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MODELCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ModeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    SkuimgModel *dicmodel = [model.skuimgList firstObject];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:NSString(dicmodel.img_url)]];        
    });
    cell.lable.text = model.model.productcode;
    return cell;
}

//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loddetail];
    }];
    [self.collectionview.mj_header beginRefreshing];
    self.collectionview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totolNum) {
            [self.collectionview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
        [weakSelf lodXLdetail];
        }
    }];
}
- (void)loddetail {
    [self.collectionview.mj_footer endRefreshing];
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
    
    [session POST:KURLNSString(@"product", @"productList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *rows = [dic objectForKey:@"rows"] ;
        NSArray *resultList = [rows objectForKey:@"resultList"];
        
        
        totolNum = [[dic objectForKey:@"total"] integerValue];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.imgdataArray removeAllObjects];
        [ModeModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"skuimgList" : [SkuimgModel class],
                     };
        }];
        for (NSDictionary *temp in resultList) {
            ModeModel *model = [ModeModel mj_objectWithKeyValues:temp];
            ProductModel *tempModel = [ProductModel mj_objectWithKeyValues:model.product];
            model.model = tempModel;
            [weakSelf.dataArray addObject:model];
        }
        for (ModeModel *model in weakSelf.dataArray) {
            [weakSelf.imgdataArray addObject:model.skuimgList];
        }
        page = 2;
        [weakSelf.collectionview reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.collectionview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.collectionview.mj_header endRefreshing];
    }];
}

- (void)lodXLdetail {
    [self.collectionview.mj_header endRefreshing];
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
    
    [session POST:KURLNSString(@"product", @"productList") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *rows = [dic objectForKey:@"rows"] ;
        NSArray *resultList = [rows objectForKey:@"resultList"];
        [weakSelf.imgdataArray removeAllObjects];
        [ModeModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"skuimgList" : [SkuimgModel class],
                     };
        }];
        for (NSDictionary *temp in resultList) {
            ModeModel *model = [ModeModel mj_objectWithKeyValues:temp];
            ProductModel *tempModel = [ProductModel mj_objectWithKeyValues:model.product];
            model.model = tempModel;
            [weakSelf.dataArray addObject:model];
        }
        for (ModeModel *model in weakSelf.dataArray) {
            [weakSelf.imgdataArray addObject:model.skuimgList];
        }
        page ++;
        [weakSelf.collectionview reloadData];
        [weakSelf.collectionview.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.collectionview.mj_footer endRefreshing];
    }];
}







// /app/product/productListByContent  business_id user_id partner_name 必填















@end
