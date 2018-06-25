//
//  EditZengZhiViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/12.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "EditZengZhiViewController.h"
#import "SQMenuShowView.h"
#import "GFAddressPicker.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface EditZengZhiViewController ()<UITextFieldDelegate,CNContactPickerDelegate,GFAddressPickerDelegate>
{
    UIScrollView *scrollview;
    
    UITextField *textfi;
    
    UITextField *textfield1;
    UITextField *textfield2;
    UITextField *textfield3;
    UITextField *textfield4;
    UITextField *textfield5;
    UITextField *textfield6;
    UITextField *textfield7;
    UITextField *textfield8;
    UITextField *textfield9;
    UITextField *textfield10;
    UITextField *textfield11;
    UITextField *textfield12;
    UITextField *textfield13;
    UITextField *textfield14;
    UITextField *textfield15;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    UILabel *lab5;
    UILabel *lab6;
    UILabel *lab7;
    UILabel *lab8;
    UILabel *lab9;
    UILabel *lab10;
    UILabel *lab11;
    UILabel *lab12;
    UILabel *lab13;
    UILabel *lab14;
    UILabel *lab15;
    float height;
    NSString *receiver_state;
    NSString *receiver_city;
    NSString *receiver_district;
    
}
@property(nonatomic, strong)NSMutableArray *arr;

@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;

@property(nonatomic, strong)SQMenuShowView *showView1;
@property(nonatomic, assign)BOOL isShow1;

@property(nonatomic, strong)SQMenuShowView *showView2;
@property(nonatomic, assign)BOOL isShow2;

@property (nonatomic, strong) GFAddressPicker *pickerView;

@end

@implementation EditZengZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    receiver_state    = _sheng;
    receiver_city     = _shi;
    receiver_district = _qu;
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   
    [self.view addSubview:scrollview];
    
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
    
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        [weakSelf setupbutton:index];
        [scrollview bringSubviewToFront:_showView];
    }];
    [self.showView1 selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow1 = NO;
        [weakSelf setupbutton1:index];
        [scrollview bringSubviewToFront:_showView1];
    }];
    [self.showView2 selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow2 = NO;
        [weakSelf setupbutton2:index];
        [scrollview bringSubviewToFront:_showView2];
    }];
    self.arr = [@[@"订单编号",@"发票总金额",@"发票明细",@"默认订单地址",@"收票人姓名",@"收票人手机号",@"收票省市区",@"详细地址",@"发票类型",@"发票抬头",@"纳税人识别码",@"注册地址",@"注册电话",@"开户银行",@"银行账户"]mutableCopy];
    textfi.delegate = self;
    [self setupview];
}
- (void)clickSave {
    if (_fapiaoleixing == nil) {
        [self lodadd];
    }else {
        [self lodedit];
    }
}

- (void)setupview {
    for (int i = 0; i < self.arr.count; i++) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20*(i+1) + 30*i, 80, 30)];
        lable.text = self.arr[i];
        lable.font = [UIFont systemFontOfSize:13];
        switch (i) {
            case 0:
                lab1 = lable;
                break;
            case 1:
                lab2 = lable;
                break;
            case 2:
                lab3 = lable;
                break;
            case 3:
                lab4 = lable;
                break;
            case 4:
                lab5 = lable;
                break;
            case 5:
                lab6 = lable;
                break;
            case 6:
                lab7 = lable;
                break;
            case 7:
                lab8 = lable;
                break;
            case 8:
                lab9 = lable;
                break;
            case 9:
                lab10 = lable;
                break;
            case 10:
                lab11 = lable;
                break;
            case 11:
                lab12 = lable;
                break;
            case 12:
                lab13 = lable;
                break;
            case 13:
                lab14 = lable;
                break;
            case 14:
                lab15 = lable;
                break;
            default:
                break;
        }
        lable.textAlignment = NSTextAlignmentRight;
        [scrollview addSubview:lable];
    }
    for (int i = 0; i < self.arr.count; i++) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(100, 20*(i+1)+30*i, SCREEN_WIDTH-110, 30)];
        textfield.font = [UIFont systemFontOfSize:13];
        [textfield.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [textfield.layer setBorderWidth:1];
        textfield.borderStyle = UITextBorderStyleRoundedRect;
        switch (i) {
            case 0:
                textfield1 = textfield;
                textfield.text = _dingdanbianhao;
                textfield1.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                break;
            case 1:
                textfield2 = textfield;
                break;
            case 2:
                textfield3 = textfield;
                textfield3.text = @"电脑椅";
                textfield3.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                break;
                
            case 3:
                textfield4 = textfield;
                textfield4.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                textfield4.text = @"是";
                break;
                
            case 4:
                textfield5 = textfield;
                textfield5.text = _name;
                break;
            case 5:
                textfield6 = textfield;
                textfield6.text = _mobile;
                break;
            case 6:
                textfield7 = textfield;
                textfield7.text = _shengshiqu;
                break;
            case 7:
                textfield8 = textfield;
                textfield8.text = _address;
                break;
            case 8:
                textfield9 = textfield;
                textfield9.text = _fapiaoleixing;
                textfield9.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                if (_fapiaoleixing == nil) {
                    textfield9.text = @"普通发票";
                }
                break;
            case 9:
                textfield10 = textfield;
                
                break;
            case 10:
                textfield11 = textfield;
                
                break;
            case 11:
                textfield12 = textfield;
                break;
            case 12:
                textfield13 = textfield;
                
                break;
            case 13:
                textfield14 = textfield;
                
                break;
            case 14:
                textfield15 = textfield;

                break;
            default:
                break;
        }
        textfield.delegate = self;
        
        [scrollview addSubview:textfield];
    }
    [scrollview bringSubviewToFront:_showView];
    [scrollview bringSubviewToFront:_showView1];
    [scrollview bringSubviewToFront:_showView2];
    if ([textfield9.text isEqualToString:@"普通发票"]) {
        
        lab15.hidden = YES;
        lab12.hidden = YES;
        lab13.hidden = YES;
        lab14.hidden = YES;
     
        textfield15.hidden = YES;
        textfield12.hidden = YES;
        textfield13.hidden = YES;
        textfield14.hidden = YES;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    if ([textfield9.text isEqualToString:@"增值税发票"]) {
        lab15.hidden = NO;
        lab12.hidden = NO;
        lab13.hidden = NO;
        lab14.hidden = NO;
        textfield15.hidden = NO;
        textfield12.hidden = NO;
        textfield13.hidden = NO;
        textfield14.hidden = NO;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.2);
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30) ;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
}

- (SQMenuShowView *)showView{
    if (_showView) {
        return _showView;
    }
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,440,SCREEN_WIDTH-110,80}
                                               items:@[@"普通发票",@"增值税发票"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,80}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView];
    [scrollview bringSubviewToFront:_showView];
    return _showView;
}
- (void)setupbutton:(NSInteger )index{
        if (index == 0) {
            textfield9.text = @"普通发票";
            lab15.hidden = YES;
            lab12.hidden = YES;
            lab13.hidden = YES;
            lab14.hidden = YES;
            textfield15.hidden = YES;
            textfield12.hidden = YES;
            textfield13.hidden = YES;
            textfield14.hidden = YES;
            scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        }else {
            textfield9.text = @"增值税发票";
            lab15.hidden = NO;
            lab12.hidden = NO;
            lab13.hidden = NO;
            lab14.hidden = NO;
            textfield15.hidden = NO;
            textfield12.hidden = NO;
            textfield13.hidden = NO;
            textfield14.hidden = NO;
            scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.2);
        }
}

- (SQMenuShowView *)showView1{
    if (_showView1) {
        return _showView1;
    }
    _showView1 = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,190,SCREEN_WIDTH-110,80}
                                                items:@[@"是",@"否"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,80}];
    _showView1.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView1];
    [scrollview bringSubviewToFront:_showView1];
    return _showView1;
}
- (void)setupbutton1:(NSInteger )index{
        if (index == 0) {
            textfield4.text = @"是";
            textfield5.text = _name;
            textfield6.text = _mobile;
            textfield7.text = _shengshiqu;
            textfield8.text = _address;
        }else {
            textfield4.text = @"否";
            textfield5.text = nil;
            textfield6.text = nil;
            textfield7.text = nil;
            textfield8.text = nil;
        }

}

- (SQMenuShowView *)showView2{
    if (_showView2) {
        return _showView2;
    }
    _showView2 = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,140,SCREEN_WIDTH-110,120}
                                                items:@[@"电脑椅",@"办公座椅",@"配件"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,120}];
    _showView2.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView2];
    [scrollview bringSubviewToFront:_showView2];
    return _showView2;
}
- (void)setupbutton2:(NSInteger )index{
    if (index == 0) {
        textfield3.text =@"电脑椅";
    }else if (index == 1){
        textfield3.text =@"办公座椅";
    }else {
        textfield3.text =@"配件";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textfi = textField;
    if ([textField isEqual:textfield1]) {
        return NO;
    }
    if ([textField isEqual:textfield3]) {
        [self.showView dismissView];
        [self.showView1 dismissView];
        _isShow2 = !_isShow2;
        if (_isShow2) {
            [self.showView2 showViewEditFaPiao2];
        }else{
            [self.showView2 dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield4]) {
        [self.showView2 dismissView];
        [self.showView dismissView];
        _isShow1 = !_isShow1;
        if (_isShow1) {
            [self.showView1 showViewEditFaPiao1];
        }else{
            [self.showView1 dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield9]) {
            [self.showView2 dismissView];
            [self.showView1 dismissView];
            _isShow = !_isShow;
            if (_isShow){
                [self.showView showViewEditFaPiao2];
            }else{
                [self.showView dismissView];
            }
        return NO;
    }
    if ([textField isEqual:textfield5] || [textField isEqual:textfield6] || [textField isEqual:textfield8]) {
        if ([textfield4.text isEqualToString:@"是"]){
            return NO;
        }else {
            return YES;
        }
    }
    if ([textField isEqual:textfield7]) {
        [textfield2 resignFirstResponder];
        [textfield5 resignFirstResponder];
        [textfield6 resignFirstResponder];
        [textfield8 resignFirstResponder];
        
        [textfield15 resignFirstResponder];
        [textfield10 resignFirstResponder];
        [textfield11 resignFirstResponder];
        [textfield12 resignFirstResponder];
        [textfield13 resignFirstResponder];
        [textfield14 resignFirstResponder];
        
        if ([textfield4.text isEqualToString:@"否"]){
            self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [self.pickerView updateAddressAtProvince:@"江苏省" city:@"无锡市" town:@"惠山区"];
            self.pickerView.delegate = self;
            self.pickerView.font = [UIFont boldSystemFontOfSize:18];
            [self.view addSubview:self.pickerView];
            [self.view bringSubviewToFront:self.pickerView];
        }else {}
        return NO;
    }    
    return YES;
}

- (void)lodadd{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    NSString *str5;
    NSString *str6;
    NSString *str7;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if ([textfield4.text isEqualToString:@"是"]) {
        str1 = @"Y";
        str2 = @"name";
        str3 = @"mobile";
        str4 = @"receiver_state";
        str5 = @"receiver_city";
        str6 = @"receiver_district";
        str7 = @"receiver_address";
    }else {
        str1 = @"N";
        str2 = @"receive_name";
        str3 = @"receive_phone";
        str4 = @"province";
        str5 = @"city";
        str6 = @"district";
        str7 = @"address";
    }
    if ([textfield9.text isEqualToString:@"普通发票"]) {
        if (self.str_order_id.length != 0 && textfield6.text.length != 0 &&
            receiver_state.length != 0 && textfield8.text.length != 0 &&
            receiver_city.length != 0 && textfield9.text.length != 0 &&
            receiver_district.length != 0 && textfield10.text.length != 0 &&
            str1.length != 0 && textfield11.text.length != 0 &&
            textfield1.text.length != 0 && textfield2.text.length != 0 &&
            textfield3.text.length != 0 && textfield5.text.length != 0){
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"order_id":self.str_order_id,
                    
                    @"order_no":textfield1.text,
                    @"money":textfield2.text,
                    @"detail":textfield3.text,
                    
                    @"defaultStatus":str1,
                    str2:textfield5.text,
                    str3:textfield6.text,
                    str4:receiver_state,
                    str5:receiver_city,
                    str6:receiver_district,
                    str7:textfield8.text,
                    
                    @"type":textfield9.text,
                    @"title":textfield10.text,
                    @"code":textfield11.text,
                    };
        }
    }else{
              if (self.str_order_id.length != 0 && textfield6.text.length != 0 &&
                  receiver_state.length != 0 && textfield8.text.length != 0 &&
                  receiver_city.length != 0 && textfield9.text.length != 0 &&
                  receiver_district.length != 0 && textfield10.text.length != 0 &&
                  str1.length != 0 && textfield11.text.length != 0 &&
                  textfield1.text.length != 0 && textfield12.text.length != 0 && textfield2.text.length != 0 && textfield13.text.length != 0 && textfield3.text.length != 0 && textfield14.text.length != 0 && textfield5.text.length != 0 && textfield15.text.length != 0) {
                  dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                          @"order_id":self.str_order_id,
                          
                          @"order_no":textfield1.text,
                          @"money":textfield2.text,
                          @"detail":textfield3.text,
                          
                          @"defaultStatus":str1,
                          str2:textfield5.text,
                          str3:textfield6.text,
                          str4:receiver_state,
                          str5:receiver_city,
                          str6:receiver_district,
                          str7:textfield8.text,
                          
                          @"type":textfield9.text,
                          @"title":textfield10.text,
                          @"code":textfield11.text,
                          @"addr":textfield12.text,
                          @"phone":textfield13.text,
                          @"bank":textfield14.text,
                          @"bank_no":textfield15.text,
                          };
              }
        }
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice",@"add") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",[dic objectForKey:@"result_msg"]);
        if ([[dic objectForKey:@"result_msg"] isEqualToString:@"申请成功"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请成功" message:@"提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请失败" message:@"提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}
- (void)lodedit{
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    NSString *str5;
    NSString *str6;
    NSString *str7;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([textfield4.text isEqualToString:@"是"]) {
        str1 = @"Y";
        str2 = @"name";
        str3 = @"mobile";
        str4 = @"receiver_state";
        str5 = @"receiver_city";
        str6 = @"receiver_district";
        str7 = @"receiver_address";
    }else {
        str1 = @"N";
        str2 = @"receive_name";
        str3 = @"receive_phone";
        str4 = @"province";
        str5 = @"city";
        str6 = @"district";
        str7 = @"address";
    }
    if ([textfield9.text isEqualToString:@"普通发票"]) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"id":self.str_id,
                    @"order_id":self.str_order_id,
                    @"order_no":textfield1.text,
                    @"money":textfield2.text,
                    @"detail":textfield3.text,
                    @"defaultStatus":str1,
                    str2:textfield5.text,
                    str3:textfield6.text,
                    str4:receiver_state,
                    str5:receiver_city,
                    str6:receiver_district,
                    str7:textfield8.text,
                    @"type":textfield9.text,
                    @"title":textfield10.text,
                    @"code":textfield11.text,
                    };
        }else{
            
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"id":self.str_id,
                    @"order_id":self.str_order_id,
                    @"order_no":textfield1.text,
                    @"money":textfield2.text,
                    @"detail":textfield3.text,
                    
                    @"defaultStatus":textfield4.text,
                    str2:textfield5.text,
                    str3:textfield6.text,
                    str4:receiver_state,
                    str5:receiver_city,
                    str6:receiver_district,
                    str7:textfield8.text,
                    
                    @"type":textfield9.text,
                    @"title":textfield10.text,
                    @"code":textfield11.text,
                    @"addr":textfield12.text,
                    @"phone":textfield13.text,
                    @"bank":textfield14.text,
                    @"bank_no":textfield15.text,
                    };
        }
    
//    NSLog(@"edit======%@",dic);
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice",@"update") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"=-=-=-=%@",dic);
    if ([[dic objectForKey:@"result_code"] isEqualToString:@"success"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请成功" message:@"提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请失败" message:@"提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

}





//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if ([textfi isEqual: textfield15]) {
        scrollview.frame = CGRectMake(0, -280, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield14]) {
        scrollview.frame = CGRectMake(0, -250, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield13]) {
        scrollview.frame = CGRectMake(0, -220, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield12]) {
        scrollview.frame = CGRectMake(0, -190, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield11]) {
        scrollview.frame = CGRectMake(0, -180, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield10]) {
        scrollview.frame = CGRectMake(0, -150, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield9]) {
        scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield8]) {
        scrollview.frame = CGRectMake(0, -120, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield7]) {
        scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield6]) {
        scrollview.frame = CGRectMake(0, -90, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else {
        scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if ([textfield9.text isEqualToString:@"普通发票"]) {
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    if ([textfield9.text isEqualToString:@"增值税发票"]) {
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.2);
    }
}
- (void)GFAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city area:(NSString *)area{
    [self.pickerView removeFromSuperview];
    receiver_state = province;
    receiver_city = city;
    receiver_district = area;
    textfield7.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
}
- (void)GFAddressPickerCancleAction{
    [self.pickerView removeFromSuperview];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [textfield2 resignFirstResponder];
    [textfield5 resignFirstResponder];
    [textfield6 resignFirstResponder];
    [textfield8 resignFirstResponder];
    [textfield15 resignFirstResponder];
    [textfield10 resignFirstResponder];
    [textfield11 resignFirstResponder];
    [textfield12 resignFirstResponder];
    [textfield13 resignFirstResponder];
    [textfield14 resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr  = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
@end
