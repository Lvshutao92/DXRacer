//
//  FinalTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "FinalTableViewController.h"
#import "MineThreeViewController.h"
#import "AddAddressViewController.h"

#import "AllViewController.h"
#import "ITEMCell.h"
#import "JXTicketView.h"
#import "ACPayPwdAlert.h"
#import "FKFSView.h"
#import "ShoppingListModel.h"
@interface FinalTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIView *dbview;//底部view
    UILabel *priceLabel;//总价
    
    UILabel *onelab;
    UILabel *twolab;
    UILabel *threelab;
    //下单信息
    UIView *xiadanview;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UITextField *sourcetext;
    UITextField *moneytext;
    UITextView *textvie;
    
    //发票信息
    UIScrollView *fpscrollview;
    UIButton *isbtn;
    UIButton *nobtn;
    
    UIButton *pu;
    UILabel *puLabel;
    UIButton *zeng;
    UILabel *zengLabel;
    
    UITextField *fptextfie1;
    UITextField *fptextfie2;
    UITextField *fptextfie3;
    UITextField *fptextfie4;
    UITextField *fptextfie5;
    UITextField *fptextfie6;
    
    
    NSString *sendtimeStr;
    NSString *isornoFP;
    NSString *fpLX;
}
@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)UITextField *textfiel;

@property (nonatomic, strong) JXTicketView *ticketView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) FKFSView *fkfsview;
@property (nonatomic, strong) UIView *fkview;

@end

@implementation FinalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"jsdetailsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    self.textfiel.delegate = self;
    
    isornoFP = @"N";
    sendtimeStr = @"任意时间";
    
    [self setupscrooview];
    [self setupBottomView];
    [self setuphiddenView];
    
//    NSLog(@"%ld",self.dataArr.count);
 }


- (void)setupscrooview{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 530)];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.delegate = self;
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, 530);
    self.tableview.tableHeaderView = self.scrollview;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

//收货地址
- (void)setuponeview {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChangeAddress:)];
    [view addGestureRecognizer:tap];
    [self.scrollview addSubview:view];

    onelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 130, 25)];
    onelab.text = [NSString stringWithFormat:@"收货人：%@",[Manager sharedManager].addressName];
    onelab.font = [UIFont systemFontOfSize:13];
    [view addSubview:onelab];
    
    twolab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, 5, 130, 25)];
    twolab.text = [Manager sharedManager].addressPhone;
    twolab.font = [UIFont systemFontOfSize:13];
    twolab.textAlignment = NSTextAlignmentRight;
    [view addSubview:twolab];
    
    threelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-80, 60)];
    
    threelab.text = [NSString stringWithFormat:@"收货地址%@",[Manager sharedManager].addressDetails];
    
    threelab.font = [UIFont systemFontOfSize:13];
    threelab.numberOfLines = 0;
    [view addSubview:threelab];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 32.5, 25, 25)];
    imageview.image = [UIImage imageNamed:@"address"];
    [view addSubview:imageview];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 89.7, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    UIImageView *imageviewright = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 35, 20, 20)];
    imageviewright.image = [UIImage imageNamed:@"back"];
    [view addSubview:imageviewright];
}
- (void)clickChangeAddress:(UITapGestureRecognizer *)gesture {
    AddAddressViewController *three = [[AddAddressViewController alloc]init];
    three.navigationItem.title = @"添加收货地址";
    [self.navigationController pushViewController:three animated:YES];
}
//发票信息
- (void)setuptwoview {
    fpscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 85)];
    fpscrollview.showsHorizontalScrollIndicator = NO;
    [self.scrollview addSubview:fpscrollview];
 
    
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    lable.text = @"开具发票";
    lable.textColor = RGBACOLOR(32, 157, 149, 1.0);
    [fpscrollview addSubview:lable];
    
    
    nobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nobtn.frame = CGRectMake(85, 10, 30, 30);
    
    UIImage *theImage1 = [UIImage imageNamed:@"cart_selected_btn"];
    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [nobtn setImage:theImage1 forState:UIControlStateNormal];
    [nobtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [nobtn addTarget:self action:@selector(clickno) forControlEvents:UIControlEventTouchUpInside];
    [fpscrollview addSubview:nobtn];
    UILabel *nolable =[[UILabel alloc]initWithFrame:CGRectMake(115, 15, 60, 20)];
    nolable.text = @"不需要";
    nolable.font = [UIFont systemFontOfSize:13];
    [fpscrollview addSubview:nolable];
    
    
    isbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    isbtn.frame = CGRectMake(85, 50, 30, 30);
    [isbtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [isbtn addTarget:self action:@selector(clickis) forControlEvents:UIControlEventTouchUpInside];
    [fpscrollview addSubview:isbtn];
    UILabel *islable =[[UILabel alloc]initWithFrame:CGRectMake(115, 55, 35, 20)];
    islable.text = @"需要";
    islable.font = [UIFont systemFontOfSize:13];
    [fpscrollview addSubview:islable];
    
    isornoFP = @"N";
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 84.7, 835, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [fpscrollview addSubview:line];
}
- (void)clickno {
//    [nobtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [nobtn setImage:theImage forState:UIControlStateNormal];
    [nobtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    
    
    [isbtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    fpscrollview.contentSize = CGSizeMake(SCREEN_WIDTH, 85);
    pu.hidden = YES;
    puLabel.hidden = YES;
    zeng.hidden = YES;
    zengLabel.hidden = YES;
    
    fptextfie1.hidden = YES;
    fptextfie3.hidden = YES;
    fptextfie2.hidden = YES;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    isornoFP = @"N";
    fpLX = nil;
}
- (void)clickis {
    [nobtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    

    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [isbtn setImage:theImage forState:UIControlStateNormal];
    [isbtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    UIImage *theImage1 = [UIImage imageNamed:@"cart_selected_btn"];
    theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage1 forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    [zeng setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    
    fpscrollview.contentSize = CGSizeMake(SCREEN_WIDTH*1.3, 85);
    pu.hidden = NO;
    puLabel.hidden = NO;
    zeng.hidden = NO;
    zengLabel.hidden = NO;
    fptextfie1.hidden = NO;
    
    fptextfie3.hidden = YES;
    fptextfie2.hidden = NO;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    isornoFP = @"Y";
    fpLX = @"普通发票";
}
//下单信息
- (void)setupthreeview {
    
    xiadanview = [[UIView alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 350)];
    [self.scrollview addSubview:xiadanview];
    
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    lable.text = @"下单信息";
    lable.textColor = RGBACOLOR(32, 157, 149, 1.0);
    [xiadanview addSubview:lable];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(85, 10, 30, 30);
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn1 setImage:theImage forState:UIControlStateNormal];
    [btn1 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [xiadanview addSubview:btn1];
    UILabel *lable1 =[[UILabel alloc]initWithFrame:CGRectMake(115, 15, SCREEN_WIDTH-115, 20)];
    lable1.text = @"任意时间";
    lable1.font = [UIFont systemFontOfSize:13];
    [xiadanview addSubview:lable1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(85, 60, 30, 30);
    [btn2 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [xiadanview addSubview:btn2];
    UILabel *lable2 =[[UILabel alloc]initWithFrame:CGRectMake(115, 50, SCREEN_WIDTH-115, 50)];
    lable2.text = @"只双休日／假日送货(工作日不送货)";
    lable2.numberOfLines = 0;
    lable2.font = [UIFont systemFontOfSize:13];
    [xiadanview addSubview:lable2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(85, 110, 30, 30);
    [btn3 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    [xiadanview addSubview:btn3];
    UILabel *lable3 =[[UILabel alloc]initWithFrame:CGRectMake(115, 105, SCREEN_WIDTH-115, 50)];
    lable3.text = @"只工作日送货(双休日／假日不送)(注：写字楼／商用地址客户请选择)";
    lable3.numberOfLines = 0;
    lable3.font = [UIFont systemFontOfSize:13];
    [xiadanview addSubview:lable3];
    
    
    UILabel *la1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 170, 85, 20)];
    la1.text = @"来源单号";
    la1.font = [UIFont systemFontOfSize:13];
    [xiadanview addSubview:la1];
    sourcetext = [[UITextField alloc]initWithFrame:CGRectMake(100, 165, SCREEN_WIDTH-110, 30)];
    sourcetext.placeholder = @" 淘宝或京东单号，没有可不填";
    [sourcetext setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    sourcetext.delegate = self;
    sourcetext.keyboardType = UIKeyboardTypeNumberPad;
    sourcetext.borderStyle  = UITextBorderStyleNone;
    [sourcetext.layer setBorderWidth:1];
    [sourcetext.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [xiadanview addSubview:sourcetext];
    
    UILabel *la2 =[[UILabel alloc]initWithFrame:CGRectMake(10, 210, 85, 50)];
    la2.text = @"客户实付金额";
    la2.font = [UIFont systemFontOfSize:13];
    la2.numberOfLines= 0;
    la2.textAlignment = NSTextAlignmentLeft;
    [xiadanview addSubview:la2];
    moneytext = [[UITextField alloc]initWithFrame:CGRectMake(100, 220, SCREEN_WIDTH-110, 30)];
    moneytext.borderStyle  = UITextBorderStyleNone;
    moneytext.delegate = self;
    moneytext.keyboardType = UIKeyboardTypeNumberPad;
    [moneytext.layer setBorderWidth:1];
    [moneytext.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [xiadanview addSubview:moneytext];
    
    
    UILabel *la3 =[[UILabel alloc]initWithFrame:CGRectMake(10, 300, 85, 20)];
    la3.text = @"下单留言";
    la3.font = [UIFont systemFontOfSize:13];
    [xiadanview addSubview:la3];
    textvie = [[UITextView alloc]initWithFrame:CGRectMake(100, 275, SCREEN_WIDTH-110, 70)];
    [textvie.layer setBorderWidth:1];
    textvie.delegate = self;
    [textvie.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [xiadanview addSubview:textvie];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 349.7, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [xiadanview addSubview:line];
    
    sendtimeStr = @"任意时间";
}
- (void)click1 {
    [btn1 setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    sendtimeStr = @"任意时间";
}
- (void)click2 {
    [btn1 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
     sendtimeStr = @"只双休日、假日送货(工作日不送货)";
}
- (void)click3 {
    [btn1 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
     sendtimeStr = @"只工作日送货(双休日、假日不用送)";
}
//单据明细
#pragma mark--------UITableViewDelegate-----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
        return 150;
    }else {
        return 200;
    }
    return 200;
}
#pragma mark--------UITableViewDataSource-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ITEMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShoppingListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    cell.labone.text = model.chair_color_name;
    cell.labfive.text = model.skuname;
    cell.labfour.text = [NSString stringWithFormat:@"数量：%@",model.amount];
    cell.labtwo.text = [NSString stringWithFormat:@"供货价：%@",model.realprice];
    
    cell.labthree.text = [NSString stringWithFormat:@"小计：%ld",[model.realprice integerValue]*[model.amount integerValue]];
    
    
    [cell.imageViewpic sd_setImageWithURL:[NSURL URLWithString:NSString(model.img_url)]];
    cell.imageViewpic.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

//提交订单
- (void)commitDD {
//    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.maskView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
//    [self.view addSubview:self.maskView];
//    
//    self.ticketView = [[JXTicketView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400)];
//    self.ticketView.backgroundColor = [UIColor grayColor];
//    self.ticketView.delegate = self;
//    
//    [self.maskView addSubview:self.ticketView];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.ticketView.frame = CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_HEIGHT, 400);
//    }];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (ShoppingListModel *model in self.dataArr) {
        [arr addObject:model.shoppingcartid];
    }
    [self lodCommitDingDan:arr];
}
//- (void)closeBtnDidClicked {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.ticketView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 400);
//    } completion:^(BOOL finished) {
//        self.maskView.hidden = YES;
//    }];
//}
//- (void)ensureBtnDidClicked {
//    ACPayPwdAlert *alert = [[ACPayPwdAlert alloc]init];
//    alert.title = @"请输入支付密码";
//    alert.completeAction = ^(NSString *pwd){
//       NSLog(@"%@",pwd);
//    };
//    [alert show];
//}
////问题疑问
//- (void)problomeBtnDidClicked {
//    NSLog(@"问题疑问");
//}
////选择付款方式
//- (void)clickSelectedFuKuanFangshi {
//    NSLog(@"选择付款方式");
//    self.fkview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.fkview.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
//    [self.view addSubview:self.fkview];
//    
//    self.fkfsview = [[FKFSView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 400)];
//    self.fkfsview.backgroundColor = [UIColor grayColor];
//    self.fkfsview.delegate = self;
//    
//    [self.fkview addSubview:self.fkfsview];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.fkfsview.frame = CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_HEIGHT, 400);
//    }];
//}
//- (void)clickCancle {
//    [UIView animateWithDuration:0.5 animations:^{
//        self.fkfsview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 400);
//    } completion:^(BOOL finished) {
//        self.fkview.hidden = YES;
//    }];
//}



- (void)lodCommitDingDan:(NSMutableArray *)ids{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    
    if ([[Manager sharedManager] redingwenjianming:@"receiver_state.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_city.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_district.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_address.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_name.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_phone.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_zip.text"].length != 0 &&
        [[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"].length != 0){
        
        if ([isornoFP isEqualToString:@"Y"]) {
            if ([fpLX isEqualToString:@"普通发票"]) {
                if (fptextfie1.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length != 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            @"order_resource_no":sourcetext.text,
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length == 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"order_payment":moneytext.text,
                            @"order_resource_no":sourcetext.text,
                            
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length != 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length == 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0){
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"order_payment":moneytext.text,
                            
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
            }
            else {
                if (fptextfie1.text.length != 0 && fptextfie2.text.length != 0 && fptextfie3.text.length != 0 && fptextfie4.text.length != 0 && fptextfie5.text.length != 0 && fptextfie6.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length != 0 && moneytext.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            
                            @"order_resource_no":sourcetext.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && fptextfie2.text.length != 0 && fptextfie3.text.length != 0 && fptextfie4.text.length != 0 && fptextfie5.text.length != 0 && fptextfie6.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length != 0 && moneytext.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && fptextfie2.text.length != 0 && fptextfie3.text.length != 0 && fptextfie4.text.length != 0 && fptextfie5.text.length != 0 && fptextfie6.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length == 0 && moneytext.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_resource_no":sourcetext.text,
                            @"order_payment":moneytext.text,
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                            @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                            @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                            @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                            @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                            @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                            @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                            @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_payment":moneytext.text,
                            @"sendtime":sendtimeStr,
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
            }
        }
        else {
            if (isornoFP.length != 0 && sendtimeStr.length != 0 && moneytext.text.length != 0 && textvie.text.length != 0 && sourcetext.text.length != 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                        @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                        @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                        @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                        @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                        @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                        @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                        @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                        @"order_resource_no":sourcetext.text,
                        @"order_payment":moneytext.text,
                        @"buyer_note":textvie.text,
                        @"sendtime":sendtimeStr,
                        @"needInvoice":isornoFP,
                        };
            }
            else if (isornoFP.length != 0 && sendtimeStr.length != 0 && moneytext.text.length != 0 && textvie.text.length == 0 && sourcetext.text.length != 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                        @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                        @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                        @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                        @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                        @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                        @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                        @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                        @"order_resource_no":sourcetext.text,
                        @"order_payment":moneytext.text,
                        @"sendtime":sendtimeStr,
                        @"needInvoice":isornoFP,
                        };
            }
            else if (isornoFP.length != 0 && sendtimeStr.length != 0 && moneytext.text.length != 0 && textvie.text.length != 0 && sourcetext.text.length == 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                        @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                        @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                        @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                        @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                        @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                        @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                        @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                        @"buyer_note":textvie.text,
                        @"order_payment":moneytext.text,
                        @"sendtime":sendtimeStr,
                        @"needInvoice":isornoFP,
                        };
            }
            else {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        @"receiver_state":[[Manager sharedManager] redingwenjianming:@"receiver_state.text"],
                        @"receiver_city ":[[Manager sharedManager] redingwenjianming:@"receiver_city.text"],
                        @"receiver_district":[[Manager sharedManager] redingwenjianming:@"receiver_district.text"],
                        @"receiver_address":[[Manager sharedManager] redingwenjianming:@"receiver_address.text"],
                        @"receiver_name":[[Manager sharedManager] redingwenjianming:@"receiver_name.text"],
                        @"receiver_phone":[[Manager sharedManager] redingwenjianming:@"receiver_phone.text"],
                        @"receiver_zip":[[Manager sharedManager] redingwenjianming:@"receiver_zip.text"],
                        @"receiver_mobile":[[Manager sharedManager] redingwenjianming:@"receiver_mobile.text"],
                        @"order_payment":moneytext.text,
                        @"sendtime":sendtimeStr,
                        @"needInvoice":isornoFP,
                        };
            }
        }
//        NSLog(@"****%@",dic);
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"order",@"confirm") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//                    NSLog(@"==================%@",[dic objectForKey:@"result_msg"]);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                AllViewController *all = [[AllViewController alloc]init];
                all.navigationItem.title = @"所有订单";
                [weakSelf.navigationController pushViewController:all animated:YES];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买数量大于您的安全库存或信息不完整" message:@"" preferredStyle:1];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
        
        
        
    }
    
    
    
   
    
}

- (void)setupBottomView
{
    [self setuponeview];
    [self setuptwoview];
    [self setupthreeview];
    
    //底部视图的 背景
    dbview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    dbview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dbview];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [dbview addSubview:line];
    //提交订单按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, 50);
    btn.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitDD) forControlEvents:UIControlEventTouchUpInside];
    [dbview addSubview:btn];
    
    //价格
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-110, 30)];
    
    if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
        priceLabel.hidden = YES;
    }else {
        priceLabel.text = [NSString stringWithFormat:@"合计:%@",self.priceNum];
        priceLabel.textColor = RGBACOLOR(32, 157, 149, 1.0);
        priceLabel.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *notestr = [[NSMutableAttributedString alloc]initWithString:priceLabel.text];
        NSRange ran = NSMakeRange(0, 3);
        [notestr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran];
        [priceLabel setAttributedText:notestr];
        //    [priceLabel sizeToFit];
        priceLabel.textAlignment = NSTextAlignmentRight;
    }
    
    [dbview addSubview:priceLabel];
    
    
    
}
- (void)setuphiddenView {
    
    
    
    pu = [UIButton buttonWithType:UIButtonTypeCustom];
    pu.frame = CGRectMake(175, 10, 30, 30) ;
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [pu addTarget:self action:@selector(clickPU) forControlEvents:UIControlEventTouchUpInside];
    pu.hidden = YES;
    [fpscrollview addSubview:pu];
    puLabel =[[UILabel alloc]initWithFrame:CGRectMake(210, 15, 70, 20)];
    puLabel.text = @"普通发票";
    puLabel.hidden = YES;
    puLabel.font = [UIFont systemFontOfSize:13];
    [fpscrollview addSubview:puLabel];
    
    zeng = [UIButton buttonWithType:UIButtonTypeCustom];
    zeng.frame = CGRectMake(175, 50, 30, 30) ;
    [zeng setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    zeng.hidden = YES;
    [zeng addTarget:self action:@selector(clickZENG) forControlEvents:UIControlEventTouchUpInside];
    [fpscrollview addSubview:zeng];
    zengLabel =[[UILabel alloc]initWithFrame:CGRectMake(210, 55, 70, 20)];
    zengLabel.text = @"增值税发票";
    zengLabel.hidden = YES;
    zengLabel.font = [UIFont systemFontOfSize:13];
    [fpscrollview addSubview:zengLabel];
    
    
    
    fptextfie1 = [[UITextField alloc]initWithFrame:CGRectMake(290, 10, 170, 30)];
    [fptextfie1.layer setBorderWidth:1];
    fptextfie1.placeholder = @" 发票抬头";
    [fptextfie1.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie1];
    
    fptextfie2 = [[UITextField alloc]initWithFrame:CGRectMake(290, 45, 170, 30)];
    [fptextfie2.layer setBorderWidth:1];
    fptextfie2.placeholder = @" 纳税人识别码";
    [fptextfie2.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie2];
    
    
    fptextfie3= [[UITextField alloc]initWithFrame:CGRectMake(470, 10, 170, 30)];
    [fptextfie3.layer setBorderWidth:1];
    fptextfie3.placeholder = @" 注册地址";
    [fptextfie3.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie3];
    
    
    fptextfie4 = [[UITextField alloc]initWithFrame:CGRectMake(470, 45, 170, 30)];
    [fptextfie4.layer setBorderWidth:1];
    fptextfie4.placeholder = @" 注册电话";
    fptextfie4.keyboardType = UIKeyboardTypeNumberPad;
    [fptextfie4.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie4];
    
    
    fptextfie5= [[UITextField alloc]initWithFrame:CGRectMake(650, 10, 170, 30)];
    [fptextfie5.layer setBorderWidth:1];
    fptextfie5.placeholder = @" 开户银行";
    [fptextfie5.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie5];
    
    
    fptextfie6 = [[UITextField alloc]initWithFrame:CGRectMake(650, 45, 170, 30)];
    [fptextfie6.layer setBorderWidth:1];
    fptextfie6.placeholder = @" 银行账户";
    fptextfie6.keyboardType = UIKeyboardTypeNumberPad;
    [fptextfie6.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [fpscrollview addSubview:fptextfie6];
    
    fptextfie1.hidden = YES;
    fptextfie3.hidden = YES;
    fptextfie2.hidden = YES;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    
    fptextfie1.delegate = self;
    fptextfie2.delegate = self;
    fptextfie3.delegate = self;
    fptextfie4.delegate = self;
    fptextfie5.delegate = self;
    fptextfie6.delegate = self;
    
    //    [fptextfie1 setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [fptextfie1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [fptextfie2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [fptextfie3 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [fptextfie4 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [fptextfie5 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [fptextfie6 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
}
- (void)clickPU {
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [zeng setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    fpscrollview.contentSize = CGSizeMake(SCREEN_WIDTH*1.3, 85);
    fptextfie1.hidden = NO;
    fptextfie3.hidden = YES;
    fptextfie2.hidden = NO;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    isornoFP = @"Y";
    fpLX = @"普通发票";
}
- (void)clickZENG {
    [pu setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [zeng setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    fpscrollview.contentSize = CGSizeMake(835, 85);
    fptextfie1.hidden = NO;
    fptextfie3.hidden = NO;
    fptextfie2.hidden = NO;
    fptextfie4.hidden = NO;
    fptextfie5.hidden = NO;
    fptextfie6.hidden = NO;
    isornoFP = @"Y";
    fpLX = @"增值税发票";
}

//回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfiel = textField;
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfiel resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textfiel resignFirstResponder];
    [textvie resignFirstResponder];
    [fptextfie1 resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    [sourcetext resignFirstResponder];
    [moneytext resignFirstResponder];
    [textvie resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
    if ([Manager sharedManager].addressDetails == nil) {
        threelab.text = @"";
    }else {
        //threelab.text = nil;
        threelab.text = [NSString stringWithFormat:@"收获地址:%@",[Manager sharedManager].addressDetails];
    }
    if ([Manager sharedManager].addressPhone == nil) {
        twolab.text = @"";
    }else {
        twolab.text = [Manager sharedManager].addressPhone;
    }
    if ([Manager sharedManager].addressName == nil) {
        onelab.text = @"";
    }else {
        onelab.text = [NSString stringWithFormat:@"收货人：%@",[Manager sharedManager].addressName];
    }
    self.tabBarController.tabBar.hidden = YES;
}


@end
