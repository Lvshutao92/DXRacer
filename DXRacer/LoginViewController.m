//
//  LoginViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>
{
    NSString *appstore_verson;
    NSString *appstore_newverson;
}
@property(nonatomic, strong)UITextField *textfield;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(33, 157, 149, 1.0);
    [self setupshuxingdaila];
    
    
    self.numberTextfield.text = [[Manager sharedManager] redingwenjianming:@"number.text"];
    self.usernameTextfield.text = [[Manager sharedManager] redingwenjianming:@"username.text"];
    self.passwordTextfield.text = [[Manager sharedManager] redingwenjianming:@"password.text"];   
    
     [self lodverson];
}


- (void)lodverson{
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"newversion.text"];
    //取出存入的上次版本号版本号
    appstore_verson = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];

    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [session GET:@"https://itunes.apple.com/lookup?id=1259225815" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *arr = [dic objectForKey:@"results"];
        NSDictionary *dict = [arr lastObject];
        //app store版本号
        appstore_newverson = dict[@"version"];
        
        //写入版本号
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"newversion.text"];
        [appstore_newverson writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
//        NSLog(@"appstore版本：%@----存入的版本号：%@",appstore_newverson,appstore_verson);
        
        if (![appstore_verson isEqualToString:appstore_newverson] && appstore_verson != nil){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检测到有新的版本需要更新" message:@"温馨提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1259225815?mt=8"]];
            }];
            [alert addAction:cancel];
            [alert addAction:sure];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)setupshuxingdaila {
    self.numberTextfield.delegate = self;
    self.numberTextfield.borderStyle = UITextBorderStyleNone;
    self.numberTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextfield.delegate = self;
    self.usernameTextfield.borderStyle = UITextBorderStyleNone;
    self.usernameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextfield.delegate = self;
    self.passwordTextfield.borderStyle = UITextBorderStyleNone;
    self.passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextfield.secureTextEntry = YES;
    self.textfield.delegate = self;
}
- (IBAction)clickButton:(id)sender {
     [self lodverson];
    
    [self.usernameTextfield resignFirstResponder];
    [self.numberTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //                NSLog(@"没有网络(断网)");
                [self noNetWorking];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //                NSLog(@"手机自带网络");
                [self loddetails];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //                NSLog(@"WIFI");
                [self loddetails];
                break;
        }
    }];
    // 开始监控
    [manager startMonitoring];
}


- (void)noNetWorking{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法连接网络！请检查蜂窝移动网络或WI-FI是否可用" message:@"温馨提示" preferredStyle:1];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)loddetails {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (self.numberTextfield.text != nil && self.usernameTextfield.text && self.passwordTextfield.text) {
        dic = @{@"business_id":self.numberTextfield.text,@"user_name":self.usernameTextfield.text,@"password":self.passwordTextfield.text};
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"user", @"login") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"===%@",dic);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                
                NSDictionary *dictio = [dic objectForKey:@"rows"];
                //NSLog(@"%@===%@",dic,[[dictio objectForKey:@"user"] objectForKey:@"roleName"]);
                //存储  
                [[Manager sharedManager]writewenjianming:@"rolename.text" content:[NSString stringWithFormat:@"%@",[[dictio objectForKey:@"role"] objectForKey:@"rolename"]]];
                
                [[Manager sharedManager] writewenjianming:@"number.text" content:weakSelf.numberTextfield.text];
                [[Manager sharedManager] writewenjianming:@"username.text" content:weakSelf.usernameTextfield.text];
                [[Manager sharedManager] writewenjianming:@"password.text" content:weakSelf.passwordTextfield.text];
                
                NSString *money = [NSString stringWithFormat:@"%@",[[dictio objectForKey:@"partner"] objectForKey:@"invoice_money"]];
                [[Manager sharedManager] writewenjianming:@"invoice_money.text" content:money];
                
                [[Manager sharedManager] writewenjianming:@"business_name.text" content:[dictio objectForKey:@"business_name"]];
                
                [[Manager sharedManager]writewenjianming:@"user_id.text" content:[NSString stringWithFormat:@"%@",[[dictio objectForKey:@"user"] objectForKey:@"id"]]];
                
                [[Manager sharedManager] writewenjianming:@"partner_name.text" content:[[dictio  objectForKey:@"partner"] objectForKey:@"partner_name"]];
                
                [[Manager sharedManager] writewenjianming:@"partner_id.text" content:[NSString stringWithFormat:@"%@",[[dictio  objectForKey:@"partner"] objectForKey:@"id"]]];
                
                [[Manager sharedManager] writewenjianming:@"business_id.text" content:[[dictio objectForKey:@"partner"] objectForKey:@"business_id"]];
                
                [[Manager sharedManager] writewenjianming:@"mainaccount.text" content:[[dictio objectForKey:@"user"] objectForKey:@"mainaccount"]];
                [[Manager sharedManager] writewenjianming:@"showorder.text" content:[[dictio objectForKey:@"user"] objectForKey:@"showorder"]];
                
                [[Manager sharedManager] writewenjianming:@"showmoney.text" content:[[dictio objectForKey:@"user"] objectForKey:@"showmoney"]];
                
                
                if ([[[Manager sharedManager] redingwenjianming:@"mainaccount.text"]isEqualToString:@"Y"]) {
                    [[Manager sharedManager] writewenjianming:@"showmoney.text" content:@"Y"];
                }
                
                
                
                [[Manager sharedManager] writewenjianming:@"login.text" content:@"NO"];
                
                
                NSDictionary *dict = [[NSDictionary alloc]init];
                NSNotification *notification =[NSNotification notificationWithName:@"hidden" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"登录失败！请检查用户名和密码是否正确" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            [weakSelf.numberTextfield resignFirstResponder];
            [weakSelf.usernameTextfield resignFirstResponder];
            [weakSelf.passwordTextfield resignFirstResponder];
            
            [hud hideAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"登录失败！请检查用户名和密码是否正确" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
           
            [hud hideAnimated:YES];
        }];
    }
 
}


//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
