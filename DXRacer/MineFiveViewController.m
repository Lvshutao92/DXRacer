//
//  MineFiveViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MineFiveViewController.h"
#import "SQMenuShowView.h"
#import "MineYongJinDanViewController.h"


@interface MineFiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property (assign, nonatomic)NSInteger num;
@property(nonatomic, strong)MineYongJinDanViewController *minyongjin;
@end

@implementation MineFiveViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 30, 30) ;
    [editbtn setImage:[UIImage imageNamed:@"change3"] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    self.navigationItem.rightBarButtonItem = bar;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    self.navigationItem.rightBarButtonItems = @[bar1,bar];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.tableview.tableHeaderView = view;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.num = 0;
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        [self setupbutton:index];
        [self.view bringSubviewToFront:view];
    }];
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
        self.navigationItem.title = @"可申请订单";
        [self.minyongjin.view removeFromSuperview];
    }
    if (index == 1) {
        self.navigationItem.title = @"我的佣金单";
        [self.minyongjin.view removeFromSuperview];
        self.minyongjin = [[MineYongJinDanViewController alloc]init];
        [self.view addSubview:self.minyongjin.view];
        
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
                                               items:@[@"可申请订单",@"我的佣金单"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-70,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}


#pragma mark---------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
#pragma mark---------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"订单列表-申请佣金";
    return cell;
}



@end
