//
//  ModelsearchViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/20.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ModelsearchViewController.h"
#import "GoodsDetailsViewController.h"
#import "ModeModel.h"
#import "ProductModel.h"
#import "SkuimgModel.h"
#import "MODELCell.h"

@interface ModelsearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITextField *modeltextfield;
     BOOL modelisno;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *imgdataArray;
@property(nonatomic, strong)UICollectionView *collectionview;

@end

@implementation ModelsearchViewController

- (void)clickback {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clicksearch {
    [modeltextfield resignFirstResponder];
    
        if (modeltextfield.text.length != 0) {
            [self lodmodel];
        }
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
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50) collectionViewLayout:layout];
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    _collectionview.backgroundColor = [UIColor colorWithWhite:.9 alpha:.15];
    [_collectionview registerClass:[MODELCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionview];
    [self.view bringSubviewToFront:_collectionview];
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

- (void)lodmodel {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"content":modeltextfield.text,
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"product",@"productListByContent") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"-=%@",dic);
        NSDictionary *rows = [dic objectForKey:@"rows"] ;
        NSArray *resultList = [rows objectForKey:@"resultList"];
        
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
        [weakSelf.collectionview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}






- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"物品检索";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 30, 30);
//    [btn setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = bar;
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn.frame = CGRectMake(0, 0, 30, 30) ;
    [searchbtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(clicksearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbar = [[UIBarButtonItem alloc]initWithCustomView:searchbtn];
    self.navigationItem.rightBarButtonItem = searchbar;
    
    
    [self setupCollectionView];
    
    modeltextfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 64, SCREEN_WIDTH-40, 50)];
    modeltextfield.placeholder = @" 请输入搜索内容";
    modeltextfield.delegate = self;
    [self.view addSubview:modeltextfield];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 113, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    [self.view addSubview:line];
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
- (NSMutableArray *)imgdataArray {
    if (_imgdataArray == nil) {
        self.imgdataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imgdataArray;
}
@end
