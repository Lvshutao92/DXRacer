//
//  TijiaodingdanViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/14.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "TijiaodingdanViewController.h"
#import "AddAddressViewController.h"

#import "AllViewController.h"
#import "ITEMCell.h"
#import "ShoppingListModel.h"

@interface TijiaodingdanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    UIView *dbview;//底部view
    UILabel *priceLabel;//总价
    
    UITableView *tableview;
    UIView *headerview;
    UIScrollView *scrollview;
    NSInteger height;
    //是否需要发票
    UIButton *isbtn;
    UIButton *nobtn;
    //发票类型
    UIButton *pu;
    UILabel *puLabel;
    UIButton *zeng;
    UILabel *zengLabel;
    //地址
    UILabel *onelab;
    UILabel *twolab;
    UILabel *threelab;
    //发票信息
    UITextField *fptextfie1;
    UITextField *fptextfie2;
    UITextField *fptextfie3;
    UITextField *fptextfie4;
    UITextField *fptextfie5;
    UITextField *fptextfie6;
    
    NSString *sendtimeStr;
    NSString *isornoFP;
    NSString *fpLX;
    
    NSString *str111;
    NSString *str222;
    NSString *str333;
    
    UIView *view1;

    UILabel *textlab;
    //下单信息
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UITextField *sourcetext;
    UITextField *moneytext;
    UITextView *textvie;
}
@property(nonatomic,strong)UITextField *textfiel;
@end

@implementation TijiaodingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate   = self;
    tableview.dataSource = self;
    [tableview registerNib:[UINib nibWithNibName:@"TJDD1Cell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [tableview registerNib:[UINib nibWithNibName:@"TJDD2Cell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [tableview registerClass:[ITEMCell class] forCellReuseIdentifier:@"cell3"];
    
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableview];
    
    isornoFP = @"N";
    sendtimeStr = @"任意时间";
    self.textfiel.delegate = self;
    height = 90;
    headerview = [[UIView alloc]init];
    headerview.backgroundColor = [UIColor colorWithWhite:.95 alpha:.4];
    
    scrollview = [[UIScrollView alloc]init];
    [headerview addSubview:scrollview];
    
    view1 = [[UIView alloc]init];
    [scrollview addSubview:view1];
    
    
    [self setupheaderview];
    
    [self setupBottomView];
    
}
- (void)setupheaderview {
    [self setuponeview];

    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(20, height+10, 100, 20)];
    lable.text = @"开具发票";
    lable.font = [UIFont systemFontOfSize:13];
    [scrollview addSubview:lable];
    
    nobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nobtn.frame = CGRectMake(20, height+40, 100, 30);
    nobtn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [nobtn setTitle:@"不需要" forState:UIControlStateNormal];
    nobtn.layer.masksToBounds = YES;
    nobtn.layer.cornerRadius = 7;
    nobtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nobtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nobtn addTarget:self action:@selector(clickno) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:nobtn];
   

    isbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    isbtn.frame = CGRectMake(140, height+40, 100, 30);
    isbtn.backgroundColor = [UIColor lightGrayColor];
    isbtn.layer.masksToBounds = YES;
    isbtn.layer.cornerRadius = 7;
    [isbtn setTitle:@"需要" forState:UIControlStateNormal];
    isbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [isbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [isbtn addTarget:self action:@selector(clickis) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:isbtn];
    
    isornoFP = @"N";
    sendtimeStr = @"任意时间";
    
    
    pu = [UIButton buttonWithType:UIButtonTypeCustom];
    pu.frame = CGRectMake(20, height+80, 30, 30) ;
    UIImage *theImage = [UIImage imageNamed:@"is"];
    pu.hidden = YES;
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [pu addTarget:self action:@selector(clickPU) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:pu];
    puLabel =[[UILabel alloc]initWithFrame:CGRectMake(55, height+80, 70, 30)];
    puLabel.text = @"普通发票";
    puLabel.hidden = YES;
    puLabel.font = [UIFont systemFontOfSize:13];
    [scrollview addSubview:puLabel];
    
    zeng = [UIButton buttonWithType:UIButtonTypeCustom];
    zeng.frame = CGRectMake(150, height+80, 30, 30) ;
    zeng.hidden = YES;
    [zeng setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [zeng addTarget:self action:@selector(clickZENG) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:zeng];
    zengLabel =[[UILabel alloc]initWithFrame:CGRectMake(185, height+80, 70, 30)];
    zengLabel.text = @"增值税发票";
    zengLabel.hidden = YES;
    zengLabel.font = [UIFont systemFontOfSize:13];
    [scrollview addSubview:zengLabel];
    
    fptextfie1 = [[UITextField alloc]initWithFrame:CGRectMake(20, height+120, SCREEN_WIDTH-40, 30)];
    [fptextfie1.layer setBorderWidth:1];
    fptextfie1.placeholder = @" 发票抬头";
     fptextfie1.hidden = YES;
    fptextfie1.delegate = self;
    [fptextfie1.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie1];
    
    fptextfie2 = [[UITextField alloc]initWithFrame:CGRectMake(20, height+160, SCREEN_WIDTH-40, 30)];
    [fptextfie2.layer setBorderWidth:1];
    fptextfie2.placeholder = @" 纳税人识别码";
    fptextfie2.hidden = YES;
    fptextfie2.delegate = self;
    [fptextfie2.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie2];
    
    fptextfie3= [[UITextField alloc]initWithFrame:CGRectMake(20, height+200, SCREEN_WIDTH-40, 30)];
    [fptextfie3.layer setBorderWidth:1];
    fptextfie3.hidden = YES;
    fptextfie3.delegate = self;
    fptextfie3.placeholder = @" 注册地址";
    [fptextfie3.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie3];
    
    
    fptextfie4 = [[UITextField alloc]initWithFrame:CGRectMake(20, height+240, SCREEN_WIDTH-40, 30)];
    [fptextfie4.layer setBorderWidth:1];
    fptextfie4.hidden = YES;
    fptextfie4.placeholder = @" 注册电话";
    fptextfie4.delegate = self;
    fptextfie4.keyboardType = UIKeyboardTypeNumberPad;
    [fptextfie4.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie4];
    
    fptextfie5= [[UITextField alloc]initWithFrame:CGRectMake(20, height+280, SCREEN_WIDTH-40,30)];
    [fptextfie5.layer setBorderWidth:1];
    fptextfie5.placeholder = @" 开户银行";
    fptextfie5.hidden = YES;
    fptextfie5.delegate = self;
    [fptextfie5.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie5];
    
    fptextfie6 = [[UITextField alloc]initWithFrame:CGRectMake(20, height+320, SCREEN_WIDTH-40, 30)];
    [fptextfie6.layer setBorderWidth:1];
    fptextfie6.placeholder = @" 银行账户";
    fptextfie6.hidden = YES;
    fptextfie6.delegate = self;
    fptextfie6.keyboardType = UIKeyboardTypeNumberPad;
    [fptextfie6.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [scrollview addSubview:fptextfie6];
    
     [fptextfie1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
     [fptextfie2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
     [fptextfie3 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
     [fptextfie4 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
     [fptextfie5 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
     [fptextfie6 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    view1.frame = CGRectMake(0, height+80, SCREEN_WIDTH, 170);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+250);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+250);
    
    tableview.tableHeaderView = headerview;
    
    
    [self setup];
}
- (void)setup{
    
    UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 20)];
    lable.text = @"下单信息";
    lable.font = [UIFont systemFontOfSize:13];
//    [view1 addSubview:lable];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 40, 30, 30);
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn1 setImage:theImage forState:UIControlStateNormal];
    [btn1 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [btn1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:btn1];
    UILabel *lable1 =[[UILabel alloc]initWithFrame:CGRectMake(55, 45, SCREEN_WIDTH-115, 20)];
    lable1.text = @"任意时间";
    lable1.font = [UIFont systemFontOfSize:13];
//    [view1 addSubview:lable1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(20, 80, 30, 30);
    [btn2 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:btn2];
    UILabel *lable2 =[[UILabel alloc]initWithFrame:CGRectMake(55, 85, SCREEN_WIDTH-115, 20)];
    lable2.text = @"只双休日／假日送货(工作日不送货)";
    lable2.numberOfLines = 0;
    lable2.font = [UIFont systemFontOfSize:13];
//    [view1 addSubview:lable2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(20, 120, 30, 30);
    [btn3 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:btn3];
    UILabel *lable3 =[[UILabel alloc]initWithFrame:CGRectMake(55, 115, SCREEN_WIDTH-115, 50)];
    lable3.text = @"只工作日送货(双休日／假日不送)(注：写字楼／商用地址客户请选择)";
    lable3.numberOfLines = 0;
    lable3.font = [UIFont systemFontOfSize:13];
//    [view1 addSubview:lable3];
    
    
    UILabel *la1 =[[UILabel alloc]initWithFrame:CGRectMake(20, 25, 85, 20)];
    la1.text = @"来源单号";
    la1.font = [UIFont systemFontOfSize:13];
    [view1 addSubview:la1];
    sourcetext = [[UITextField alloc]initWithFrame:CGRectMake(110, 20, SCREEN_WIDTH-125, 30)];
    sourcetext.placeholder = @"  淘宝或京东单号，没有可不填";
    [sourcetext setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    sourcetext.delegate = self;
    sourcetext.keyboardType = UIKeyboardTypeNumberPad;
    sourcetext.borderStyle  = UITextBorderStyleNone;
    [sourcetext.layer setBorderWidth:1];
    [sourcetext.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [view1 addSubview:sourcetext];
    
    UILabel *la2 =[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 85, 20)];
    la2.text = @"客户实付金额";
    la2.font = [UIFont systemFontOfSize:13];
    la2.numberOfLines= 0;
    la2.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:la2];
    moneytext = [[UITextField alloc]initWithFrame:CGRectMake(110, 55, SCREEN_WIDTH-125, 30)];
    moneytext.borderStyle  = UITextBorderStyleNone;
    moneytext.delegate = self;
    moneytext.placeholder = @"  必填";
     [moneytext setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    moneytext.keyboardType = UIKeyboardTypeNumberPad;
    [moneytext.layer setBorderWidth:1];
    [moneytext.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [view1 addSubview:moneytext];
    
    
    UILabel *la3 =[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 85, 20)];
    la3.text = @"下单留言";
    la3.font = [UIFont systemFontOfSize:13];
    [view1 addSubview:la3];
    textvie = [[UITextView alloc]initWithFrame:CGRectMake(110, 95, SCREEN_WIDTH-125, 70)];
    [textvie.layer setBorderWidth:1];
    textvie.delegate = self;
    
    textlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-145, 20)];
    if (textvie.text.length == 0) {
        textlab.text = @"请输入下单留言(可不填)";
    }
    textlab.font = [UIFont systemFontOfSize:13];
    textlab.textColor = [UIColor lightGrayColor];
    [textvie addSubview:textlab];
    
    
    [textvie.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [view1 addSubview:textvie];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textlab.hidden = YES;
    return YES;
}
- (void)clickno {
    isornoFP = @"N";
    fpLX = nil;
    
    pu.hidden = YES;
    puLabel.hidden = YES;
    zeng.hidden = YES;
    zengLabel.hidden = YES;
    fptextfie1.hidden = YES;
    fptextfie2.hidden = YES;
    
    fptextfie3.hidden = YES;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [zeng setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    
    
    nobtn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    isbtn.backgroundColor = [UIColor lightGrayColor];
    
    view1.frame = CGRectMake(0, height+80, SCREEN_WIDTH, 170);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+250);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+250);
    
    tableview.tableHeaderView = headerview;
    
}
- (void)clickis {
    isornoFP = @"Y";
    fpLX = @"普通发票";
    
    pu.hidden = NO;
    puLabel.hidden = NO;
    zeng.hidden = NO;
    zengLabel.hidden = NO;
    fptextfie1.hidden = NO;
    fptextfie2.hidden = NO;
    
    
    isbtn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    nobtn.backgroundColor = [UIColor lightGrayColor];
    
    [self setupXuYaoFaPiao];
    
    view1.frame = CGRectMake(0, height+200, SCREEN_WIDTH, 170);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    
    tableview.tableHeaderView = headerview;
}
- (void)setupXuYaoFaPiao {
    view1.frame = CGRectMake(0, height+200, SCREEN_WIDTH, 170);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    tableview.tableHeaderView = headerview;
}
- (void)clickPU {
    
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pu setImage:theImage forState:UIControlStateNormal];
    [pu setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [zeng setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    
    fptextfie3.hidden = YES;
    fptextfie4.hidden = YES;
    fptextfie5.hidden = YES;
    fptextfie6.hidden = YES;
    
    view1.frame = CGRectMake(0, height+200, SCREEN_WIDTH, 180);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+380);
    tableview.tableHeaderView = headerview;
    isornoFP = @"Y";
    fpLX = @"普通发票";
}
- (void)clickZENG {
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [zeng setImage:theImage forState:UIControlStateNormal];
    [zeng setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [pu setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    
    fptextfie3.hidden = NO;
    fptextfie4.hidden = NO;
    fptextfie5.hidden = NO;
    fptextfie6.hidden = NO;
    view1.frame = CGRectMake(0, height+340, SCREEN_WIDTH, 170);
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+530);
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+530);
    tableview.tableHeaderView = headerview;
    isornoFP = @"Y";
    fpLX = @"增值税发票";
}
- (void)click1 {
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn1 setImage:theImage forState:UIControlStateNormal];
    [btn1 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    [btn2 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    sendtimeStr = @"任意时间";
}
- (void)click2 {
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn2 setImage:theImage forState:UIControlStateNormal];
    [btn2 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [btn1 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    sendtimeStr = @"只双休日、假日送货(工作日不送货)";
}
- (void)click3 {
    UIImage *theImage = [UIImage imageNamed:@"is"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn3 setImage:theImage forState:UIControlStateNormal];
    [btn3 setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    [btn1 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    sendtimeStr = @"只工作日送货(双休日、假日不用送)";
}


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
    
    ITEMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShoppingListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    cell.labone.text = model.chair_color_name;
    cell.labfive.text = model.skuname;
    cell.labfour.text = [NSString stringWithFormat:@"数量：%@",model.amount];
    
    
    cell.labtwo.text = [NSString stringWithFormat:@"供货价：%@",[Manager jinegeshi:model.realprice]];
    cell.labtwo.textColor = [UIColor blackColor];
    cell.labthree.text = [NSString stringWithFormat:@"小计：%@",[Manager jinegeshi:[NSString stringWithFormat:@"%ld",[model.realprice integerValue]*[model.amount integerValue]]]];
    [cell.imageViewpic sd_setImageWithURL:[NSURL URLWithString:NSString(model.img_url)]];
    cell.imageViewpic.contentMode = UIViewContentModeScaleAspectFit;
    cell.addBtn.hidden = YES;
    return cell;
}


- (void)setupBottomView{
    //底部视图的 背景
    dbview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    dbview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dbview];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [dbview addSubview:line];
    //提交订单按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH-100, 0, 120, 50);
    btn.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitDD) forControlEvents:UIControlEventTouchUpInside];
    [dbview addSubview:btn];
    //价格
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH-130, 30)];
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
        priceLabel.textAlignment = NSTextAlignmentRight;
        [dbview addSubview:priceLabel];
    }
    [self.view bringSubviewToFront:dbview];
}


//提交订单
- (void)commitDD {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (ShoppingListModel *model in self.dataArr) {
        [arr addObject:model.shoppingcartid];
    }
    [self lodCommitDingDan:arr];
}
//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIControl *view = [[UIControl alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:.85 alpha:.3];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 5);
    return view;
}
//收货地址
- (void)setuponeview {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChangeAddress:)];
    [view addGestureRecognizer:tap];
    [scrollview addSubview:view];
    
    onelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 130, 25)];
    onelab.font = [UIFont systemFontOfSize:13];
    [view addSubview:onelab];
    
    twolab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, 5, 130, 25)];
    twolab.font = [UIFont systemFontOfSize:13];
    twolab.textAlignment = NSTextAlignmentRight;
    [view addSubview:twolab];
    
    threelab = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-80, 60)];
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
    
    
    three.str1   = [Manager sharedManager].addr2 ;
    three.str2   = [Manager sharedManager].youbian;
    three.str3   = [Manager sharedManager].mobile;
    three.str4   = [Manager sharedManager].addressPhone;
    three.str5   = [Manager sharedManager].addressName;
    
    
    
    if ([Manager sharedManager].shenga.length != 0) {
        three.str6   = [NSString stringWithFormat:@"%@-%@-%@",[Manager sharedManager].shenga,[Manager sharedManager].shia,[Manager sharedManager].qua];
    }
    
    
    
    [self.navigationController pushViewController:three animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
    if ([Manager sharedManager].addressName.length == 0 || [Manager sharedManager].addressPhone.length == 0 || [Manager sharedManager].addressDetails.length == 0) {
       threelab.text = @"点击选择地址";
    }else {
        onelab.text = [NSString stringWithFormat:@"收货人：%@",[Manager sharedManager].addressName];
        twolab.text = [Manager sharedManager].addressPhone;
        
        threelab.text = [NSString stringWithFormat:@"收货地址:%@",[Manager sharedManager].addressDetails];
        
    }
    self.tabBarController.tabBar.hidden = YES;
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


- (void)lodCommitDingDan:(NSMutableArray *)ids{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([Manager sharedManager].youbian.length != 0) {
        [Manager sharedManager].youbian = @" ";
    }
    if ([Manager sharedManager].mobile.length != 0) {
        [Manager sharedManager].mobile = @" ";
    }

    if ([Manager sharedManager].shenga.length != 0 &&
        [Manager sharedManager].shia.length != 0 &&
        [Manager sharedManager].qua.length != 0 &&
        [Manager sharedManager].addr2.length != 0 &&
        [Manager sharedManager].addressName.length != 0 &&
        [Manager sharedManager].addressPhone.length != 0){

        if ([isornoFP isEqualToString:@"Y"]) {
            if ([fpLX isEqualToString:@"普通发票"]) {
                if (fptextfie1.text.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length != 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            @"order_resource_no":sourcetext.text,
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length == 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            
                            @"order_payment":moneytext.text,
                            @"order_resource_no":sourcetext.text,
                            
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length != 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length == 0 && moneytext.text.length != 0 && fptextfie2.text.length != 0){
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            
                            @"order_payment":moneytext.text,
                            @"sendtime":@"任意时间",
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
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            
                            @"order_resource_no":sourcetext.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && fptextfie2.text.length != 0 && fptextfie3.text.length != 0 && fptextfie4.text.length != 0 && fptextfie5.text.length != 0 && fptextfie6.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length == 0 && textvie.text.length != 0 && moneytext.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_payment":moneytext.text,
                            @"buyer_note":textvie.text,
                            
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else if (fptextfie1.text.length != 0 && fptextfie2.text.length != 0 && fptextfie3.text.length != 0 && fptextfie4.text.length != 0 && fptextfie5.text.length != 0 && fptextfie6.text.length != 0 && sendtimeStr.length != 0 && isornoFP.length != 0 && fpLX.length != 0 && sourcetext.text.length != 0 && textvie.text.length == 0 && moneytext.text.length != 0) {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_resource_no":sourcetext.text,
                            @"order_payment":moneytext.text,
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
                else {
                    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                            @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                            @"ids":ids,
                            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                            
                            @"receiver_state":[Manager sharedManager].shenga,
                            @"receiver_city ":[Manager sharedManager].shia,
                            @"receiver_district":[Manager sharedManager].qua,
                            @"receiver_address":[Manager sharedManager].addr2,
                            @"receiver_name":[Manager sharedManager].addressName,
                            @"receiver_phone":[Manager sharedManager].addressPhone,
                            @"receiver_zip":[Manager sharedManager].youbian,
                            @"receiver_mobile":[Manager sharedManager].mobile,
                            
                            @"invoice_title":fptextfie1.text,
                            @"invoice_code":fptextfie2.text,
                            @"invoice_addr":fptextfie3.text,
                            @"invoice_tel":fptextfie4.text,
                            @"invoice_bank":fptextfie5.text,
                            @"invoice_bankNo":fptextfie6.text,
                            @"order_payment":moneytext.text,
                            @"sendtime":@"任意时间",
                            @"needInvoice":isornoFP,
                            @"invoice_type":fpLX,
                            };
                }
            }
        }
        else {
            if (isornoFP.length != 0 && moneytext.text.length != 0 && textvie.text.length != 0 && sourcetext.text.length != 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        
                        @"receiver_state":[Manager sharedManager].shenga,
                        @"receiver_city ":[Manager sharedManager].shia,
                        @"receiver_district":[Manager sharedManager].qua,
                        @"receiver_address":[Manager sharedManager].addr2,
                        @"receiver_name":[Manager sharedManager].addressName,
                        @"receiver_phone":[Manager sharedManager].addressPhone,
                        @"receiver_zip":[Manager sharedManager].youbian,
                        @"receiver_mobile":[Manager sharedManager].mobile,
                        
                        @"order_resource_no":sourcetext.text,
                        @"order_payment":moneytext.text,
                        @"buyer_note":textvie.text,
                        @"sendtime":@"任意时间",
                        @"needInvoice":isornoFP,
                        };
            }
            else if (isornoFP.length != 0 && moneytext.text.length != 0 && textvie.text.length == 0 && sourcetext.text.length != 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        
                        @"receiver_state":[Manager sharedManager].shenga,
                        @"receiver_city ":[Manager sharedManager].shia,
                        @"receiver_district":[Manager sharedManager].qua,
                        @"receiver_address":[Manager sharedManager].addr2,
                        @"receiver_name":[Manager sharedManager].addressName,
                        @"receiver_phone":[Manager sharedManager].addressPhone,
                        @"receiver_zip":[Manager sharedManager].youbian,
                        @"receiver_mobile":[Manager sharedManager].mobile,
                        
                        @"order_resource_no":sourcetext.text,
                        @"order_payment":moneytext.text,
                        @"sendtime":@"任意时间",
                        @"needInvoice":isornoFP,
                        };
            }
            else if (isornoFP.length != 0 && moneytext.text.length != 0 && textvie.text.length != 0 && sourcetext.text.length == 0) {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        
                        @"receiver_state":[Manager sharedManager].shenga,
                        @"receiver_city ":[Manager sharedManager].shia,
                        @"receiver_district":[Manager sharedManager].qua,
                        @"receiver_address":[Manager sharedManager].addr2,
                        @"receiver_name":[Manager sharedManager].addressName,
                        @"receiver_phone":[Manager sharedManager].addressPhone,
                        @"receiver_zip":[Manager sharedManager].youbian,
                        @"receiver_mobile":[Manager sharedManager].mobile,
                        
                        @"buyer_note":textvie.text,
                        @"order_payment":moneytext.text,
                        @"sendtime":@"任意时间",
                        @"needInvoice":isornoFP,
                        };
            }
            else {
                dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                        @"user_name":[[Manager sharedManager] redingwenjianming:@"username.text"],
                        @"ids":ids,
                        @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                        
                        @"receiver_state":[Manager sharedManager].shenga,
                        @"receiver_city ":[Manager sharedManager].shia,
                        @"receiver_district":[Manager sharedManager].qua,
                        @"receiver_address":[Manager sharedManager].addr2,
                        @"receiver_name":[Manager sharedManager].addressName,
                        @"receiver_phone":[Manager sharedManager].addressPhone,
                        @"receiver_zip":[Manager sharedManager].youbian,
                        @"receiver_mobile":[Manager sharedManager].mobile,
                        
                        @"order_payment":moneytext.text,
                        @"sendtime":@"任意时间",
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
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"购买数量大于您的安全库存\n或信息不完整\n或余额不足" preferredStyle:1];                
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
@end
