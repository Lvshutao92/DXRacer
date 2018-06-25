//
//  MineViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineViewController.h"
#import "SYCollectionViewCell.h"
#import "SYCollectionModel.h"

#import "Install ViewController.h"

#import "MineOneViewController.h"//购物
#import "MODELController.h"
#import "ITEMController.h"
#import "CustomButton.h"

#import "AllViewController.h"//订单
#import "MineThreeViewController.h"//收货地址
#import "MineFourViewController.h"//财务管理
#import "MineFiveViewController.h"//佣金管理
#import "MineSixViewController.h"//零售发票
#import "MineSevenViewController.h"//账户管理
#import "DealerTableViewController.h"//渠道管理
#import "ZYGGTableViewController.h"

@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>
{
    float height;
    UILabel *lab;
    NSString *totalMoney;
}
@property(nonatomic, strong)UICollectionView *collectionview;

@property(nonatomic, strong)UIImageView *userImageView;
@property(nonatomic, strong)NSMutableArray *dataSourceArray;

@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic, strong)NSMutableArray *imgArray;
@end

@implementation MineViewController
- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray == nil) {
        self.dataSourceArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSourceArray;
}
- (NSMutableArray *)imgArray {
    if (_imgArray == nil) {
        self.imgArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imgArray;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItem];
    }
    return self;
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"4"] selectedImage:[UIImage imageNamed:@"4"]];
    //tabBarItem.badgeValue = @"new";
    //tabBar自带渲染颜色，会将tabBarItem渲染成系统的蓝色，我们设置image的属性为原始状态即可；
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
//    tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    [self lodmoney];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.navigationItem.title = @"我的信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    
    
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    headView.image = [UIImage imageNamed:@"sybg"];
    
    self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 45, 100, 100)];
    self.userImageView.layer.cornerRadius = 50;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageview:)];
    [self.userImageView addGestureRecognizer:tap];
    UIImage *theImage = [UIImage imageNamed:@"user"];
    self.userImageView.image = theImage;
    [headView addSubview:self.userImageView];
    lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 155, SCREEN_WIDTH-40, 60)];
    lab.numberOfLines = 0;
    lab.font= [UIFont systemFontOfSize:18];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    
    
    [self lodmoney];
    
    
    [headView addSubview:lab];
    [self.scrollview addSubview:headView];
    [self.view addSubview:self.scrollview];
    
    if ([[[Manager sharedManager] redingwenjianming:@"mainaccount.text"] isEqualToString:@"Y"]) {
        self.dataSourceArray = [@[@"订单管理",@"财务管理",@"零售发票",@"购物管理",@"账户管理",@"资源中心"]mutableCopy];
        self.imgArray = [@[@"1",@"2",@"3",@"4",@"5",@"6"]mutableCopy];
    } else {
        if ([[[Manager sharedManager] redingwenjianming:@"rolename.text"]isEqualToString:@"普通子账户"]){
            self.dataSourceArray = [@[@"购物管理",@"订单管理",@"资源中心"]mutableCopy];
            self.imgArray = [@[@"01",@"02",@"03"]mutableCopy];
        }else {
            self.dataSourceArray = [@[@"订单管理",@"财务管理",@"零售发票",@"购物管理",@"资源中心"]mutableCopy];
            self.imgArray = [@[@"001",@"002",@"003",@"004",@"005"]mutableCopy];
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH-50, 15, 35, 35) ;
    [btn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:btn];
//    [self setupUserInformation];
    [self setbutton];
}



- (void)lodmoney {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
   
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],@"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"]};
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"user", @"getAccountMoney") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
       NSString *str = [[dic objectForKey:@"rows"] objectForKey:@"moneyStr"];
        totalMoney = [[dic objectForKey:@"rows"] objectForKey:@"moneyStr"];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"H"];
        NSString *DateTime = [formatter stringFromDate:date];
        
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            if ([DateTime integerValue] == 12 ) {
                lab.text = [NSString stringWithFormat:@"%@，中午好",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }else if ([DateTime integerValue] >= 8 && [DateTime integerValue] < 12) {
                lab.text = [NSString stringWithFormat:@"%@，上午好",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }else if ([DateTime integerValue] >= 13 && [DateTime integerValue] < 18) {
                lab.text = [NSString stringWithFormat:@"%@，下午好",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }else if ([DateTime integerValue] >= 16 && [DateTime integerValue] <= 24) {
                lab.text = [NSString stringWithFormat:@"%@，晚上好",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }else{
                lab.text = [NSString stringWithFormat:@"%@，早上好",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }
        }else {
            if ([DateTime integerValue] == 12 ) {
                lab.text = [NSString stringWithFormat:@"%@，中午好\n您的余额：¥%@",[[Manager sharedManager] redingwenjianming:@"username.text"],str];
            }else if ([DateTime integerValue] >= 8 && [DateTime integerValue] < 12) {
                lab.text = [NSString stringWithFormat:@"%@，上午好\n您的余额：¥%@",[[Manager sharedManager] redingwenjianming:@"username.text"],str];
            }else if ([DateTime integerValue] >= 13 && [DateTime integerValue] < 18) {
                lab.text = [NSString stringWithFormat:@"%@，下午好\n您的余额：¥%@",[[Manager sharedManager] redingwenjianming:@"username.text"],str];
            }else if ([DateTime integerValue] >= 16 && [DateTime integerValue] <= 24) {
                lab.text = [NSString stringWithFormat:@"%@，晚上好\n您的余额：¥%@",[[Manager sharedManager] redingwenjianming:@"username.text"],str];
            }else{
                lab.text = [NSString stringWithFormat:@"%@，早上好\n您的余额：¥%@",[[Manager sharedManager] redingwenjianming:@"username.text"],str];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


- (void)setbutton {

    int b = 0;
    int hangshu;
    if (self.dataSourceArray.count % 3 == 0 ) {
        hangshu = (int )self.dataSourceArray.count / 3;
    } else {
        hangshu = (int )self.dataSourceArray.count / 3 + 1;
    }
    //j是小于你设置的列数
    for (int i = 0; i < hangshu; i++) {
        for (int j = 0; j < 3; j++) {
            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
            if ( b  < self.dataSourceArray.count) {
                btn.frame = CGRectMake((0  + j * SCREEN_WIDTH/3), (250 + i * 120*SCALE_HEIGHT) ,SCREEN_WIDTH/3, 120*SCALE_HEIGHT);
                btn.backgroundColor = [UIColor whiteColor];
                btn.tag = b;
                [btn setTitle:self.dataSourceArray[b] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                height = i * 120*SCALE_HEIGHT + 350*SCALE_HEIGHT;
                [self.scrollview setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
               
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%@",self.imgArray[b]]];
                [btn setImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(yejian:) forControlEvents:UIControlEventTouchUpInside];
                [btn.layer setBorderColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor];
                [btn.layer setBorderWidth:0.5f];
                [btn.layer setMasksToBounds:YES];
                [self.scrollview addSubview:btn];
                if (b > self.dataSourceArray.count   )
                {
                    [btn removeFromSuperview];
                }
            }
            b++;

        }
    }


}
- (void)yejian:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"购物管理"]) {
        MineOneViewController *vc = [[MineOneViewController alloc] initWithAddVCARY:@[[MODELController new],[ITEMController new]] TitleS:@[@"MODEL浏览",@"ITEM列表"]];
        [Manager sharedManager].searchIndex = 1000;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"订单管理"]) {
        AllViewController *all = [[AllViewController alloc]init];
        all.navigationItem.title = @"所有订单";
        [self.navigationController pushViewController:all animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"收货地址"]) {
        MineThreeViewController *three = [[MineThreeViewController alloc]init];
        three.navigationItem.title = @"常用地址";
        [self.navigationController pushViewController:three animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"财务管理"]) {
        MineFourViewController *four = [[MineFourViewController alloc]init];
        four.navigationItem.title = @"余额充值";
        [self.navigationController pushViewController:four animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"佣金管理"]) {
        MineFiveViewController *five = [[MineFiveViewController alloc]init];
        [Manager sharedManager].searchIndex = 102;
        five.navigationItem.title = @"可申请订单";
        [self.navigationController pushViewController:five animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"零售发票"]) {
        MineSixViewController *six = [[MineSixViewController alloc]init];
        six.navigationItem.title = sender.titleLabel.text;
        [self.navigationController pushViewController:six animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"账户管理"]) {
        MineSevenViewController *seven = [[MineSevenViewController alloc]init];
        seven.navigationItem.title = @"子账户";
        [self.navigationController pushViewController:seven animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"渠道管理"]) {
        DealerTableViewController *dealer = [[DealerTableViewController alloc]init];
        dealer.navigationItem.title = @"经销商";
        [Manager sharedManager].searchIndex = 100;
        dealer.navigationItem.backBarButtonItem.title = @"渠道管理";
        [self.navigationController pushViewController:dealer animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"资源中心"]) {
        ZYGGTableViewController *dealer = [[ZYGGTableViewController alloc]init];
        dealer.navigationItem.title = @"公告";
        [self.navigationController pushViewController:dealer animated:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
}



















-(void) setupUserInformation {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4-40*SCALE_WIDTH+40);
    layout.headerReferenceSize = CGSizeMake(0, 200*SCALE_HEIGHT);
    // 设置最小行间距
    layout.minimumLineSpacing = 0;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    _collectionview.backgroundColor = [UIColor whiteColor];
    [_collectionview registerClass:[SYCollectionViewCell class] forCellWithReuseIdentifier:@"SYcell"];
    //注册头视图
    [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    [self.view addSubview:_collectionview];
    
}


#pragma mark======UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"UICollectionViewHeader"
                                                                                   forIndexPath:indexPath];
    headView.backgroundColor = RGBACOLOR(230, 243, 242, 1.0);
    

    self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 50*SCALE_HEIGHT, 80, 80)];
    self.userImageView.layer.cornerRadius = 40;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageview:)];
    [self.userImageView addGestureRecognizer:tap];
    
    
    UIImage *theImage = [UIImage imageNamed:@"user"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    self.userImageView.image = theImage;
    self.userImageView.tintColor = RGBACOLOR(32, 157, 149, 1.0);
    [headView addSubview:self.userImageView];
    
    lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*SCALE_HEIGHT + 90, SCREEN_WIDTH-40, 50)];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    lab.text = [NSString stringWithFormat:@"下午好!\n工作再忙，也别忘了站起来活动一下"];
    [headView addSubview:lab];
    
    return headView;
}
- (void)clickImageview:(UITapGestureRecognizer *)gesture{
    Install_ViewController *install = [[Install_ViewController alloc]init];
    install.totalMoney = totalMoney;
    [self.navigationController pushViewController:install animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)clickEdit{
    Install_ViewController *install = [[Install_ViewController alloc]init];
    install.totalMoney = totalMoney;
    [self.navigationController pushViewController:install animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark======UICollectionViewDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYcell" forIndexPath:indexPath];
    cell.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%ld",indexPath.row + 1]];
    cell.lable.text = [self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleStr = [self.dataSourceArray objectAtIndex:indexPath.row];
    if ([titleStr isEqualToString:@"购物管理"]) {
        MineOneViewController *vc = [[MineOneViewController alloc] initWithAddVCARY:@[[MODELController new],[ITEMController new]] TitleS:@[@"MODEL浏览",@"ITEM列表"]];
        [Manager sharedManager].searchIndex = 1000;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titleStr isEqualToString:@"订单管理"]) {
        AllViewController *all = [[AllViewController alloc]init];
        all.navigationItem.title = @"所有订单";
        [self.navigationController pushViewController:all animated:YES];
    }
    if ([titleStr isEqualToString:@"收货地址"]) {
        MineThreeViewController *three = [[MineThreeViewController alloc]init];
        three.navigationItem.title = @"常用地址";
        [self.navigationController pushViewController:three animated:YES];
    }
    if ([titleStr isEqualToString:@"财务管理"]) {
        MineFourViewController *four = [[MineFourViewController alloc]init];
        four.navigationItem.title = @"余额充值";
        [self.navigationController pushViewController:four animated:YES];
    }
    if ([titleStr isEqualToString:@"佣金管理"]) {
        MineFiveViewController *five = [[MineFiveViewController alloc]init];
        [Manager sharedManager].searchIndex = 102;
        five.navigationItem.title = @"可申请订单";
        [self.navigationController pushViewController:five animated:YES];
    }
    if ([titleStr isEqualToString:@"零售发票"]) {
        MineSixViewController *six = [[MineSixViewController alloc]init];
        six.navigationItem.title = titleStr;
        [self.navigationController pushViewController:six animated:YES];
    }
    if ([titleStr isEqualToString:@"账户管理"]) {
        MineSevenViewController *seven = [[MineSevenViewController alloc]init];
        seven.navigationItem.title = @"子账户";
        [self.navigationController pushViewController:seven animated:YES];
    }
    if ([titleStr isEqualToString:@"渠道管理"]) {
        DealerTableViewController *dealer = [[DealerTableViewController alloc]init];
        dealer.navigationItem.title = @"经销商";
        [Manager sharedManager].searchIndex = 100;
        dealer.navigationItem.backBarButtonItem.title = @"渠道管理";
        [self.navigationController pushViewController:dealer animated:YES];
    }
    if ([titleStr isEqualToString:@"资源中心"]) {
        ZYGGTableViewController *dealer = [[ZYGGTableViewController alloc]init];
        dealer.navigationItem.title = @"公告";
        [self.navigationController pushViewController:dealer animated:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
}








@end
