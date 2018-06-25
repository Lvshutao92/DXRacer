//
//  WDFPViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/22.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "WDFPViewController.h"
#import "WDFPModel.h"
#import "WDFPCell.h"
#import "WDFPDetailsTableViewController.h"
@interface WDFPViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
{
    NSInteger page;
    NSInteger totalNum;
}

@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation WDFPViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"WDFPCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    
    [self setUpReflash];
}




#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 520;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WDFPModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
   
    WDFPDetailsTableViewController *details = [[WDFPDetailsTableViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    details.idStr = model.id;
    na.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:na animated:YES completion:nil];
}
#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    WDFPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WDFPModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.field.length == 0) {
        cell.lab1.text = @"-";
    }else{
        cell.lab1.text = model.field;
    }
    
    
    cell.lab2.text = [Manager jinegeshi:model.checkname];
    
   
    if (model.invoice_time.length == 0) {
        cell.lab3.text = @"-";
    }else{
         cell.lab3.text = [Manager timezhuanhuan:model.invoice_time];
    }
    
    if ([model.invoice_status isEqualToString:@"1"]) {
        cell.lab4.text = @"未开票";
    }else if ([model.invoice_status isEqualToString:@"2"]){
        cell.lab4.text = @"开票中";
    }else{
        cell.lab4.text = @"已开票";
    }
    
    
    cell.lab5.text = model.partner_name;
    
    cell.lab6.text = model.company_name;
    
    
    if (model.payer_code.length == 0) {
        cell.lab7.text = @"-";
    }else{
        cell.lab7.text = model.payer_code;
    }
    
    if (model.address.length == 0) {
        cell.lab8.text = @"-";
    }else{
        cell.lab8.text = model.address;
    }
    if (model.phone_num.length == 0) {
        cell.lab9.text = @"-";
    }else{
        cell.lab9.text = model.phone_num;
    }
    
    if (model.bank_name.length == 0) {
        cell.lab10.text = @"-";
    }else{
        cell.lab10.text = model.bank_name;
    }
    
    
    if (model.bank_account.length == 0) {
        cell.lab11.text = @"-";
    }else{
        cell.lab11.text = model.bank_account;
    }
    
    if (model.expres.length == 0) {
        cell.lab12.text = @"-";
    }else{
        cell.lab12.text = model.expres;
    }
    
    if (model.checkname.length == 0 || [model.checkname isEqualToString:@"0"]) {
        cell.lab13.text = @"-";
    }else{
        cell.lab13.text = [Manager jinegeshi:model.checkname];
    }
    
    if (model.invoice_detail.length == 0) {
        cell.la1.text = @"-";
    }else{
        cell.la1.text = [Manager jinegeshi:model.invoice_detail];
    }
    
    if (model.logistics_no.length == 0) {
        cell.la2.text = @"-";
    }else{
        cell.la2.text = model.logistics_no;
    }
    if (model.invoice_no.length == 0) {
        cell.la3.text = @"-";
    }else{
        cell.la3.text = model.invoice_no;
    }
    if (model.invoice_type.length == 0) {
        cell.la4.text = @"-";
    }else{
        if ([model.invoice_type isEqualToString:@"Y"]) {
            cell.la4.text = @"是";
        }else  {
            cell.la4.text = @"否";
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"确认开票" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        self.tableview.editing = NO;
        
        WDFPModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无票申请" message:@"温馨提示" preferredStyle:1];
        
        UIAlertAction *sure1 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self loddeENnsureKaiPiao:model.id kp_invoice_type:@"Y"];
        }];
        UIAlertAction *sure2 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self loddeENnsureKaiPiao:model.id kp_invoice_type:@"N"];
        }];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
        [alert addAction:sure1];
        [alert addAction:sure2];
        [self presentViewController:alert animated:YES completion:nil];
 
    }];
    kaipiao.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
//    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"导出" handler:^(UITableViewRowAction * _Nonnull edit, NSIndexPath * _Nonnull indexPath) {
//        self.tableview.editing = NO;
//        [self createXLSFile];
//        
//    }];
//    edit.backgroundColor = [UIColor redColor];
    return @[kaipiao];
}

//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodXL];
    }];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataArray.count == totalNum) {
            [self.tableview.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf lodSL];
        }
    }];
}

- (void)lodXL {
    [self.tableview.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    page = 1;
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"invoiceGroup",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",dic);
        [self.dataArray removeAllObjects];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            WDFPModel *model = [WDFPModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
//            NSLog(@"我的发票=-=%@-=-=%@-===%@",model.field,model.checkname,model.invoice_type);
        }
        page = 2;
        [weakSelf.tableview reloadData];
         [weakSelf.tableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [weakSelf.tableview.mj_header endRefreshing];
    }];
}
- (void)lodSL {
    [self.tableview.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page]
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"invoiceGroup",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in arr) {
            WDFPModel *model = [WDFPModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        page ++;
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}
//确认开票
- (void)loddeENnsureKaiPiao:(NSString *)kp_id kp_invoice_type:(NSString *)kp_invoice_type {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (kp_id != nil && kp_invoice_type != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"id":kp_id,
                @"invoice_type":kp_invoice_type,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"invoiceGroup",@"applyInvoice") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"result_msg"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}

//导出
- (void)createXLSFile {
    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    [xlsDataMuArr addObject:@"开票单号"];
    [xlsDataMuArr addObject:@"货物金额"];
    [xlsDataMuArr addObject:@"运费差价"];
    [xlsDataMuArr addObject:@"开票时间"];
    [xlsDataMuArr addObject:@"发票状态"];
    [xlsDataMuArr addObject:@"经销商名称"];
    
    [xlsDataMuArr addObject:@"发票抬头"];
    [xlsDataMuArr addObject:@"纳税人识别码"];
    [xlsDataMuArr addObject:@"注册地址"];
    [xlsDataMuArr addObject:@"注册电话"];
    [xlsDataMuArr addObject:@"开户银行"];
    [xlsDataMuArr addObject:@"银行账户"];
    
    [xlsDataMuArr addObject:@"发票物流公司"];
    [xlsDataMuArr addObject:@"物流单号"];
    [xlsDataMuArr addObject:@"发票运费"];
    [xlsDataMuArr addObject:@"发票单据号"];
    [xlsDataMuArr addObject:@"无票申报"];
    
    // 100行数据
    for (int i = 0; i < 1; i ++) {
        if (i == 0) {
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
            [xlsDataMuArr addObject:@"Debt"];
            [xlsDataMuArr addObject:@"2016-12-06 17:18:40"];
            [xlsDataMuArr addObject:@"GuangZhou"];
            [xlsDataMuArr addObject:@"Mr.Liu"];
            [xlsDataMuArr addObject:@"Buy"];
            [xlsDataMuArr addObject:@"TaoBao"];
        }
    }
    // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
    NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
    // 字符串转换为可变字符串，方便改变某些字符
    NSMutableString *muStr = [fileContent mutableCopy];
    // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
    NSMutableArray *subMuArr = [NSMutableArray array];
    for (int i = 0; i < muStr.length; i ++) {
        NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
        if (range.length == 1) {
            [subMuArr addObject:@(range.location)];
        }
    }
    // 替换末尾\t
    for (NSUInteger i = 0; i < subMuArr.count; i ++) {
        //20列数
        if ( i > 0 && (i%17 == 0) ) {
            [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
        }
    }
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/export.xls"];
    NSLog(@"文件路径：\n%@",filePath);
    // 生成xls文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    
    //导出xls文件
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    self.documentInteractionController.delegate = self;
    [self.documentInteractionController presentPreviewAnimated:YES];
    
}

- ( UIViewController *)documentInteractionControllerViewControllerForPreview:( UIDocumentInteractionController *)interactionController
{
    return self;
}














@end
