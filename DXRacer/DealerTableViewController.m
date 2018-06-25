//
//  DealerTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/27.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "DealerTableViewController.h"
#import "ChannelTableViewController.h"
#import "SQMenuShowView.h"
@interface DealerTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property (assign, nonatomic)NSInteger num;
@property(nonatomic, strong)ChannelTableViewController *chnanel;
@end

@implementation DealerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = bar1;
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(0, 0, 30, 30) ;
    [editbtn setImage:[UIImage imageNamed:@"change3"] forState:UIControlStateNormal];
    [editbtn addTarget:self action:@selector(clickSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
//    self.navigationItem.rightBarButtonItem = bar;
    self.navigationItem.rightBarButtonItems = @[bar1,bar];
    
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
//    SeachShoopingTableViewController *searchVC = ShoppingCartViewControllerer alloc]init];
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
        self.navigationItem.title = @"经销商";
        [self.chnanel.view removeFromSuperview];
    }
    if (index == 1) {
        self.navigationItem.title = @"渠道订单";
        [self.chnanel.view removeFromSuperview];
        self.chnanel = [[ChannelTableViewController alloc]init];
        [self.view addSubview:self.chnanel.view];
        
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
                                               items:@[@"经销商",@"渠道订单"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-70,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"经销商";
    
    return cell;
}


@end
