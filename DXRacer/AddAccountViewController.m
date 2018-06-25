//
//  AddAccountViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/21.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "AddAccountViewController.h"

@interface AddAccountViewController ()<UITextFieldDelegate>
{
    NSString *statuss;
    
    NSString *string1;
    NSString *string2;
    BOOL is1;
    BOOL is2;
}
@property(nonatomic, strong)UITextField  *textfiel;


@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30) ;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    if ([self.string isEqualToString:@"bianji"]) {
        self.usertex.text = self.username;
        self.Passwordtext.placeholder = @"不修改不用填";
        self.nametex.text  = self.xingming;
        self.roleText.text = self.roleString;
        self.statustext.hidden = NO;
        self.statusl.hidden = NO;
        self.statuslabel.hidden = NO;
        
        if ([self.status isEqualToString:@"Y"]) {
            self.statustext.text = @"启用";
            statuss = @"Y";
        }else {
            self.statustext.text = @"禁用";
            statuss = @"N";
        }
//        NSLog(@"%@---%@",self.showorder,self.showmoney);
        if ([self.showorder isEqualToString:@"Y"] && [self.showmoney isEqualToString:@"Y"]) {
            string1 = @"showorder";
            string2 = @"showmony";
                        UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
                        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        [self.btnTwo setImage:theImage forState:UIControlStateNormal];
                        [self.btnTwo setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
            
                        UIImage *theImage1 = [UIImage imageNamed:@"cart_selected_btn"];
                        theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        [self.btnOne setImage:theImage1 forState:UIControlStateNormal];
                        [self.btnOne setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
            is1 = YES;
            is2 = YES;
        }else if ([self.showorder isEqualToString:@"Y"] && [self.showmoney isEqualToString:@"N"]){
            string1 = @"showorder";
            string2 = nil;
            UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
            theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.btnOne setImage:theImage forState:UIControlStateNormal];
            [self.btnOne setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
            [self.btnTwo setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
            is1 = YES;
            is2 = NO;
        }else if ([self.showorder isEqualToString:@"N"] && [self.showmoney isEqualToString:@"Y"]){
            string1 = nil;
            string2 = @"showmony";
            UIImage *theImage1 = [UIImage imageNamed:@"cart_selected_btn"];
            theImage1 = [theImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.btnTwo setImage:theImage1 forState:UIControlStateNormal];
            [self.btnTwo setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
            [self.btnOne setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
            is1 = NO;
            is2 = YES;
        }else if ([self.showorder isEqualToString:@"N"] && [self.showmoney isEqualToString:@"N"]) {
            [self.btnOne setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
            [self.btnTwo setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
            string1 = nil;
            string2 = nil;
            is1 = NO;
            is2 = NO;
        }
        
    }else {
        self.statustext.hidden = YES;
        self.statusl.hidden = YES;
        self.statuslabel.hidden = YES;
    }
    [self setupdelegate];
    
}
- (void)setupdelegate{
    self.textfiel.delegate = self;
    
    self.usertex.delegate = self;
    self.usertex.borderStyle = UITextBorderStyleNone;
    
    self.nametex.delegate = self;
    self.nametex.borderStyle = UITextBorderStyleNone;
    
    self.Passwordtext.delegate = self;
    self.Passwordtext.borderStyle = UITextBorderStyleNone;
    self.Passwordtext.secureTextEntry = YES;
    
    self.roleText.delegate = self;
    self.roleText.borderStyle = UITextBorderStyleNone;
    
    self.statustext.delegate = self;
    self.statustext.borderStyle = UITextBorderStyleNone;
}
- (void)lod {
   
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (self.nametex.text.length != 0 && self.roleText.text.length != 0 &&
        self.usertex.text.length != 0 && self.Passwordtext.text.length != 0) {
        
        if ([string1 isEqualToString:@"showorder"] &&  string2 == nil) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showorder":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    };
        }
        else if ([string2 isEqualToString:@"showmony"] && string1 == nil) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showmoney":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    };
        }
        else if ([string2 isEqualToString:@"showmony"] && [string1 isEqualToString:@"showorder"]) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showmoney":@"Y",
                    @"showorder":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    };
        }
        else {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"partner_id":[[Manager sharedManager] redingwenjianming:@"partner_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    };
        }
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"myAccount",@"addAccount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
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
- (void)lodedit {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([self.statustext.text isEqualToString:@"禁用"]) {
        statuss = @"N";
    }else{
        statuss = @"Y";
    }
    if (self.Passwordtext.text.length == 0) {
        self.Passwordtext.text = self.mima;
    }
//    NSLog(@"%@----%@",string1,string2);
    if (self.idString.length != 0 && self.nametex.text.length != 0 &&
        self.roleText.text.length != 0 && self.usertex.text.length != 0) {
        
        if ([string1 isEqualToString:@"showorder"] &&  string2 == nil) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showorder":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idString,
                    @"status":statuss,
                    };
        }
       if ([string2 isEqualToString:@"showmony"] && string1 == nil) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showmoney":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idString,
                    @"status":statuss,
                    };
        }
        if ([string2 isEqualToString:@"showmony"] && [string1 isEqualToString:@"showorder"]) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"showmoney":@"Y",
                    @"showorder":@"Y",
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idString,
                    @"status":statuss,
                    };
        }
        if (string1 == nil && string2 == nil) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"user_name":self.usertex.text,
                    @"realname":self.nametex.text,
                    @"roleName":self.roleText.text,
                    @"password":self.Passwordtext.text,
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.idString,
                    @"status":statuss,
                    };
        }
//        NSLog(@"--------------%@",dic);
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"myAccount",@"updateAccount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
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
- (void)clickSave {
    if ([self.string isEqualToString:@"bianji"]) {
        [self lodedit];
    }else {
        [self lod];
    }
    
}

- (IBAction)clickButtonOne:(id)sender {
    [self.usertex resignFirstResponder];
    [self.nametex resignFirstResponder];
    [self.Passwordtext resignFirstResponder];
    if (is1 == NO) {
        UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.btnOne setImage:theImage forState:UIControlStateNormal];
        [self.btnOne setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
        string1 = @"showorder";
    }else {
        [self.btnOne setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
        string1 = nil;
    }
    is1 = !is1;
    
    
}
- (IBAction)clickButtonTwo:(id)sender {
    [self.usertex resignFirstResponder];
    [self.nametex resignFirstResponder];
    [self.Passwordtext resignFirstResponder];
    if (is2 == NO) {
        UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
        theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.btnTwo setImage:theImage forState:UIControlStateNormal];
        [self.btnTwo setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
        string2 = @"showmony";
    }else {
        [self.btnTwo setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
        string2 = nil;
    }
    is2 = !is2;
    
}



//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.roleText]) {
        [self.usertex resignFirstResponder];
        [self.nametex resignFirstResponder];
        [self.Passwordtext resignFirstResponder];
     
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择角色" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *putong = [UIAlertAction actionWithTitle:@"普通子账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.roleText.text = @"普通子账户";
        }];
        UIAlertAction *gaoji = [UIAlertAction actionWithTitle:@"高级子账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.roleText.text = @"高级子账户";
        }];
        UIAlertAction *caiwu = [UIAlertAction actionWithTitle:@"财务子账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.roleText.text = @"财务子账户";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alert addAction:putong];
        [alert addAction:gaoji];
        [alert addAction:caiwu];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
         return NO;
    }
    if ([textField isEqual:self.statustext]) {
        [self.usertex resignFirstResponder];
        [self.nametex resignFirstResponder];
        [self.Passwordtext resignFirstResponder];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"更改状态" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *putong = [UIAlertAction actionWithTitle:@"禁用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.statustext.text = @"禁用";
            statuss = @"N";
        }];
        UIAlertAction *gaoji = [UIAlertAction actionWithTitle:@"启动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.statustext.text = @"启动";
            statuss = @"Y";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:putong];
        [alert addAction:gaoji];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    if ([textField isEqual:self.usertex]) {
        if ([self.string isEqualToString:@"bianji"]) {
            return NO;
        }else {
            self.usertex.placeholder = @"请填写用户名";
            return YES;
        }
    }
    
   
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    
    [self.usertex resignFirstResponder];
    [self.nametex resignFirstResponder];
    [self.Passwordtext resignFirstResponder];
    [self.roleText resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
