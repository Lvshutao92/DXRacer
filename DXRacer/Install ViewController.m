//
//  Install ViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "Install ViewController.h"
//#import "AppDelegate.h"
#import "SHEzhiCell.h"
@interface Install_ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *bgview;
    UITextField *textf;
    UITextField *textf1;
    
    UIView *foterview;
    UISwitch *switchs;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    UISwitch *switch1;
    UISwitch *switch2;
    UISwitch *switch3;
    UISwitch *switch4;
    
    BOOL isno;
}
@property(nonatomic, strong)UITableView *tableView;




@end

@implementation Install_ViewController
- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    [self.tableView registerNib:[UINib nibWithNibName:@"SHEzhiCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
//    btn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
//    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clicka) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    [self.view bringSubviewToFront:btn];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    self.tableView.tableFooterView = view;

    
    foterview = [[UIView alloc]init];
    [self setupvie];
//    [self setuptuisongview];
    
//    [self lodAddPush:[@[@"1",@"2",@"3",@"4"]mutableCopy]];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        SHEzhiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"])  {
            if (indexPath.row == 0) {
                cell.lab.text = [NSString stringWithFormat:@"%@",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }
            if (indexPath.row == 1) {
                cell.lab.text = @"修改密码";
            }
            if (indexPath.row == 2) {
                cell.lab.text = @"退出登录";
            }
        }else{
            if (indexPath.row == 0) {
                cell.lab.text = [NSString stringWithFormat:@"%@",[[Manager sharedManager] redingwenjianming:@"username.text"]];
            }
            if (indexPath.row == 1) {
                cell.lab.text = [NSString stringWithFormat:@"余额：¥%@",self.totalMoney];
            }
            if (indexPath.row == 2) {
                cell.lab.text = @"修改密码";
            }
            if (indexPath.row == 3) {
                cell.lab.text = @"退出登录";
            }
        }
        return cell;
    
   
   
}

- (void)clickswitch:(UISwitch *)sender {
    if ([[[Manager sharedManager]redingwenjianming:@"Y_N_Push"]isEqualToString:@"YES"]) {
        lab1.hidden = YES;
        lab2.hidden = YES;
        lab3.hidden = YES;
        lab4.hidden = YES;
        switch1.hidden = YES;
        switch2.hidden = YES;
        switch3.hidden = YES;
        switch4.hidden = YES;

        [[Manager sharedManager] writewenjianming:@"Y_N_Push" content:@"NO"];
        [self lodDeleatePush:[@[@"1",@"2",@"3",@"4"]mutableCopy]];
    }else{
        lab1.hidden = NO;
        lab2.hidden = NO;
        lab3.hidden = NO;
        lab4.hidden = NO;
        switch1.hidden = NO;
        switch2.hidden = NO;
        switch3.hidden = NO;
        switch4.hidden = NO;

        [[Manager sharedManager] writewenjianming:@"Y_N_Push" content:@"YES"];
        
        [[Manager sharedManager] writewenjianming:@"Y_N_Push1" content:@"YES"];
        [[Manager sharedManager] writewenjianming:@"Y_N_Push2" content:@"YES"];
        [[Manager sharedManager] writewenjianming:@"Y_N_Push3" content:@"YES"];
        [[Manager sharedManager] writewenjianming:@"Y_N_Push4" content:@"YES"];
        switch1.on = YES;
        switch2.on = YES;
        switch3.on = YES;
        switch4.on = YES;
        
        [self lodAddPush:[@[@"1",@"2",@"3",@"4"]mutableCopy]];
    }
}
- (void)clickswitch1:(UISwitch *)sender {
    if (sender.on == YES) {
        switch1.on = YES;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push1" content:@"YES"];
    }else{
        switch1.on = NO;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push1" content:@"NO"];
    }
}
- (void)clickswitch2:(UISwitch *)sender {
    if (sender.on == YES) {
        switch2.on = YES;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push2" content:@"YES"];
    }else{
        
        switch2.on = NO;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push2" content:@"NO"];

    }
}
- (void)clickswitch3:(UISwitch *)sender {
    if (sender.on == YES) {
        switch3.on = YES;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push3" content:@"YES"];
    }else{
        
        switch3.on = NO;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push3" content:@"NO"];
    }
}
- (void)clickswitch4:(UISwitch *)sender {
    if (sender.on == YES) {
        switch4.on = YES;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push4" content:@"YES"];
    }else{
        
        switch4.on = NO;
        [[Manager sharedManager] writewenjianming:@"Y_N_Push4" content:@"NO"];
    }
}






- (void)lodAddPush:(NSMutableArray *)arr {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"ids":arr
            };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"messagetype", @"add") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//             NSLog(@"===%@",dic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        }];
}
- (void)lodDeleatePush:(NSMutableArray *)arr {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"ids":arr
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    
    [session POST:KURLNSString(@"messagetype", @"delete") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"----%@",dic);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


















- (void)setuptuisongview{
    foterview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
    self.tableView.tableFooterView = foterview;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20,10, SCREEN_WIDTH/3*2, 30)];
    lable.text = @"是否允许推送";
    [foterview addSubview:lable];
    switchs = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60,10, 50, 30)];
    [switchs addTarget:self action:@selector(clickswitch:) forControlEvents:UIControlEventTouchUpInside];
    
    [foterview addSubview:switchs];
    
    for (int i = 0; i<4; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 +15*(i+1)+30*i, SCREEN_WIDTH/3*2, 30)];
        switch (i) {
            case 0:
                lab1 = lab;
                lab1.text = @"充值通知";
                break;
            case 1:
                lab2 = lab;
                lab2.text = @"发货通知";
                break;
            case 2:
                lab3 = lab;
                lab3.text = @"XX通知";
                break;
            case 3:
                lab4 = lab;
                lab4.text = @"XX通知";
                break;
            default:
                break;
        }
       
        [foterview addSubview:lab];
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 50 +15*(i+1)+30*i, 50, 30)];
        switch (i) {
            case 0:
                switch1 = swit;
                [switch1 addTarget:self action:@selector(clickswitch1:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                switch2 = swit;
                [switch2 addTarget:self action:@selector(clickswitch2:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                switch3 = swit;
                [switch3 addTarget:self action:@selector(clickswitch3:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                switch4 = swit;
                [switch4 addTarget:self action:@selector(clickswitch4:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        [foterview addSubview:swit];
        if ([[[Manager sharedManager] redingwenjianming:@"Y_N_Push"]isEqualToString:@"YES"]) {
            swit.hidden = NO;
            lab.hidden = NO;
            switchs.on = YES;
           
        }else{
            swit.hidden = YES;
            lab.hidden = YES;
            switchs.on = NO;
            foterview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            self.tableView.tableFooterView = foterview;
        }
    }
   
    if ([[[Manager sharedManager]redingwenjianming:@"Y_N_Push"]isEqualToString:@"YES"]) {
        switchs.on = YES;
        if ([[[Manager sharedManager] redingwenjianming:@"Y_N_Push1"]isEqualToString:@"YES"]) {
            switch1.on = YES;
        }else{
            switch1.on = NO;
        }
        if ([[[Manager sharedManager] redingwenjianming:@"Y_N_Push2"]isEqualToString:@"YES"]) {
            switch2.on = YES;
        }else{
            switch2.on = NO;
        }
        if ([[[Manager sharedManager] redingwenjianming:@"Y_N_Push3"]isEqualToString:@"YES"]) {
            switch3.on = YES;
        }else{
            switch3.on = NO;
        }
        if ([[[Manager sharedManager] redingwenjianming:@"Y_N_Push4"]isEqualToString:@"YES"]) {
            switch4.on = YES;
        }else{
            switch4.on = NO;
        }
    }else{
        switchs.on = NO;
    }
}



- (void)clicka {
    [[Manager sharedManager] writewenjianming:@"login.text" content:@"NO"];
    LoginViewController *login = [[LoginViewController alloc]init];
    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:login animated:YES completion:nil];
}
- (void)ckickhid:(UITapGestureRecognizer *)sender {
    [textf resignFirstResponder];
    [textf1 resignFirstResponder];
}
- (void)setupvie {
    bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ckickhid:)];
    [bgview addGestureRecognizer:tap];
    
    
    bgview.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    bgview.hidden = YES;
    
    [self.view addSubview:bgview];
    [self.view bringSubviewToFront:bgview];
    UIView *iew = [[UIView alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-200, SCREEN_WIDTH-60, 215)];
    iew.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(iew, 10, 0, [UIColor clearColor]);
    [bgview addSubview:iew];
    
    UILabel *laab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 30)];
    laab1.text = @"新密码";
    [iew addSubview:laab1];
    UILabel *laab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 80, 30)];
    laab2.text = @"重复密码";
    [iew addSubview:laab2];
    textf = [[UITextField alloc]initWithFrame:CGRectMake(90, 15, SCREEN_WIDTH-160, 40)];
    textf.placeholder = @"";
    textf.delegate = self;
    textf.borderStyle = UITextBorderStyleRoundedRect;
    [iew addSubview:textf];
    textf1 = [[UITextField alloc]initWithFrame:CGRectMake(90, 75, SCREEN_WIDTH-160, 40)];
    textf1.delegate = self;
    textf1.borderStyle = UITextBorderStyleRoundedRect;
    [iew addSubview:textf1];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(((SCREEN_WIDTH-60)-200)/3, 140, 100, 40);
    [btn1 setTitle:@"关闭" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickcancle) forControlEvents:UIControlEventTouchUpInside];
    [iew addSubview:btn1];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(((SCREEN_WIDTH-60)-200)/3*2+100, 140, 100, 40);
    btn2.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [btn2 setTitle:@"保存" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clicksave) forControlEvents:UIControlEventTouchUpInside];
    [iew addSubview:btn2];
    
}
- (void)clickcancle{
    [textf resignFirstResponder];
    [textf1 resignFirstResponder];
    bgview.hidden = YES;
}
- (void)clicksave{
    if (textf.text.length != 0 && [textf.text isEqualToString:textf1.text]) {
        [self lodpassword];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入密码不同，请重新输入" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *ca = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ca];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





#pragma mark======UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
#pragma mark======UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"])  {
            return 3;
        }
        return 4;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            if (indexPath.row == 1) {
                bgview.hidden = NO;
            }
            if (indexPath.row == 2) {
                [[Manager sharedManager] writewenjianming:@"login.text" content:@"NO"];
                LoginViewController *login = [[LoginViewController alloc]init];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:login animated:YES completion:nil];
            }
        }else {
            if (indexPath.row == 2) {
                bgview.hidden = NO;
            }
            if (indexPath.row == 3) {
                [[Manager sharedManager] writewenjianming:@"login.text" content:@"NO"];
                LoginViewController *login = [[LoginViewController alloc]init];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:login animated:YES completion:nil];
            }
        }
}


- (void)lodpassword {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
            @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
            @"restpassword":textf.text
            };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"user", @"restMyPwd") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            [textf resignFirstResponder];
            [textf1 resignFirstResponder];
            bgview.hidden = YES;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *ca = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ca];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}









@end
