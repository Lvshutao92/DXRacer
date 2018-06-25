//
//  ShoppingCartViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoopingCell.h"
#import "GoodsDetailsViewController.h"
#import "ShoppingListModel.h"

#import "TijiaodingdanViewController.h"
#define  TAG_BACKGROUNDVIEW 100

@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CAGradientLayer *_gradientLayer;
    UILabel *txlab;//没有选择商品点击结算提示label
    UIView *bgView;//底部视图
//    UIButton *btn;//编辑按钮
    UITableView *myTableView;
    //全选按钮
    UIButton *selectAll;
    //展示数据源数组
    NSMutableArray *dataArray;
    //是否全选
    BOOL isSelect;
    //已选的商品集合
    NSMutableArray *selectGoods;
    UILabel *priceLabel;
    
    BOOL isedit;
    UIButton *editbtn;
    
    NSMutableArray *deleateArr;
    
    NSInteger totolNum;
    UIButton *btn;
}
@end

@implementation ShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    deleateArr = [NSMutableArray arrayWithCapacity:1];
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 50, 30) ;
    [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    self.navigationItem.rightBarButtonItem = bar;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 150) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.rowHeight = 100;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = RGBCOLOR(245, 246, 248);
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    //每次进入购物车的时候把选择的置空
    [deleateArr removeAllObjects];
    [selectGoods removeAllObjects];
    isSelect = NO;
    selectAll.selected = NO;
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    
    [self.view addSubview:myTableView];
    [self setupBottomView];
    [self lodXL];
}
- (void)clickEdit {
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    //    [self networkRequest];
    selectAll.selected = NO;
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
    [myTableView reloadData];
    
    if (isedit == NO) {
        [deleateArr removeAllObjects];
        [editbtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    isedit = !isedit;;
    [self setupBottomView];
}


//请求列表
- (void)lodXL{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"shoppingcart", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        totolNum = [[dic objectForKey:@"total"] integerValue];
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        
        dataArray = [ShoppingListModel mj_objectArrayWithKeyValuesArray:array];
        dataArray = (NSMutableArray *)[[dataArray reverseObjectEnumerator] allObjects];
        
  
        [myTableView reloadData];
        weakSelf.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",totolNum];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}


/**
 *  计算已选中商品金额
 */
-(void)countPrice
{
    double totlePrice = 0.0;
    for (ShoppingListModel *model in selectGoods) {
        double price = [model.realprice doubleValue];
        
        totlePrice += price*model.number;
    }
//    NSLog(@"%@",[Manager jinegeshi:[NSString stringWithFormat:@"%f",totlePrice]]);
    priceLabel.text = [Manager jinegeshi:[NSString stringWithFormat:@"%f",totlePrice]];
    
}



-(void)selectAllBtnClick:(UIButton*)button
{
    
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        for (ShoppingListModel *model in dataArray) {
            [selectGoods addObject:model];
            
        }
        [deleateArr addObjectsFromArray:selectGoods];
    }
    else
    {
        [selectGoods removeAllObjects];
        [deleateArr removeAllObjects];
    }
    [myTableView reloadData];
    [self countPrice];
}

//提交订单
-(void)goPayBtnClick
{
    if (selectGoods.count == 0) {
        txlab.hidden = NO;
        [self.view bringSubviewToFront:txlab];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            txlab.hidden = YES;
        });
    }else {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (ShoppingListModel *model in selectGoods) {
            [arr addObject:model.shoppingcartid];
        }
        [self lodJieSuan:arr];
    }
}

//去结算
- (void)lodJieSuan:(NSMutableArray *)ids {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:btn animated:YES];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.square = YES;
//    hud.bezelView.color = [UIColor colorWithWhite:0.95f alpha:0.01f];
//    hud.contentColor = [UIColor blackColor];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (ids.count != 0) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"ids":ids,
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"]};
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"shoppingcart", @"confirm") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                TijiaodingdanViewController *final = [[TijiaodingdanViewController alloc]init];
                final.priceNum = priceLabel.text;
                final.dataArr = selectGoods;
                //UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:final];
                [self.navigationController pushViewController:final animated:YES];
            }
            
            [myTableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
    
}







#pragma mark - 设置底部视图

-(void)setupBottomView
{
    //底部视图的 背景
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = kUIColorFromRGB(0xD5D5D5);
    [bgView addSubview:line];    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn1"] forState:UIControlStateNormal];
    
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn1"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [selectAll setImage:theImage forState:UIControlStateSelected];
    [selectAll setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectAll];
#pragma mark -- 底部视图添加约束
    //全选按钮
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.top.equalTo(@10);
        make.bottom.equalTo(bgView).offset(-10);
        make.width.equalTo(@60);
        
    }];
    
    if (isedit == NO) {
        //合计
        UILabel *label = [[UILabel alloc]init];
        label.text = @"合计: ";
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:label];
        
        //价格
        priceLabel = [[UILabel alloc]init];
        priceLabel.text = @"￥0.00";
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        priceLabel.textColor = RGBACOLOR(32, 157, 149, 1.0);
        [bgView addSubview:priceLabel];
        
        //结算按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
        
        [btn setTitle:@"去结算" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        //结算按钮
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.right.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(@100);
            
        }];
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            label.frame = CGRectMake(0, 0, 0, 0);
            priceLabel.frame = CGRectMake(0, 0, 0, 0);
        }else {
            //价格显示
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btn.mas_left).offset(-10);
                make.top.equalTo(bgView).offset(10);
                make.bottom.equalTo(bgView).offset(-10);
                make.left.equalTo(label.mas_right);
            }];
            
            //合计
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView).offset(10);
                make.bottom.equalTo(bgView).offset(-10);
                make.right.equalTo(priceLabel.mas_left);
                make.width.equalTo(@60);
            }];
        }
        
    }else {
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
        [btn1 setTitle:@"删除" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(clickgodeleate) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn1];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.right.equalTo(bgView);
            make.bottom.equalTo(bgView);
            make.width.equalTo(@150);
            
        }];
    }
    
}

- (void)clickgodeleate {
   
    [dataArray removeObjectsInArray:deleateArr];
    

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (ShoppingListModel *model in deleateArr) {
        [arr addObject:model.shoppingcartid];
    }
    [self lodDelegateSelectsGoods:arr];
    
    [myTableView reloadData];
    if (dataArray.count == 0) {
        [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
        isedit = NO;
        [self setupBottomView];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",dataArray.count];
}

//删除购物车商品
- (void)lodDelegateSelectsGoods:(NSMutableArray *)ids{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (ids.count != 0) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"ids":ids,
                @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"shoppingcart",@"delete") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            //        NSLog(@"删除购物车商品===%@",dic);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [editbtn setTitle:@"编辑" forState:UIControlStateNormal];
                isedit = NO;
                [weakSelf setupBottomView];
            }
            [myTableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
    
}




#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    GoodsDetailsViewController *goods = [[GoodsDetailsViewController alloc]init];
//    [self.navigationController pushViewController:goods animated:YES];
//    self.tabBarController.tabBar.hidden = YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoopingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoopingcell"];
    if (!cell) {
        cell = [[ShoopingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shoopingcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isSelected = isSelect;
    
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        cell.isSelected = YES;
    }
    
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        
        if (isSelec) {
            [selectGoods addObject:[dataArray objectAtIndex:indexPath.row]];
            [deleateArr addObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectGoods removeObject:[dataArray objectAtIndex:indexPath.row]];
            [deleateArr removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        
        if (selectGoods.count == dataArray.count) {
            selectAll.selected = YES;
        }
        else
        {
            selectAll.selected = NO;
        }
        
        [self countPrice];
    };
    __block ShoopingCell *weakCell = cell;
    cell.numAddBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        ShoppingListModel *model = [dataArray objectAtIndex:indexPath.row];
        weakCell.numberLabel.text = numStr;
        model.number = count;
        [self lodChangeGoodsNumber:[NSString stringWithFormat:@"%ld",model.number] ids:model.shoppingcartid];
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:model];        
        if ([selectGoods containsObject:model]) {
            [selectGoods removeObject:model];
            [selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    cell.numCutBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count--;
        if(count <= 0){
            return ;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        ShoppingListModel *model = [dataArray objectAtIndex:indexPath.row];
        weakCell.numberLabel.text = numStr;
        model.number = count;
        [self lodChangeGoodsNumber:[NSString stringWithFormat:@"%ld",model.number] ids:model.shoppingcartid];
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([selectGoods containsObject:model]) {
            [selectGoods removeObject:model];
            [selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    [cell reloadDataWith:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}
//改变商品数量
- (void)lodChangeGoodsNumber:(NSString *)amount ids:(NSString *)ids{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (amount != nil && ids != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"id":ids,
                @"amount":amount,
                @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"shoppingcart",@"update") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                
            }
            [weakSelf lodXL];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
}









- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *xiugai = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            ShoppingListModel *model = [dataArray objectAtIndex:indexPath.row];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            [arr addObject:model.shoppingcartid];
            [self lodDelegateSelectsGoods:arr];
            
            [dataArray removeObjectAtIndex:indexPath.row];
            //删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //延迟0.5s刷新一下,否则数据会乱
            //            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            self.navigationItem.title = [NSString stringWithFormat:@"购物车(%ld)",dataArray.count];
            myTableView.editing = NO;
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            myTableView.editing = NO;
        }];
        
        
        [self countPrice];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
    xiugai.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    return @[xiugai];
}










- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItem];
    }
    return self;
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"购物" image:[UIImage imageNamed:@"3"] selectedImage:[UIImage imageNamed:@"3"]];
    //tabBarItem.badgeValue = @"new";
    //tabBar自带渲染颜色，会将tabBarItem渲染成系统的蓝色，我们设置image的属性为原始状态即可；
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
//    tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
}
-(void)goToMainmenuView
{
    self.tabBarController.selectedIndex = 0;
}
@end
