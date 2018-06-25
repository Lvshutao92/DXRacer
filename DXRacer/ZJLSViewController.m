//
//  ZJLSViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/22.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ZJLSViewController.h"
#import "ZJLSModel.h"
#import "ZJLSCell.h"

@interface ZJLSViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
{
    NSInteger page;
    NSInteger totalNum;
    UILabel *lab1;
    UILabel *lab;
}

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation ZJLSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"ZJLSCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    vie.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    self.tableview.tableHeaderView = vie;
    
    
    
    lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
    lab.textColor = RGBACOLOR(32, 157, 149, 1.0);
    lab.textAlignment = NSTextAlignmentRight;
    [vie addSubview:lab];
    
    lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    lab1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.3];
    [vie addSubview:lab1];
    
    [self setUpReflash];
    [self lodHuiZong];
}
#pragma mark------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 225;
}

#pragma mark------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJLSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZJLSModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.lab1.text = [Manager jinegeshi:model.mymoney];
    cell.lab2.text = [Manager jinegeshi:model.change_money];
    cell.lab3.text = [Manager jinegeshi:model.old_money];
    
    
    
    cell.lab4.text = model.opreat_user;
    cell.lab5.text = [Manager timezhuanhuan:model.create_time];
    cell.lab6.text = model.opreat_type;
    
    
    cell.lab7.text = model.note;
    
    return cell;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self setEditing:false animated:true];
//}
//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewRowAction *kaipiao = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"导出" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
//        self.tableview.editing = NO;
//        [self createXLSFile:indexPath.row];
//    }];
//    kaipiao.backgroundColor = [UIColor orangeColor];
//    
//    return @[kaipiao];
//}



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
    page = 1;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            @"page":[NSString stringWithFormat:@"%ld",page],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"partner_money_log",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        page = 2;
        
        totalNum = [[dic objectForKey:@"total"] integerValue];
        [weakSelf.dataArray removeAllObjects];
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in array) {
            ZJLSModel *model = [ZJLSModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
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
            @"page":[NSString stringWithFormat:@"%ld",page],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"partner_money_log",@"list") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"resultList"];
        for (NSDictionary *dic in array) {
            ZJLSModel *model = [ZJLSModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];
        }
        page ++;
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
}



- (void)lodHuiZong {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"partner_money_log",@"getAmount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSNumber *number = [[dic objectForKey:@"rows"] objectForKey:@"totalamount"];
        
        NSString *str=[Manager jinegeshi:[NSString stringWithFormat:@"%@",number]];
        
        NSMutableAttributedString *notestr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"资金流水统计   %@",str]];
        NSRange ran1 = NSMakeRange(0, 7);
        [notestr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:ran1];
        [lab setAttributedText:notestr1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//导出
- (void)createXLSFile:(NSInteger )index {
    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    [xlsDataMuArr addObject:@"改变后金额"];
    [xlsDataMuArr addObject:@"改变金额"];
    [xlsDataMuArr addObject:@"改变前金额"];
    [xlsDataMuArr addObject:@"操作人"];
    [xlsDataMuArr addObject:@"操作时间"];
    [xlsDataMuArr addObject:@"操作类型"];
    [xlsDataMuArr addObject:@"备注"];
  
    
     ZJLSModel *model = [self.dataArray objectAtIndex:index];
    // i行数据
    for (int i = 0; i < 1; i ++) {
       
            [xlsDataMuArr addObject:model.mymoney];
            [xlsDataMuArr addObject:model.change_money];
            [xlsDataMuArr addObject:model.old_money];
            [xlsDataMuArr addObject:model.opreat_user];
            [xlsDataMuArr addObject:model.create_time];
            [xlsDataMuArr addObject:model.opreat_type];
            [xlsDataMuArr addObject:@"-"];
        i++;
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
        //7列数
        if ( i > 0 && (i%7 == 0) ) {
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


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

@end
