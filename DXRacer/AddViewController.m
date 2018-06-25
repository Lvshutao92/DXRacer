//
//  AddViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/6.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "AddViewController.h"



@interface AddViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *textfield;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30) ;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.btn.backgroundColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
    [btn setImage:[UIImage imageNamed:@"backreturn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
    self.textfield3.delegate = self;
    self.textfield4.delegate = self;
    
    if ([self.string isEqualToString:@"bianji"]) {
        self.textfield1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    }
    
    if ([self.str1 isEqualToString:@"支付宝"]) {
        self.textfield1.text = self.str1;
        self.textfield1.text = @"支付宝";
        self.label.text = @"支付宝名称";
        self.textfield4.text = self.str4;
        
    }else {
        self.textfield1.text = self.str1;
        self.textfield1.text = @"网银转账";
        self.label.text = @"银行名称";
        self.textfield4.text = self.str5;
    }
    self.textfield2.text = self.str2;
    self.textfield3.text = self.str3;
    
    
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickAdd:(id)sender {
    if ([self.string isEqualToString:@"bianji"]) {
        [self lodedit];
    }else {
        [self lodde];
    }
}
//编辑
- (void)lodedit{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (self.textfield1.text != nil && self.textfield2.text != nil && self.textfield3.text != nil && self.textfield4.text != nil && _idstr != nil)  {
        if ([self.textfield1.text isEqualToString:@"支付宝"]){
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idstr,
                    @"type":self.textfield1.text,
                    @"payaccount":self.textfield2.text,
                    @"company_name":self.textfield3.text,
                    @"field1":self.textfield4.text,
                    };
        }else {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idstr,
                    @"type":self.textfield1.text,
                    @"payaccount":self.textfield2.text,
                    @"company_name":self.textfield3.text,
                    @"bank_name":self.textfield4.text,
                    };
        }
        
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"payaccount",@"update") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改成功😊" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}
- (void)lodde {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (self.textfield1.text != nil && self.textfield2.text != nil && self.textfield3.text != nil && self.textfield4.text != nil) {
        if ([self.textfield1.text isEqualToString:@"支付宝"]) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"type":self.textfield1.text,
                    @"company_name":self.textfield3.text,
                    @"payaccount":self.textfield2.text,
                    @"field1":self.textfield4.text,
                    };
        }else {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"type":self.textfield1.text,
                    @"company_name":self.textfield3.text,
                    @"payaccount":self.textfield2.text,
                    @"bank_name":self.textfield4.text,
                    };
        }
        
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"payaccount",@"add") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改成功😊" message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
   
}










//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    if ([textField isEqual:self.textfield1]) {
        
        if ([self.string isEqualToString:@"bianji"]) {
            return NO;
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择支付方式" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *putong = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.textfield1.text = @"支付宝";
                self.label.text = @"支付宝名称";
                self.textfield4.placeholder = @"支付宝名称";
            }];
            UIAlertAction *gaoji = [UIAlertAction actionWithTitle:@"网银转账" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.textfield1.text = @"网银转账";
                self.label.text = @"银行名称";
                self.textfield4.placeholder = @"银行名称";
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:putong];
            [alert addAction:gaoji];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }
    }
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
