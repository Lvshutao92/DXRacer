//
//  DingDanDetailsController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/3.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "DingDanDetailsController.h"
#import "DingDanDetailsModel.h"
#import "resultMapListModel.h"
#import "resultList1Model.h"
#import "resultList2Model.h"
#import "resultList3Model.h"

#import "ITEMCell.h"
#import "WLXXCell.h"
#import "DINGDANrizhiCell.h"
#import "FPXINXICell.h"


#import "EditZengZhiViewController.h"

@interface DingDanDetailsController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *strid;
    NSString *strorderid;
    NSString *dingdanbianhao;
    
    NSString *fapiaoleixing;
    NSString *name;
    NSString *mobile;
    NSString *shengshiqu;
    NSString *address;
    
    NSString *sheng;
    NSString *shi;
    NSString *qu;
    
    float heights;
    float heigh;
}
@property(nonatomic, strong)UIImageView *imagevie;
@property(nonatomic, strong)NSMutableArray *dataArray1;
@property(nonatomic, strong)NSMutableArray *dataArray2;
@property(nonatomic, strong)NSMutableArray *dataArray3;
@property(nonatomic, strong)NSMutableArray *dataArray4;
@property(nonatomic, strong)UITableView    *tableview;
@end

@implementation DingDanDetailsController
- (NSMutableArray *)dataArray1 {
    if (_dataArray1 == nil) {
        self.dataArray1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray1;
}
- (NSMutableArray *)dataArray2 {
    if (_dataArray2 == nil) {
        self.dataArray2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray2;
}
- (NSMutableArray *)dataArray3 {
    if (_dataArray3 == nil) {
        self.dataArray3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray3;
}
- (NSMutableArray *)dataArray4 {
    if (_dataArray4 == nil) {
        self.dataArray4 = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray4;
}
- (void)click {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    if (![self.str isEqualToString:@"nobtn"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30) ;
        [btn setImage:[UIImage imageNamed:@"edit-1"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = bar;
    }
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0, 30, 30) ;
    [bt setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ba = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = ba;
    //这个的目的是为了使得启动app时，单元格是收缩的
    for (int i=0; i<30; i++) {
        close[i] = YES;
    }
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ITEMCell class] forCellReuseIdentifier:@"cellA"];
    [self.tableview registerNib:[UINib nibWithNibName:@"WLXXCell" bundle:nil] forCellReuseIdentifier:@"cellB"];
    [self.tableview registerNib:[UINib nibWithNibName:@"FPXINXICell" bundle:nil] forCellReuseIdentifier:@"cellC"];
    [self.tableview registerNib:[UINib nibWithNibName:@"DINGDANrizhiCell" bundle:nil] forCellReuseIdentifier:@"cellD"];
    
    [self.view addSubview:self.tableview];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self loddeDetails];
}
- (void)clickEdit {
    
    EditZengZhiViewController *zengzhi = [[EditZengZhiViewController alloc]init];
    zengzhi.navigationItem.title = @"编辑发票";
    
    zengzhi.str_order_id   = strorderid;
    zengzhi.str_id         = strid;
    zengzhi.dingdanbianhao = dingdanbianhao;
    
    zengzhi.fapiaoleixing  = fapiaoleixing;
    zengzhi.name           = name;
    zengzhi.mobile         = mobile;
    zengzhi.shengshiqu     = shengshiqu;
    zengzhi.address        = address;
    
    zengzhi.sheng          = sheng;
    zengzhi.shi            = shi;
    zengzhi.qu             = qu;
    
    
    [self.navigationController pushViewController:zengzhi animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray1.count;
    }else if (section == 1) {
        if (close[section]) {
            return 0;
        }
        return self.dataArray2.count;
    }else if (section == 2) {
        if (close[section]) {
            return 0;
        }
        return self.dataArray3.count;
    }
    if (close[section]) {
        return 0;
    }
    return self.dataArray4.count;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            return 150;
        }else {
            return 200;
        }
    }else if (indexPath.section == 1){
        return 270+heights + heigh;
    }else if (indexPath.section == 2){
        return 290;
    }
    return 105;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ITEMCell   *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cellA" forIndexPath:indexPath];
        resultMapListModel *model1 = [self.dataArray1 objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell1.imageViewpic sd_setImageWithURL:[NSURL URLWithString:NSString(model1.imgurl)]];
        });
        cell1.imageViewpic.contentMode = UIViewContentModeScaleAspectFit;
        cell1.labone.text    = model1.sku_name;
        cell1.labfour.text   = [NSString stringWithFormat:@"ITEMNO：%@",model1.skucode];
        cell1.labfive.text   = [NSString stringWithFormat:@"数量：%@",model1.quantity];
        
        if ([model1.skucode isEqual:[NSNull null]] || model1.skucode.length == 0) {
            model1.skucode = @"-";
        }
        
        
        cell1.labthree.text  = [NSString stringWithFormat:@"FCNO：%@",model1.bizcode];

        cell1.labtwo.text  = [NSString stringWithFormat:@"小计：%@",[Manager jinegeshi:model1.total_fee]];
        
        cell1.addBtn.hidden = YES;
        return cell1;
    }else if (indexPath.section == 1){
        WLXXCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cellB" forIndexPath:indexPath];
        resultList1Model   *model2 = [self.dataArray2 objectAtIndex:indexPath.row];
        
        
        if (self.str1.length == 0) {
            cell2.lab1.text  = @"-";
        }else{
            cell2.lab1.text  = self.str1;
        }
        
        if (self.str2.length == 0) {
            cell2.lab2.text  = @"-";
            heigh = 20;
            cell2.heig.constant = 20;
            cell2.youfeitop.constant = 10;
        }else{
            cell2.lab2.text  = self.str2;
            cell2.lab2.numberOfLines = 0;
            cell2.lab2.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize size = [cell2.lab2 sizeThatFits:CGSizeMake(SCREEN_WIDTH-90, MAXFLOAT)];
            heigh = size.height;
            cell2.heig.constant = heigh;
            cell2.youfeitop.constant = heigh -10;
        }
        
        if (self.str3.length == 0) {
            cell2.lab3.text  = @"-";
        }else{
            cell2.lab3.text  = [Manager jinegeshi:self.str3];
        }
        
        
        cell2.lab4.text  = model2.receiver_name;
        cell2.lab5.text  = model2.receiver_state;
        cell2.lab6.text  = model2.receiver_city;
        cell2.lab7.text  = model2.receiver_district;
        
        
        cell2.lab8.text  = model2.receiver_address;
        cell2.lab8.numberOfLines = 0;
        cell2.lab8.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [cell2.lab8 sizeThatFits:CGSizeMake(SCREEN_WIDTH-90, MAXFLOAT)];
        heights = size.height;
        cell2.labheight.constant = heights;
        
        cell2.julitop1.constant = heights -10;
//        cell2.julitop2.constant = 10;
        
        
        
        cell2.lab9.text  = model2.receiver_zip;
        cell2.lab10.text = model2.receiver_mobile;
       
       return cell2;
    }else if (indexPath.section == 2){
       FPXINXICell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cellC" forIndexPath:indexPath];
       resultList2Model   *model3 = [self.dataArray3 objectAtIndex:indexPath.row];
        cell3.lab1.text = model3.type;
        cell3.lab2.text = model3.money;
        cell3.lab3.text = model3.title;
        cell3.lab4.text = model3.code;
        cell3.lab5.text = model3.addr;
        cell3.lab6.text = model3.phone;
        cell3.lab7.text = model3.bank;
        cell3.lab8.text = model3.bank_no;
        if ([model3.status isEqualToString:@"1"]) {
            cell3.lab9.text = @"未开票";
        }
        if ([model3.status isEqualToString:@"2"]){
            cell3.lab9.text = @"已开票";
        }
        
//        @property(nonatomic, strong)NSString *order_id;
//        @property(nonatomic, strong)NSString *order_no;
//        @property(nonatomic, strong)NSString *order_resource;
        return cell3;
    }
    
    DINGDANrizhiCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cellD" forIndexPath:indexPath];
    resultList3Model   *model4 = [self.dataArray4 objectAtIndex:indexPath.row];
    cell4.lab1.text = model4.content;
    cell4.lab2.text = model4.user;
    cell4.lab3.text = [Manager timezhuanhuan:model4.createtime];
   return cell4;
    
}






- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
        UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
   
        view.tag = 1000 + section;
        view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
        [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
       self.imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 30, 30)];
       self.imagevie.image = [UIImage imageNamed:@"jiantou"];
    
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
    
        [view addSubview:label];
    
        if (section == 0) {
            label.text = @"   订单明细";
            return view;
        }else if (section == 1) {
            [view addSubview:self.imagevie];
            label.text = @"   物流信息";
            return view;
        }else if (section == 2) {
            [view addSubview:self.imagevie];
            label.text = @"   发票信息";
            return view;
        }
       [view addSubview:self.imagevie];
        label.text = @"   订单日志";
        return view;    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
-(void)sectionClick:(UIControl *)view{
    //获取点击的组
    NSInteger i = view.tag - 1000;
    //取反
    close[i] = !close[i];
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [self.tableview reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    if (!close[i]) {
        self.imagevie.image = [UIImage imageNamed:@"shangjiantou"];
    }else {
        self.imagevie.image = [UIImage imageNamed:@"jiantou"];
    }
}





- (void)loddeDetails {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (self.oderid != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],@"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],@"order_id":self.oderid};
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"orderitems",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultMapList"];
            //        NSLog(@"-----%@",dic);
            
            [weakSelf.dataArray1 removeAllObjects];
            [weakSelf.dataArray2 removeAllObjects];
            [weakSelf.dataArray3 removeAllObjects];
            [weakSelf.dataArray4 removeAllObjects];
            
            [DingDanDetailsModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"resultList" : [resultMapListModel class],
                         @"resultList1" : [resultList1Model class],
                         @"resultList2" : [resultList2Model class],
                         @"resultList3" : [resultList3Model class],
                         };
            }];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            
            for (NSDictionary *temp in array) {
                DingDanDetailsModel *model = [DingDanDetailsModel mj_objectWithKeyValues:temp];
                [arr addObject:model];
                
                NSArray *arr1 = model.resultList;
                NSArray *arr2 = model.resultList1;
                NSArray *arr3 = model.resultList2;
                NSArray *arr4 = model.resultList3;
                
                for (resultMapListModel *model1 in arr1) {
                    dingdanbianhao = model1.order_no;
                    
                    strorderid     = model1.order_id;
                    [weakSelf.dataArray1 addObject:model1];
                }
                for (resultList1Model *model2 in arr2) {
                    name = model2.receiver_name;
                    mobile = model2.receiver_mobile;
                    
                    sheng = model2.receiver_state;
                    shi = model2.receiver_city;
                    qu = model2.receiver_district;
                    shengshiqu = [NSString stringWithFormat:@"%@-%@-%@",model2.receiver_state,model2.receiver_city,model2.receiver_district];
                    address = model2.receiver_address;
                    [weakSelf.dataArray2 addObject:model2];
                }
                for (resultList2Model *model3 in arr3) {
                    
                    fapiaoleixing  = model3.type;
                    strid          = model3.id;
                    [weakSelf.dataArray3 addObject:model3];
                }
                for (resultList3Model *model4 in arr4) {
                    
                    [weakSelf.dataArray4 addObject:model4];
                }
            }
            
//            NSLog(@"------------------------%ld",self.dataArray2.count);
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}












@end
