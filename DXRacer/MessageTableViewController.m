//
//  AllViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/21.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "MessageTableViewController.h"
#import "ArtificialViewController.h"
#import "SelfMotionViewController.h"
#import "SQMenuShowView.h"
#import "DingDanDetailsController.h"
#import "DDDetailsCell.h"
#import "MapModel.h"
#import "AddressModel.h"
#import "ItemsModel.h"
#import "DDDModel.h"
#import "KKPModel.h"
#import "DdsearchTableViewController.h"
@interface MessageTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger page;
    NSInteger totolNum;
    NSString  *idd;
    
    UIView *bgview;
    UITextField *textf;
    UITextField *textf1;
    NSString *idString;
    
    float height;
    
    float addrheight;
    float skucodeheight;
    float liuyanheight;
    float kuaididanhao;
    NSString *strings;
}
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)UITableView *tableview1;
@property(nonatomic, strong)NSMutableArray *array;

@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property (assign, nonatomic)NSInteger num;
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)ArtificialViewController *artificial;
@property(nonatomic, strong)SelfMotionViewController *motion;
@end

@implementation MessageTableViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItem];
    }
    return self;
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"订单" image:[UIImage imageNamed:@"2"] selectedImage:[UIImage imageNamed:@"2"]];
    //tabBarItem.badgeValue = @"new";
    //tabBar自带渲染颜色，会将tabBarItem渲染成系统的蓝色，我们设置image的属性为原始状态即可；
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
    //    tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
}
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)setbtn {
    //    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    editbtn.frame = CGRectMake(0, 0, 30, 30) ;
    //    [editbtn setImage:[UIImage imageNamed:@"change3"] forState:UIControlStateNormal];
    //    [editbtn addTarget:self action:@selector(clickSelected) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:editbtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar1;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"所有订单";
    [self setbtn];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"DDDetailsCell" bundle:nil] forCellReuseIdentifier:@"cellDD"];
    [self.view addSubview:self.tableview];
    
    UIView *viee = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableview.tableFooterView = viee;
    
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
    
    [self setupvie];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    vie.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.tableview.tableHeaderView = vie;
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-40, 40)];
    [self.textfield.layer setBorderWidth:0];
    self.textfield.delegate = self;
    
    [self.textfield.layer setBorderColor:[UIColor colorWithWhite:.8 alpha:.4].CGColor];
    [vie addSubview:self.textfield];
    
    self.tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(1, 50, SCREEN_WIDTH-2, 200)];
    [self.tableview1.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.tableview1.layer setBorderWidth:1];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.hidden = YES;
//    [self.tableview1.layer setBorderColor:[UIColor colorWithWhite:.7 alpha:.4].CGColor];
//    [self.tableview1.layer setBorderWidth:1];
    
    [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview addSubview:self.tableview1];
    [self.tableview bringSubviewToFront:self.tableview1];
    
    
    [self lod];
    
    
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
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
    lab1.text = @"订单编号";
    [iew addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 20)];
    lab2.text = @"实销金额";
    [iew addSubview:lab2];
    textf = [[UITextField alloc]initWithFrame:CGRectMake(90, 15, SCREEN_WIDTH-160, 30)];
    textf.placeholder = @"";
    textf.delegate = self;
    [textf.layer setBorderWidth:.5];
    [textf.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [iew addSubview:textf];
    textf1 = [[UITextField alloc]initWithFrame:CGRectMake(90, 55, SCREEN_WIDTH-160, 30)];
    textf1.delegate = self;
    [textf1.layer setBorderWidth:.5];
    [textf1.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [iew addSubview:textf1];
    
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
- (void)clickcancle{
    bgview.hidden = YES;
}
- (void)clicksave{
    if (textf1.text.length != 0 && idString.length != 0) {
        [self lodXiuGaiJinE:textf1.text str2:idString];
    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textfield]) {
        if (self.tableview1.hidden == NO) {
            self.tableview1.hidden = YES;
        }else {
            self.tableview1.hidden = NO;
        }
        return NO;
    }
    if ([textField isEqual:textf1]) {
        return YES;
    }
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _isShow = NO;
    [self.showView dismissView];
    [self.textfield resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)lod{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],            
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order",@"innitwarehourse") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"-------%@",dic);
        [weakSelf.array removeAllObjects];
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            
            NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"userStore"];
            [weakSelf.array removeAllObjects];
            for (NSDictionary *dicc in arr) {
                KKPModel *model = [KKPModel mj_objectWithKeyValues:dicc];
                [weakSelf.array addObject:model];
            }
            
            KKPModel *model = [weakSelf.array firstObject];
            
            weakSelf.textfield.text = model.name;
            [weakSelf setUpReflash:model.id];
        }
        [weakSelf.tableview1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)loddeleate:(NSString *)strid indexpath:(NSIndexPath *)indexpath{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (strid != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"id":strid,
                };
    }
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order",@"cancelOrder") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"-------%@",dic);
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}






- (void)clickSearch {
    DdsearchTableViewController *searchVC = [[DdsearchTableViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:searchVC];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
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
        self.navigationItem.title = @"所有订单";
        [self.artificial.view removeFromSuperview];
        [self.motion.view removeFromSuperview];
        [self.view addSubview:self.tableview];
        [self.tableview reloadData];
    }
    if (index == 1) {
        self.navigationItem.title = @"人工订单";
        [self.artificial.view removeFromSuperview];
        [self.motion.view removeFromSuperview];
        self.artificial = [[ArtificialViewController alloc]init];
        [self.view addSubview:self.artificial.view];
    }
    if (index == 2) {
        self.navigationItem.title = @"自动订单";
        [self.artificial.view removeFromSuperview];
        [self.motion.view removeFromSuperview];
        self.motion = [[SelfMotionViewController alloc]init];
        [self.view addSubview:self.motion.view];
    }
}

- (SQMenuShowView *)showView{
    if (_showView) {
        return _showView;
    }
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64,100,250}
                                               items:@[@"所有订单",@"人工订单",@"自动订单"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-70,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableview]) {
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            return 400+addrheight+skucodeheight+liuyanheight + kuaididanhao;
        }else {
            return 420+addrheight+skucodeheight+liuyanheight + kuaididanhao;
        }
    }
    
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableview1]) {
        self.tableview1.hidden = YES;
        [self.tableview.mj_header endRefreshing];
        KKPModel *model = [self.array objectAtIndex:indexPath.row];
        self.textfield.text = model.name;
        [self setUpReflash:model.id];
    }
    if ([tableView isEqual:self.tableview]) {
        DingDanDetailsController *details = [[DingDanDetailsController alloc]init];
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
        details.oderid = model.addressmodel.order_id;
        details.str1 = model.mapmodel.logistics;
        details.str2 = model.mapmodel.express_order;
        details.str3 = model.mapmodel.jxs_postage_cj;
        [self presentViewController:na animated:YES completion:nil];
    }
    self.tableview1.hidden = YES;
    
}

//- (void)viewWillLayoutSubviews {
//    
//    if (self.view.subviews[0] != self.tableview) {
//        //self.tableView是我们希望正常显示cell的视图
//        self.tableview.subviews[0].frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//    }
//    
//}

/*或者设置 tableView的y : 64*/
//如果navigationbar.translucent = YES; scrollview会被自动设置contentInset.top=64




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableview]) {
        return self.dataArray.count;
    }
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableview1]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        KKPModel *model = [self.array objectAtIndex:indexPath.row];
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = model.name;
        return cell;
    }
    
    DDDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDD" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ItemsModel *mo = [model.orderItems firstObject];
    
    cell.lab1.text = model.mapmodel.order_no;
    
    
    
    cell.lab2.text = model.mapmodel.orderItems;
    cell.lab2.numberOfLines = 0;
    cell.lab2.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.lab2 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
    skucodeheight = size.height;
    cell.lab2height.constant = skucodeheight;
    cell.julitop3.constant = skucodeheight -10;
    
    
    if ([model.mapmodel.jxs_order_status isEqualToString:@"C"]) {
        cell.lab3.text = @"订单已创建";
    }
    else if ([model.mapmodel.jxs_order_status isEqualToString:@"E"]) {
        cell.lab3.text = @"订单已发货";
    }
    else if ([model.mapmodel.jxs_order_status isEqualToString:@"I"]) {
        cell.lab3.text = @"订单已确认";
    }
    else if ([model.mapmodel.jxs_order_status isEqualToString:@"L"]) {
        cell.lab3.text = @"订单已取消";
    }
    else if ([model.mapmodel.jxs_order_status isEqualToString:@"J"]) {
        cell.lab3.text = @"订单已分配";
    }
    else if ([model.mapmodel.jxs_order_status isEqualToString:@"G"]) {
        cell.lab3.text = @"订单待取消";
    }else if ([model.mapmodel.jxs_order_status isEqualToString:@"A"] || [model.mapmodel.jxs_order_status isEqualToString:@"N"]){
        cell.lab3.text = @"订单异常";
    }
   
    
    
    
    
    cell.lab4.text = model.mapmodel.create_user;
    if (model.mapmodel.order_resource_num.length == 0) {
        cell.lab5.text = @"-";
    }else {
        cell.lab5.text = model.mapmodel.order_resource_num;
    }
    if (model.mapmodel.buyer_note.length == 0) {
        cell.lab6.text = @"-";
        liuyanheight=20;
//        cell.huokuantop.constant = 10;
    }else {
        cell.lab6.text = model.mapmodel.buyer_note;
        cell.lab6.numberOfLines = 0;
        cell.lab6.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [cell.lab6 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
        liuyanheight = size.height;
        cell.liuyanheight.constant = liuyanheight;
//        cell.huokuantop.constant = liuyanheight - 10;
    }
    
    
    if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]){
        cell.huokuanheight.constant = 0.01;
        cell.labheight.constant     = 0.01;
        cell.huokuantop.constant = 0.01;
        cell.labtop.constant = 0.01;
    }else{
        cell.huokuanheight.constant = 20;
        cell.labheight.constant     = 20;
        cell.huokuantop.constant    = liuyanheight-10;
        cell.labtop.constant        = 10;
        
        cell.lab7.text = [Manager jinegeshi:model.mapmodel.jxs_total_fee];
    }
    
    
    
    
    cell.lab8.text =  [Manager jinegeshi:[NSString stringWithFormat:@"%ld",[model.mapmodel.product_total_price integerValue]/[mo.quantity integerValue]]];
    if ([model.mapmodel.is_return isEqualToString:@"Y"]) {
        UIImage *theImage = [UIImage imageNamed:@"is"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.btn1 setImage:theImage forState:UIControlStateSelected];
        [cell.btn1 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
        //        [cell.btn1 setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    }else {
        [cell.btn1 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    }
    if ([model.mapmodel.is_refund isEqualToString:@"Y"]) {
        UIImage *theImage = [UIImage imageNamed:@"is"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.btn2 setImage:theImage forState:UIControlStateSelected];
        [cell.btn2 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
        //        [cell.btn2 setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    }else {
        [cell.btn2 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    }
    if (model.mapmodel.order_deliver_time == nil) {
        cell.lab9.text = @"-";
    }else {
        cell.lab9.text = [Manager timezhuanhuan:model.mapmodel.order_deliver_time];
    }
    cell.lab10.text = model.mapmodel.warehourse;
    
    if (model.mapmodel.logistics == nil) {
        cell.lab11.text = @"-";
    }else {
        cell.lab11.text = model.mapmodel.logistics;
    }
    if (model.mapmodel.express_order == nil) {
        cell.lab12.text = @"-";
        kuaididanhao = 20;
        cell.shouhuorentop.constant = kuaididanhao -10;
    }else {
        cell.lab12.text = model.mapmodel.express_order;
        cell.lab12.numberOfLines = 0;
        cell.lab12.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size1 = [cell.lab12 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
        kuaididanhao = size1.height;
        cell.kddhHeight.constant = kuaididanhao;
        cell.shouhuorentop.constant = kuaididanhao -10;
    }
    
    
    cell.lab13.text = model.addressmodel.receiver_name;
    
    cell.lab14.text = model.addressmodel.receiver_address;
    cell.lab14.numberOfLines = 0;
    cell.lab14.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [cell.lab14 sizeThatFits:CGSizeMake(SCREEN_WIDTH-125, MAXFLOAT)];
    addrheight = size1.height;
    cell.addressheight.constant = addrheight;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *suer = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消开票" handler:^(UITableViewRowAction * _Nonnull sure, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model.mapmodel.id.length != 0) {
            [self cancelKaiPiao:model.mapmodel.id];
        }
    }];
    suer.backgroundColor = RGBACOLOR(254, 91, 91, 1.0);
    
    UITableViewRowAction *deleate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消订单" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([model.mapmodel.jxs_order_status isEqualToString:@"L"] || [model.mapmodel.jxs_order_status isEqualToString:@"E"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该订单不可取消" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消订单" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
                //            ItemsModel *mo = [model.orderItems firstObject];
                [self loddeleate:model.mapmodel.id indexpath:indexPath];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ac];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    deleate.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    
    
    UITableViewRowAction *xiugai = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        bgview.hidden = NO;
        DDDModel *model = [self.dataArray objectAtIndex:indexPath.row];
        textf.placeholder = model.mapmodel.order_no;
        idString = model.addressmodel.order_id;
    }];
    xiugai.backgroundColor = RGBACOLOR(39, 194, 183, 1.0);
    return @[suer,deleate,xiugai];
}


- (void)cancelKaiPiao:(NSString *)string{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"order_id":string,
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice",@"cancel") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"!!%@",[dic objectForKey:@"result_code"]);
        weakSelf.tableview.editing = NO;
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消开票成功" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        [weakSelf.tableview1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
}















- (void)lodXiuGaiJinE:(NSString *)str1 str2:(NSString *)str2 {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (str1.length != 0 && str2.length != 0) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"product_total_price":str1,
                @"id":str2,
                };
    }
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order",@"updateTotalPrice") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            bgview.hidden = YES;
        }
        [weakSelf.tableview1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//刷新数据
-(void)setUpReflash:(NSString *)str
{
     __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loddeDDList:str];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    
    
    
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totolNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loddeSLDDList:str];
        }
    }];
}
- (void)loddeDDList:(NSString *)str1 {
    
   
    
    NSString *string;
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([[Manager sharedManager] redingwenjianming:@"showorder.text"].length == 0) {
        string = @" ";
    }else {
        string = [[Manager sharedManager] redingwenjianming:@"showorder.text"];
    }
    if (str1 != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"page":[NSString stringWithFormat:@"%ld",page],
                @"warehourse":str1,
                @"user_name ":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                @"showorder":string,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"order", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
            
            //        NSLog(@"-----%@",dic);
            totolNum = [[dic objectForKey:@"total"] integerValue];
            [weakSelf.dataArray removeAllObjects];
            
            [DDDModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"orderItems" : [ItemsModel class],
                         };
            }];
            for (NSDictionary *temp in array) {
                DDDModel *model = [DDDModel mj_objectWithKeyValues:temp];
                
                AddressModel *addressmodel = [AddressModel mj_objectWithKeyValues:model.orderAddress];
                MapModel *mapmodel = [MapModel mj_objectWithKeyValues:model.map];
                
                model.addressmodel = addressmodel;
                model.mapmodel = mapmodel;
                
                [weakSelf.dataArray addObject:model];
            }
            page = 2;
            [weakSelf.tableview reloadData];
            _tableview.contentInset = UIEdgeInsetsZero;
            _tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableview.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableview.mj_header endRefreshing];
            _tableview.contentInset = UIEdgeInsetsZero;
            _tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
        }];
    }
}
- (void)loddeSLDDList:(NSString *)str2 {
    NSString *string;
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([[Manager sharedManager] redingwenjianming:@"showorder.text"].length == 0) {
        string = @" ";
    }else {
        string = [[Manager sharedManager] redingwenjianming:@"showorder.text"];
    }
    if (str2 != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"page":[NSString stringWithFormat:@"%ld",page],
                @"warehourse":str2,
                @"user_name ":[[Manager sharedManager] redingwenjianming:@"username.text"],
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                @"showorder":string,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"order", @"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList1"];
            
            [DDDModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"orderItems" : [ItemsModel class],
                         };
            }];
            for (NSDictionary *temp in array) {
                DDDModel *model = [DDDModel mj_objectWithKeyValues:temp];
                
                AddressModel *addressmodel = [AddressModel mj_objectWithKeyValues:model.orderAddress];
                MapModel *mapmodel = [MapModel mj_objectWithKeyValues:model.map];
                
                model.addressmodel = addressmodel;
                model.mapmodel = mapmodel;
                
                [weakSelf.dataArray addObject:model];
            }
            page ++;
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}

@end
