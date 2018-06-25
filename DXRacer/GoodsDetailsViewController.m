//
//  GoodsDetailsViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/23.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "SkuimgModel.h"
#import "SDCycleScrollView.h"

#import "RowsModel.h"
#import "chairlogoListModel.h"
#import "chaircolorListModel.h"
#import "clothescolorListModel.h"
#import "clothessizeListModel.h"
#import "invenListModel.h"
#import "skuImageListModel.h"



@interface GoodsDetailsViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>
{
    UIView *dbview;
    UIScrollView  *bottomScrollView;
    
    CAGradientLayer *_gradientLayer;
    
    UITextField *numlable;
    NSInteger num;
    NSString *skucode;
    
    CGFloat shuxingHeight;
    CGFloat colorHeight;
    CGFloat sizeHeight;
    CGFloat sumHeight;
    UILabel *txlab;//购物车添加成功提醒
    
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollViewDemo;
    NSString *kucun;
    UILabel *kucunlab;
    NSString *jiage;
    UILabel *jiagelab;
    
    NSString *string;
    NSString *productid;
    NSString *strs;
    
     UILabel *l1;
     UILabel *l2;
     UILabel *l3;
     UILabel *l4;
    
    
}
/** 当前选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 当前选中的衣服尺码按钮 */
@property (nonatomic, strong) UIButton *selecteClothSizedButton;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *colorCodeArray;

@end

@implementation GoodsDetailsViewController
- (NSMutableArray *)colorArray {
    if (_colorArray == nil) {
        self.colorArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _colorArray;
}
- (NSMutableArray *)colorCodeArray {
    if (_colorCodeArray == nil) {
        self.colorCodeArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _colorCodeArray;
}
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
   
    num = 1;
    
    [self loddeDetails];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
}

- (void)loddeDetails {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (self.S_business_id != nil && self.S_id != nil && [[Manager sharedManager] redingwenjianming:@"user_id.text"] != nil) {
        
        dic = @{@"business_id":self.S_business_id,@"id":self.S_id,@"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]};
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"product", @"getProductDetailByid") parameters:para constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dic = [dict objectForKey:@"rows"];
            
//            NSLog(@"商品详情=======%@",dic);
            
            [RowsModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"chaircolorList" : [chaircolorListModel class],
                         @"chairlogoList" : [chairlogoListModel class],
                         @"clothescolorList" : [clothescolorListModel class],
                         @"clothessizeList" : [clothessizeListModel class],
                         @"invenList" : [invenListModel class],
                         @"skuImageList" : [skuImageListModel class],
                         };
            }];
            
            RowsModel *model = [RowsModel mj_objectWithKeyValues:dic];
            
            ProductModel *tempModel = [ProductModel mj_objectWithKeyValues:model.product];
            model.proModel = tempModel;
            
            skuImage0Model *tempModel1 = [skuImage0Model mj_objectWithKeyValues:model.skuImage0];
            model.skuImgModel = tempModel1;
            
            kucun = model.quantity;
            
            for (NSDictionary *dd in model.chaircolorList) {
                chaircolorListModel *model = [chaircolorListModel mj_objectWithKeyValues:dd];
                [weakSelf.colorCodeArray addObject:model];
                [weakSelf.colorArray addObject:model.chair_color_name];
            }
            
            [weakSelf setupBottomView];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}


- (void)setupBottomView{
    
    //底部scrollview
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    bottomScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bottomScrollView];
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 330*SCALE_HEIGHT, SCREEN_WIDTH, 0.3)];
    line0.backgroundColor = [UIColor lightGrayColor];
    [bottomScrollView addSubview:line0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickcancle:)];
    [bottomScrollView addGestureRecognizer:tap];
    
    //顶部图
    for (SkuimgModel *model in self.arr) {
        NSString *str = NSString(model.img_url);
        [[Manager sharedManager].totolimgArray addObject:str];
    }
    NSArray *imagesURLStrings = [Manager sharedManager].totolimgArray;
    _imagesURLStrings = imagesURLStrings;
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 330*SCALE_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    [bottomScrollView addSubview:cycleScrollView];
    
    
    //成功添加购物车提示
    txlab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2, (SCREEN_HEIGHT-50)/2, 240, 50)];
    txlab.text = @"添加成功，在购物车等您哦";
    txlab.layer.cornerRadius = 6;
    txlab.layer.masksToBounds = YES;
    txlab.textAlignment = NSTextAlignmentCenter;
    txlab.textColor = [UIColor whiteColor];
    txlab.backgroundColor = [UIColor colorWithWhite:.1 alpha:.5];
    txlab.hidden = YES;
    [self.view addSubview:txlab];
    
    
    
    //属性
    for (int i = 0; i < 4; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15,  (330*SCALE_HEIGHT + 10)+40*i, SCREEN_WIDTH - 30, 25)];
        if (i == 0) {
            l1= lab;
            l1.text = [NSString stringWithFormat:@"MODEL：%@",self.str1];
        }else if (i == 1){
            l2= lab;
            l2.text = [NSString stringWithFormat:@"类目：%@",self.str2];
        }else if (i == 2){
            l3= lab;
            l3.text = [NSString stringWithFormat:@"品牌：%@",self.str3];
        }else {
            l4= lab;
            l4.text = [NSString stringWithFormat:@"尺寸：%@",self.str4];
        }
        [bottomScrollView addSubview:lab];
    }
    
    kucunlab = [[UILabel alloc]initWithFrame:CGRectMake(15,  (330*SCALE_HEIGHT + 10)+160, SCREEN_WIDTH - 30, 25)];
    kucunlab.text = [NSString stringWithFormat:@"库存：%@",kucun];
    [bottomScrollView addSubview:kucunlab];
    
    
    shuxingHeight =  (330*SCALE_HEIGHT + 10)+185;
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, shuxingHeight + 10, SCREEN_WIDTH, 0.3)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [bottomScrollView addSubview:line1];
   
    //判断衣服还是椅子
    if ([self.strType isEqualToString:@"2"]) {
        [self setupClothingView];
    }
    else{
        [self setupChairView];
    }
    
    //底部视图的 背景
    dbview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    dbview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dbview];
    [self.view bringSubviewToFront:dbview];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [dbview addSubview:line];
    
    
    jiagelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50)];
    jiagelab.textAlignment = NSTextAlignmentCenter;
    jiagelab.textColor = RGBACOLOR(32, 157, 149, 1.0);
    [dbview addSubview:jiagelab];
    //加入购物车按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50);
    
    _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = btn.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = btn.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)RGBACOLOR(127, 223, 206, 1.0).CGColor,
                             (id)RGBACOLOR(32, 157, 149, 1.0).CGColor, nil ,nil];
    
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint   = CGPointMake(1.0, 1.0);
    [btn.layer insertSublayer:_gradientLayer atIndex:0];
    
    [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addShoopingCart) forControlEvents:UIControlEventTouchUpInside];
    [dbview addSubview:btn];
    //立即购买按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 50);
    btn1.backgroundColor = RGBACOLOR(32, 157, 149, 1.0);
    [btn1 setTitle:@"立即购买" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(atonceShooping) forControlEvents:UIControlEventTouchUpInside];
    [dbview addSubview:btn1];
    
}
//椅子view
- (void)setupChairView {
    //颜色
    UILabel *colorlab = [[UILabel alloc]initWithFrame:CGRectMake(15,  shuxingHeight+20, 55, 25)];
    colorlab.text = [NSString stringWithFormat:@"颜色："];
    [bottomScrollView addSubview:colorlab];
    
    
    int hangshu;
    if (self.colorArray.count % 3 == 0 ) {
        hangshu = (int )self.colorArray.count / 3;
    } else {
        hangshu = (int )self.colorArray.count / 3 + 1;
    }
    int k = 0;
    for (int i = 0; i < hangshu; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (k < self.colorArray.count) {
                btn.frame = CGRectMake(70 + j * ((SCREEN_WIDTH - 70)/3-10) + 20, shuxingHeight + i * 35 + 25, (SCREEN_WIDTH - 70)/3-20, 30);
                [btn setTitle:self.colorArray[k] forState:UIControlStateNormal];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:3];
                [btn.layer setBorderWidth:1];
                [btn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                btn.tag = k;
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn setTitleColor:RGBACOLOR(32, 157, 149, 1.0) forState:UIControlStateDisabled];
                [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [bottomScrollView addSubview:btn];
                if (k > self.colorArray.count)
                 {
                      [btn removeFromSuperview];
                 }
            }
            k++;
            colorHeight =  shuxingHeight + i * 35 + 45;
        }
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, colorHeight+20, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomScrollView addSubview:line];
    //数量
    UILabel *sizelab = [[UILabel alloc]initWithFrame:CGRectMake(15,  colorHeight+30, 55, 30)];
    sizelab.text = [NSString stringWithFormat:@"数量："];
    [bottomScrollView addSubview:sizelab];
    UIButton *cutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutbtn.frame = CGRectMake(90, colorHeight + 30, 60, 30);
    cutbtn.backgroundColor = [UIColor lightGrayColor];
    [cutbtn setTitle:@"-" forState:UIControlStateNormal];
    [cutbtn addTarget:self action:@selector(clickcut) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:cutbtn];
    
    numlable = [[UITextField alloc]initWithFrame:CGRectMake(150, colorHeight + 30, SCREEN_WIDTH-225, 30)];
    numlable.text = [NSString stringWithFormat:@"%ld",num];
    numlable.textAlignment = NSTextAlignmentCenter;
    [numlable.layer setBorderWidth:1];
    numlable.delegate = self;
    numlable.textColor = RGBACOLOR(32, 157, 149, 1.0);
    numlable.keyboardType = UIKeyboardTypeNumberPad;
    [numlable.layer setBorderColor:[UIColor colorWithWhite:.8 alpha:.5].CGColor];
    [bottomScrollView addSubview:numlable];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(SCREEN_WIDTH-75, colorHeight + 30, 60, 30);
    addbtn.backgroundColor = [UIColor lightGrayColor];
    [addbtn setTitle:@"+" forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(clickadd) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:addbtn];
    sumHeight = colorHeight + 90;
    bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, sumHeight+40);
}
//衣服view
- (void)setupClothingView {
    //颜色
    UILabel *colorlab = [[UILabel alloc]initWithFrame:CGRectMake(15,  shuxingHeight+20, 55, 25)];
    colorlab.text = [NSString stringWithFormat:@"颜色："];
    [bottomScrollView addSubview:colorlab];
    
    for (int i = 0; i < self.colorArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(70, shuxingHeight+20 + i * 35 , SCREEN_WIDTH - 90, 30);
        [btn setTitle:self.colorArray[i] forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:3];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBACOLOR(32, 157, 149, 1.0) forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(clickClothBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomScrollView addSubview:btn];
        
        colorHeight =  shuxingHeight+20 + i * 35 + 30;
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, colorHeight + 10, SCREEN_WIDTH, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomScrollView addSubview:line];
    //如果衣服加尺寸
    UILabel *numlab = [[UILabel alloc]initWithFrame:CGRectMake(15, colorHeight + 20, 55, 25)];
    numlab.text = [NSString stringWithFormat:@"尺码："];
    [bottomScrollView addSubview:numlab];
    
    int hangshu;
    if (self.colorArray.count % 4 == 0 ) {
        hangshu = (int )self.colorArray.count / 4;
    } else {
        hangshu = (int )self.colorArray.count / 4 + 1;
    }
    int m = 0;
    for (int i = 0; i < hangshu; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (m < self.colorArray.count) {
            btn.frame = CGRectMake(70 + j * ((SCREEN_WIDTH - 70)/4-10), colorHeight + i * 35 + 30, (SCREEN_WIDTH - 70)/4-20, 30);
            [btn setTitle:@"XL" forState:UIControlStateNormal];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:3];
            [btn.layer setBorderWidth:1];
            [btn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            btn.tag = 100 + m;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:RGBACOLOR(32, 157, 149, 1.0) forState:UIControlStateDisabled];
            [btn addTarget:self action:@selector(clickClothSizeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [bottomScrollView addSubview:btn];
            if (m > self.colorArray.count)
            {
                [btn removeFromSuperview];
            }
        }
            m++;
            sizeHeight =  colorHeight + i * 35 + 60;
        }
    }
    
    
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, sizeHeight + 10, SCREEN_WIDTH, 0.3)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [bottomScrollView addSubview:line1];
    //数量
    UILabel *sizelab = [[UILabel alloc]initWithFrame:CGRectMake(15,  sizeHeight+20, 55, 30)];
    sizelab.text = [NSString stringWithFormat:@"数量："];
    [bottomScrollView addSubview:sizelab];
    UIButton *cutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutbtn.frame = CGRectMake(70, sizeHeight+20, 70, 30);
    cutbtn.backgroundColor = [UIColor lightGrayColor];
    [cutbtn setTitle:@"-" forState:UIControlStateNormal];
    [cutbtn addTarget:self action:@selector(clickCothcut) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:cutbtn];
    numlable = [[UITextField alloc]initWithFrame:CGRectMake(140, sizeHeight+20, SCREEN_WIDTH-230, 30)];
    numlable.text = [NSString stringWithFormat:@"%ld",num];
    numlable.textAlignment = NSTextAlignmentCenter;
    [numlable.layer setBorderWidth:1];
    numlable.textColor = RGBACOLOR(32, 157, 149, 1.0);
    numlable.delegate = self;
    numlable.keyboardType = UIKeyboardTypeNumberPad;
    [numlable.layer setBorderColor:[UIColor colorWithWhite:.8 alpha:.5].CGColor];
    [bottomScrollView addSubview:numlable];
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(SCREEN_WIDTH-90, sizeHeight+20, 70, 30);
    addbtn.backgroundColor = [UIColor lightGrayColor];
    [addbtn setTitle:@"+" forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(clickCothadd) forControlEvents:UIControlEventTouchUpInside];
    [bottomScrollView addSubview:addbtn];
    sumHeight = sizeHeight + 90;
    
    bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, sumHeight+15);
    
    
    
}
//椅子选择颜色
- (void)clickBtn:(UIButton *)sender {
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    
    chaircolorListModel *model = [self.colorCodeArray objectAtIndex:sender.tag];
    strs = [NSString stringWithFormat:@"%@",model.chair_color_code];
    productid = [NSString stringWithFormat:@"%@",model.product_id];
    
    [self lodChaireColor];
}
- (void)lodChaireColor{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"strs":strs,
            @"type":self.strType,
            @"productid":productid,
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]
            };
//    NSLog(@"^^^^^^^^^^^^^^^%@",dic);
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"product", @"getSkuInventory") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        skucode = [[dic objectForKey:@"rows"] objectForKey:@"skucode"];
        jiage  = [[dic objectForKey:@"rows"] objectForKey:@"realprice"];
        kucun = [[[[dic objectForKey:@"rows"] objectForKey:@"skuList"] firstObject] objectForKey:@"availquantity"];
        
        kucunlab.text = [NSString stringWithFormat:@"库存：%@",kucun];
        kucunlab.textColor = RGBACOLOR(32, 157, 149, 1.0);
        NSMutableAttributedString *notestr = [[NSMutableAttributedString alloc]initWithString:kucunlab.text];
        NSRange ran = NSMakeRange(0, 3);
        [notestr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran];
        [kucunlab setAttributedText:notestr];
        
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"])  {
            jiagelab.text = @"";
        }else{
            
            jiagelab.text = [NSString stringWithFormat:@"%@",[Manager jinegeshi:jiage]];
        }
        l1.text = [NSString stringWithFormat:@"ITEMNO：%@",skucode];
//        NSLog(@"dic=======%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//衣服选择颜色
- (void)clickClothBtn:(UIButton *)sender {
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    [self lodClothSizeAndColor];
}
//衣服选择尺码
- (void)clickClothSizeBtn:(UIButton *)sender{
    self.selecteClothSizedButton.enabled = YES;
    sender.enabled = NO;
    self.selecteClothSizedButton = sender;
    [self lodClothSizeAndColor];
}
- (void)lodClothSizeAndColor{
    
}
























//椅子选择数量
- (void)clickcut {
    num = [numlable.text integerValue];
    if (num > 0) {
        num--;
        numlable.text = [NSString stringWithFormat:@"%ld",num];
    }
}
- (void)clickadd {
    num = [numlable.text integerValue];
    num++;
    numlable.text = [NSString stringWithFormat:@"%ld",num];
}
//衣服选择数量
- (void)clickCothcut {
    num = [numlable.text integerValue];
    if (num > 0) {
        num--;
        numlable.text = [NSString stringWithFormat:@"%ld",num];
    }
}
- (void)clickCothadd {
    num = [numlable.text integerValue];
    num++;
    numlable.text = [NSString stringWithFormat:@"%ld",num];
}

//加入购物车
- (void)addShoopingCart {
    string = @"addgouwuche";
    [self lodAddShoppingCart];
}


- (void)lodAddShoppingCart {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (skucode != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"sku_code":skucode,
                @"amount":[NSString stringWithFormat:@"%@",numlable.text],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"]};
//        NSLog(@"-------%@",dic);
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"shoppingcart", @"add") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                if ([string isEqualToString:@"addgouwuche"]) {
                    txlab.hidden = NO;
                    [self.view bringSubviewToFront:txlab];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        txlab.hidden = YES;
                    });
                }
                if ([string isEqualToString:@"lijigoumai"]) {
                    weakSelf.tabBarController.selectedIndex = 2;
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择属性" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}


//立即购买
- (void)atonceShooping {
     string = @"lijigoumai";
     [self lodAddShoppingCart];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (numlable) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        bottomScrollView.frame = CGRectMake(0, 20-height, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    bottomScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}
//回收键盘
- (void)clickcancle:(UITapGestureRecognizer *)gesture {
    [numlable resignFirstResponder];
}

@end
