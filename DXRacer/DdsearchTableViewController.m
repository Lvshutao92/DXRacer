//
//  DdsearchTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "DdsearchTableViewController.h"
#import "KKPModel.h"
#import "Ddsearchmodel.h"
#import "ddseaTableViewController.h"
#import "KSDatePicker.h"

@interface DdsearchTableViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *imageview;
    UIScrollView *scrollview;
    UIView *headerview;
    BOOL isorno;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    UILabel *lab5;
    UILabel *lab6;
    UILabel *lab7;
    
    UILabel *lab8;
    UILabel *lab9;
    
    UITextField *textlab1;
    UITextField *textlab2;
    UITextField *textlab3;
    UITextField *textlab4;
    UITextField *textlab5;
    UITextField *textlab6;
    UITextField *textlab7;
    
    
    UITextField *textlab8;
    UITextField *textlab9;
    NSString *stringid;
}
@property(nonatomic, strong)UITableView *tableview1;
@property(nonatomic, strong)UITableView *tableview2;
@property(nonatomic, strong)UITableView *tableview3;

@property(nonatomic, strong)NSMutableArray *arr1;
@property(nonatomic, strong)NSMutableArray *arr2;
@property(nonatomic, strong)NSMutableArray *arr3;

@property(nonatomic, strong)NSMutableArray *arr;
@end

@implementation DdsearchTableViewController
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.title = @"订单检索";
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    //搜索按钮
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbtn.frame = CGRectMake(0, 0, 30, 30) ;
    [searchbtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(clicksearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbar = [[UIBarButtonItem alloc]initWithCustomView:searchbtn];
    self.navigationItem.rightBarButtonItem = searchbar;
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableView.tableFooterView = vie;
    
    headerview = [[UIView alloc]init];
    headerview.backgroundColor = [UIColor colorWithWhite:.9 alpha:.1];
    
    [self lod];
    [self lodxiadanzhanghao];
    
    [self setupview];
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableview1])
    {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.tableview2])
    {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.tableview3])
    {
        return NO;
    }
    
    
    return YES;
}

- (void)tapgesture:(UITapGestureRecognizer *)sender{
    [textlab3 resignFirstResponder];
    [textlab4 resignFirstResponder];
    [textlab5 resignFirstResponder];
    [textlab7 resignFirstResponder];
    self.tableview1.hidden = YES;
    self.tableview2.hidden = YES;
    self.tableview3.hidden = YES;
}
- (void)setupview {
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50) ;
    
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgesture:)];
    taps.delegate = self;
    [headerview addGestureRecognizer:taps];
    
    self.tableView.tableHeaderView = headerview;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"请输入检索信息" forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor colorWithWhite:.95 alpha:.5];
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [headerview addSubview:btn];
    
    self.tableview1 = [[UITableView alloc]init];
    [self.tableview1.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.tableview1.layer setBorderWidth:1];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.hidden = YES;
    [self.tableview1.layer setBorderColor:[UIColor colorWithWhite:.7 alpha:.4].CGColor];
    [self.tableview1.layer setBorderWidth:1];
    [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView addSubview:self.tableview1];
    [self.tableView bringSubviewToFront:self.tableview1];
    
    self.tableview2 = [[UITableView alloc]init];
    [self.tableview2.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.tableview2.layer setBorderWidth:1];
    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    self.tableview2.hidden = YES;
    [self.tableview2.layer setBorderColor:[UIColor colorWithWhite:.7 alpha:.4].CGColor];
    [self.tableview2.layer setBorderWidth:1];
    [self.tableview2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView addSubview:self.tableview2];
    [self.tableView bringSubviewToFront:self.tableview2];
    
    self.tableview3 = [[UITableView alloc]init];
    [self.tableview3.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:.5].CGColor];
    [self.tableview3.layer setBorderWidth:1];
    self.tableview3.delegate = self;
    self.tableview3.dataSource = self;
    self.tableview3.hidden = YES;
    [self.tableview3.layer setBorderColor:[UIColor colorWithWhite:.7 alpha:.4].CGColor];
    [self.tableview3.layer setBorderWidth:1];
    [self.tableview3 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell3"];
    [self.tableView addSubview:self.tableview3];
    [self.tableView bringSubviewToFront:self.tableview3];
    
    NSMutableArray *arr = [@[@"发货仓",@"订单状态",@"订单编号",@"来源单据号",@"收货人",@"下单账号",@"ITEMNO",@"发货开始日期",@"发货结束日期"]mutableCopy];
    
    
    self.arr2 = [@[@"全部订单",@"订单已创建",@"订单已确认",@"订单已分配",@"订单已发货",@"订单已取消"]mutableCopy];
    
    for (int i = 0; i < 9; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10*(i+1)+30*i, 90, 30)];
        lab.text = arr[i];
        switch (i) {
            case 0:
                lab1 = lab;
                break;
            case 1:
                lab2 = lab;
                break;
            case 2:
                lab3 = lab;
                break;
            case 3:
                lab4 = lab;
                break;
            case 4:
                lab5 = lab;
                break;
            case 5:
                lab6 = lab;
                break;
            case 6:
                lab7 = lab;
                break;
            case 7:
                lab8 = lab;
                break;
            case 8:
                lab9 = lab;
                break;
            default:
                break;
        }
        lab.font = [UIFont systemFontOfSize:13];
        [headerview addSubview:lab];
    }
    for (int i = 0; i < 9; i++) {
        UITextField *te = [[UITextField alloc]initWithFrame:CGRectMake(105, 10*(i+1)+30*i, SCREEN_WIDTH-115, 30)];
        switch (i) {
            case 0:
                textlab1 = te;
                textlab1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
                self.tableview1.frame = CGRectMake(105, 10*(i+1)+30*i+30, SCREEN_WIDTH-115, 150);
                break;
            case 1:
                textlab2 = te;
                textlab2.text = @"全部订单";
                textlab2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
                self.tableview2.frame = CGRectMake(105, 10*(i+1)+30*i+30, SCREEN_WIDTH-115, 150);
                break;
            case 2:
                textlab3 = te;
                textlab3.placeholder = @"订单编号";
                break;
            case 3:
                textlab4 = te;
                textlab4.placeholder = @"来源单据号";
                break;
            case 4:
                textlab5 = te;
                textlab5.placeholder = @"收货人";
                break;
            case 5:
                textlab6 = te;
                textlab6.text = @"全部";
                textlab6.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
                self.tableview3.frame = CGRectMake(105, 10*(i+1)+30*i+30, SCREEN_WIDTH-115, 150);
                break;
            case 6:
                textlab7 = te;
                textlab7.placeholder = @"ITEMNO";
                break;
            case 7:
                textlab8 = te;
                textlab8.placeholder = @"请选择";
                textlab8.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
                break;
            case 8:
                textlab9 = te;
                textlab9.placeholder = @"请选择";
                textlab9.backgroundColor = [UIColor colorWithWhite:.8 alpha:.4];
                break;
            default:
                break;
        }
        te.delegate = self;
        [te.layer setBorderWidth:.5];
        [te.layer setBorderColor:[UIColor colorWithWhite:.5 alpha:1].CGColor];
        te.borderStyle = UITextBorderStyleRoundedRect;
        te.layer.masksToBounds = YES;
        te.layer.cornerRadius = 5;
        [headerview addSubview:te];
    }
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.tableView.tableFooterView = vie;
    
    headerview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 440) ;
    self.tableView.tableHeaderView = headerview;
}



- (void)clicksearch {
    self.tableview1.hidden = YES;
    self.tableview2.hidden = YES;
    self.tableview3.hidden = YES;
    
    [textlab3 resignFirstResponder];
    [textlab4 resignFirstResponder];
    [textlab5 resignFirstResponder];
    [textlab7 resignFirstResponder];
        ddseaTableViewController *sea = [[ddseaTableViewController alloc]init];
    sea.navigationItem.title = @"订单";
    
    
    
    if (textlab8.text.length == 0) {
        sea.str8 = @" ";
    }else {
        sea.str8 = textlab8.text;
    }
    if (textlab9.text.length == 0) {
        sea.str9 = @" ";
    }else {
        sea.str9 = textlab9.text;
    }
    
    
    if (textlab3.text.length == 0) {
        sea.str3 = @" ";
    }else {
        sea.str3 = textlab3.text;
    }
    if (textlab4.text.length == 0) {
        sea.str4 = @" ";
    }else {
        sea.str4 = textlab4.text;
    }
    if (textlab5.text.length == 0) {
        sea.str5  = @" ";
    }else {
        sea.str5 = textlab5.text;
    }
    if (textlab7.text.length == 0) {
        sea.str7 = @" ";
    }else {
        sea.str7 = textlab7.text;
    }
    
        if ([textlab2.text isEqualToString:@"全部订单"]) {
            sea.str2 = @" ";
        }else {
            sea.str2 = textlab2.text;
        }
        if ([textlab6.text isEqualToString:@"全部"]) {
            sea.str6 = @" ";
        }else {
            sea.str6 = textlab6.text;
        }
        sea.str1 = stringid;
    
    
        [self.navigationController pushViewController:sea animated:YES];
}




#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableview1]) {
        textlab1.text = self.arr1[indexPath.row];
        stringid = self.arr[indexPath.row];
        self.tableview1.hidden = YES;
    }
    if ([tableView isEqual:self.tableview2]) {
        textlab2.text = self.arr2[indexPath.row];
        self.tableview2.hidden = YES;
    }
    if ([tableView isEqual:self.tableview3]) {
        textlab6.text = self.arr3[indexPath.row];
        self.tableview3.hidden = YES;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableview1]) {
        return self.arr1.count;
    }
    if ([tableView isEqual:self.tableview2]) {
        return self.arr2.count;
    }
    if ([tableView isEqual:self.tableview3]) {
        return self.arr3.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableview1]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = self.arr1[indexPath.row];
        return cell;
    }
    if ([tableView isEqual:self.tableview2]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = self.arr2[indexPath.row];
        return cell;
    }
    if ([tableView isEqual:self.tableview3]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = self.arr3[indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//                NSLog(@"-------%@",dic);
        [weakSelf.arr1 removeAllObjects];
        [weakSelf.arr  removeAllObjects];
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            
            NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"userStore"];
            for (NSDictionary *dicc in arr) {
                KKPModel *model = [KKPModel mj_objectWithKeyValues:dicc];
                [weakSelf.arr1 addObject:model.name];
                [weakSelf.arr addObject:model.id];
            }
            textlab1.text   = [weakSelf.arr1 firstObject];
            stringid  = [weakSelf.arr firstObject];
        }
        [weakSelf.tableview1 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)lodxiadanzhanghao{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if ([[Manager sharedManager] redingwenjianming:@"showorder.text"].length != 0) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                @"showorder":[[Manager sharedManager] redingwenjianming:@"showorder.text"],
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                };
    }else{
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                @"showorder":@" ",
                @"mainaccount":[[Manager sharedManager] redingwenjianming:@"mainaccount.text"],
                };
    }
//    NSLog(@"%@",dic);
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order",@"innitOrderCreateUser") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"-------%@",dic);
        [weakSelf.arr3 removeAllObjects];
        NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"placeOrderPeoples"];
        for (NSDictionary *dic in arr) {
            Ddsearchmodel *model = [Ddsearchmodel mj_objectWithKeyValues:dic];
            [weakSelf.arr3 addObject:model.username];
            
        }
        [weakSelf.arr3 insertObject:@"全部" atIndex:0];
        
        [weakSelf.tableview3 reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"编辑");
        
    }];
    edit.backgroundColor = [UIColor redColor];
    UITableViewRowAction *deleate = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
    }];
    deleate.backgroundColor = [UIColor orangeColor];
    UITableViewRowAction *xiugai = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull kaipiao, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"修改实销金额");
    }];
    xiugai.backgroundColor = [UIColor magentaColor];
    return @[edit,deleate,xiugai];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if ([textField isEqual:textlab8]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        [textlab3 resignFirstResponder];
        [textlab4 resignFirstResponder];
        [textlab5 resignFirstResponder];
        [textlab7 resignFirstResponder];
        //x,y 值无效，默认是居中的
        KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
        //配置中心，详情见KSDatePikcerApperance
        picker.appearance.radius = 5;
        //设置回调
        picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
            if (buttonType == KSDatePickerButtonCommit) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *stra = [formatter stringFromDate:currentDate];
                textlab8.text = stra;
            }
        };
        // 显示
        [picker show];
        
        return NO;
    }
    if ([textField isEqual:textlab9]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        [textlab3 resignFirstResponder];
        [textlab4 resignFirstResponder];
        [textlab5 resignFirstResponder];
        [textlab7 resignFirstResponder];
        //x,y 值无效，默认是居中的
        KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
        //配置中心，详情见KSDatePikcerApperance
        picker.appearance.radius = 5;
        //设置回调
        picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
            if (buttonType == KSDatePickerButtonCommit) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *stra = [formatter stringFromDate:currentDate];
                textlab9.text = stra;
            }
        };
        // 显示
        [picker show];
        
        return NO;
    }
    
    
    
    if ([textField isEqual:textlab3]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        
        return YES;
    }
    if ([textField isEqual:textlab4]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        
        return YES;
    }
    if ([textField isEqual:textlab5]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        
        return YES;
    }
    if ([textField isEqual:textlab7]){
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        
        return YES;
    }
    
    if ([textField isEqual:textlab1]) {
        self.tableview2.hidden = YES;
        self.tableview3.hidden = YES;
        
        [textlab3 resignFirstResponder];
        [textlab4 resignFirstResponder];
        [textlab5 resignFirstResponder];
        [textlab7 resignFirstResponder];
        
        if (self.tableview1.hidden == NO) {
            self.tableview1.hidden = YES;
        }else {
            self.tableview1.hidden = NO;
        }
        return NO;
    }
    if ([textField isEqual:textlab2]) {
        self.tableview1.hidden = YES;
        self.tableview3.hidden = YES;
        
        [textlab3 resignFirstResponder];
        [textlab4 resignFirstResponder];
        [textlab5 resignFirstResponder];
        [textlab7 resignFirstResponder];
        if (self.tableview2.hidden == NO) {
            self.tableview2.hidden = YES;
        }else {
            self.tableview2.hidden = NO;
        }
        return NO;
    }
    if ([textField isEqual:textlab6]) {
        self.tableview1.hidden = YES;
        self.tableview2.hidden = YES;
        
        [textlab3 resignFirstResponder];
        [textlab4 resignFirstResponder];
        [textlab5 resignFirstResponder];
        [textlab7 resignFirstResponder];
        if (self.tableview3.hidden == NO) {
            self.tableview3.hidden = YES;
        }else {
            self.tableview3.hidden = NO;
        }
        return NO;
    }
    return YES;
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)clickback {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSMutableArray *)arr1 {
    if (_arr1 == nil) {
        self.arr1 = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr1;
}
- (NSMutableArray *)arr2 {
    if (_arr2 == nil) {
        self.arr2 = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr2;
}
- (NSMutableArray *)arr3 {
    if (_arr3 == nil) {
        self.arr3 = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr3;
}
@end
