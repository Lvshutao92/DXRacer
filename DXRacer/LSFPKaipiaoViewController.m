//
//  LSFPKaipiaoViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/18.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "LSFPKaipiaoViewController.h"
#import "SQMenuShowView.h"
#import "GFAddressPicker.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface LSFPKaipiaoViewController ()<UITextFieldDelegate,CNContactPickerDelegate,GFAddressPickerDelegate>
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
    UITextField *textfield16;
    UITextField *textfield17;
    UITextField *textfield18;
    UITextField *textfield19;
    
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
    UILabel *lab16;
    UILabel *lab17;
    UILabel *lab18;
    UILabel *lab19;
    
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

@implementation LSFPKaipiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    receiver_state    = _sheng;
    receiver_city     = _shi;
    receiver_district = _qu;
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
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
    self.arr = [@[@"发票物流公司",@"发票物流单号",@"发票运费",@"发票号",@"订单编号",@"发票总金额",@"发票明细",@"默认订单地址",@"收票人姓名",@"收票人手机号",@"收票省市区",@"详细地址",@"发票类型",@"发票抬头",@"纳税人识别码",@"注册地址",@"注册电话",@"开户银行",@"银行账户"]mutableCopy];
    textfi.delegate = self;
    [self setupview];
}

- (void)clickSave {
    [self lodKaiPiao:self.kaipiao_id];
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
            case 15:
                lab16 = lable;
                break;
            case 16:
                lab17 = lable;
                break;
            case 17:
                lab18 = lable;
                break;
            case 18:
                lab19 = lable;
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
        switch (i) {
            case 0:
                textfield1 = textfield;
                textfield1.text = @"顺丰快递";
                textfield1.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                break;
            case 1:
                textfield2 = textfield;
                
                break;
            case 2:
                textfield3 = textfield;
                
                break;
                
            case 3:
                textfield4 = textfield;
                
                break;
                
            case 4:
                textfield5 = textfield;
                textfield5.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                textfield5.text = _dingdanbianhao;
                break;
            case 5:
                textfield6 = textfield;
                
                break;
            case 6:
                textfield7 = textfield;
                textfield7.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                textfield7.text = @"电脑椅";
                break;
            case 7:
                textfield8 = textfield;
                textfield8.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                textfield8.text = @"是";
                break;
            case 8:
                textfield9 = textfield;
                textfield9.text = _name;
                break;
            case 9:
                textfield10 = textfield;
                textfield10.text = _mobile;
                break;
            case 10:
                textfield11 = textfield;
                textfield11.text = _shengshiqu;
                break;
            case 11:
                textfield12 = textfield;
                textfield12.text = _address;
                break;
            case 12:
                textfield13 = textfield;
                textfield13.text = _fapiaoleixing;
                textfield13.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                if (_fapiaoleixing == nil) {
                    textfield13.text = @"普通发票";
                }
                break;
            case 13:
                textfield14 = textfield;
                textfield14.text = self.fptitle;
                break;
            case 14:
                textfield15 = textfield;
                textfield15.text = self.fpcode;
                break;
            case 15:
                textfield16 = textfield;
                textfield16.text = self.fpaddress;
                break;
            case 16:
                textfield17 = textfield;
                textfield17.text = self.fpphone;
                break;
            case 17:
                textfield18 = textfield;
                textfield18.text = self.fpbank;
                break;
            case 18:
                textfield19 = textfield;
                textfield19.text = self.fpbankno;
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
    if ([textfield13.text isEqualToString:@"普通发票"]) {
        
        lab19.hidden = YES;
        lab18.hidden = YES;
        lab17.hidden = YES;
        lab16.hidden = YES;
        
        textfield16.hidden = YES;
        textfield17.hidden = YES;
        textfield18.hidden = YES;
        textfield19.hidden = YES;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
    }
    if ([textfield13.text isEqualToString:@"增值税发票"]) {
        lab16.hidden = NO;
        lab17.hidden = NO;
        lab18.hidden = NO;
        lab19.hidden = NO;
        textfield16.hidden = NO;
        textfield17.hidden = NO;
        textfield18.hidden = NO;
        textfield19.hidden = NO;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.45);
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
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,650,SCREEN_WIDTH-110,80}
                                               items:@[@"普通发票",@"增值税发票"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,80}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView];
    [scrollview bringSubviewToFront:_showView];
    return _showView;
}
- (void)setupbutton:(NSInteger )index{
    if (index == 0) {
        textfield13.text = @"普通发票";
        lab16.hidden = YES;
        lab17.hidden = YES;
        lab18.hidden = YES;
        lab19.hidden = YES;
        textfield19.hidden = YES;
        textfield18.hidden = YES;
        textfield17.hidden = YES;
        textfield16.hidden = YES;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
    }else {
        textfield13.text = @"增值税发票";
        lab19.hidden = NO;
        lab18.hidden = NO;
        lab17.hidden = NO;
        lab16.hidden = NO;
        textfield16.hidden = NO;
        textfield17.hidden = NO;
        textfield18.hidden = NO;
        textfield19.hidden = NO;
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.45);
    }
}

- (SQMenuShowView *)showView1{
    if (_showView1) {
        return _showView1;
    }
    _showView1 = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,400,SCREEN_WIDTH-110,80}
                                                items:@[@"是",@"否"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,80}];
    _showView1.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView1];
    [scrollview bringSubviewToFront:_showView1];
    return _showView1;
}
- (void)setupbutton1:(NSInteger )index{
    if (index == 0) {
        textfield8.text = @"是";
        textfield9.text = _name;
        textfield10.text = _mobile;
        textfield11.text = _shengshiqu;
        textfield12.text = _address;
    }else {
        textfield8.text = @"否";
        textfield9.text = nil;
        textfield10.text = nil;
        textfield11.text = nil;
        textfield12.text = nil;
    }
}

- (SQMenuShowView *)showView2{
    if (_showView2) {
        return _showView2;
    }
    _showView2 = [[SQMenuShowView alloc]initWithFrame:(CGRect){100,350,SCREEN_WIDTH-110,120}
                                                items:@[@"电脑椅",@"办公座椅",@"配件"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-110,120}];
    _showView2.sq_backGroundColor = [UIColor whiteColor];
    [scrollview addSubview:_showView2];
    [scrollview bringSubviewToFront:_showView2];
    return _showView2;
}
- (void)setupbutton2:(NSInteger )index{
    if (index == 0) {
        textfield7.text =@"电脑椅";
    }else if (index == 1){
        textfield7.text =@"办公座椅";
    }else {
        textfield7.text =@"配件";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textfi = textField;
    if ([textField isEqual:textfield1] || [textField isEqual:textfield5]) {
        return NO;
    }
    if ([textField isEqual:textfield7]) {
        [self.showView dismissView];
        [self.showView1 dismissView];
        _isShow2 = !_isShow2;
        if (_isShow2) {
            [self.showView2 showViewkaipiao1];
        }else{
            [self.showView2 dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield8]) {
        [self.showView2 dismissView];
        [self.showView dismissView];
        _isShow1 = !_isShow1;
        if (_isShow1) {
            [self.showView1 showViewkaipiao2];
        }else{
            [self.showView1 dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield13]) {
        [self.showView2 dismissView];
        [self.showView1 dismissView];
        _isShow = !_isShow;
        if (_isShow){
            [self.showView showViewkaipiao3];
        }else{
            [self.showView dismissView];
        }
        return NO;
    }
    if ([textField isEqual:textfield9] || [textField isEqual:textfield10] || [textField isEqual:textfield12]) {
        if ([textfield8.text isEqualToString:@"是"]){
            return NO;
        }else {
            return YES;
        }
    }
    if ([textField isEqual:textfield11]) {
        [textfield2 resignFirstResponder];
        [textfield3 resignFirstResponder];
        [textfield4 resignFirstResponder];
        
        [textfield6 resignFirstResponder];
        [textfield9 resignFirstResponder];
        [textfield10 resignFirstResponder];
        [textfield12 resignFirstResponder];
        
        [textfield19 resignFirstResponder];
        [textfield14 resignFirstResponder];
        [textfield15 resignFirstResponder];
        [textfield16 resignFirstResponder];
        [textfield17 resignFirstResponder];
        [textfield18 resignFirstResponder];
        
        if ([textfield8.text isEqualToString:@"否"]){
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





- (void)lodKaiPiao:(NSString *)idstr {
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
    NSString *str5;
    NSString *str6;
    
    NSString *strr;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([textfield8.text isEqualToString:@"是"]) {
        strr = @"Y";
        str1 = @"name";
        str2 = @"mobile";
        str3 = @"receiver_state";
        str4 = @"receiver_city";
        str5 = @"receiver_district";
        str6 = @"receiver_address";
    }else{
        strr = @"N";
        str1 = @"receive_name";
        str2 = @"receive_phone";
        str3 = @"province";
        str4 = @"city";
        str5 = @"district";
        str6 = @"address";
    }
    
    if ([textfield13.text isEqualToString:@"增值税发票"]) {
        if (textfield2.text.length != 0 && textfield3.text.length != 0 &&
            textfield4.text.length != 0 && textfield6.text.length != 0 &&
            textfield9.text.length != 0 && textfield10.text.length != 0 &&
            textfield12.text.length != 0 && textfield13.text.length != 0 &&
            textfield14.text.length != 0 && textfield15.text.length != 0 &&
            receiver_state.length != 0 && receiver_city.length != 0 &&
            receiver_district.length != 0 && self.kaipiao_id.length != 0 &&
            textfield16.text.length != 0 && textfield17.text.length != 0 &&
            textfield18.text.length != 0 && textfield19.text.length != 0){
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.kaipiao_id,
                    
                    @"expres":textfield1.text,
                    @"logistics_no":textfield2.text,
                    @"logistics_postage":textfield3.text,
                    @"invoice_no":textfield4.text,
                    @"order_no":textfield5.text,
                    @"detail":textfield7.text,
                    @"money":textfield6.text,
                    
                    @"type":textfield13.text,
                    @"title":textfield14.text,
                    @"code":textfield15.text,
                    @"addr":textfield16.text,
                    @"phone":textfield17.text,
                    @"bank":textfield18.text,
                    @"bank_no":textfield19.text,
                    
                    @"default":textfield8.text,
                    str1:textfield9.text,
                    str2:textfield10.text,
                    str3:receiver_state,
                    str4:receiver_city,
                    str5:receiver_district,
                    str6:textfield12.text,
                    @"defaultStatus":strr,
                    };
        }
    }else{
        if (textfield2.text.length != 0 && textfield3.text.length != 0 &&
            textfield4.text.length != 0 && textfield6.text.length != 0 &&
            textfield9.text.length != 0 && textfield10.text.length != 0 &&
            textfield12.text.length != 0 && textfield13.text.length != 0 &&
            textfield14.text.length != 0 && textfield15.text.length != 0 &&
            receiver_state.length != 0 && receiver_city.length != 0 &&
            receiver_district.length != 0 && self.kaipiao_id.length != 0) {
            dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                    @"user_id":[[Manager sharedManager] redingwenjianming:@"user_id.text"],
                    @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                    @"id":self.kaipiao_id,
                    
                    @"expres":textfield1.text,
                    @"logistics_no":textfield2.text,
                    @"logistics_postage":textfield3.text,
                    @"invoice_no":textfield4.text,
                    @"order_no":textfield5.text,
                    @"detail":textfield7.text,
                    @"money":textfield6.text,
                    
                    @"type":textfield13.text,
                    @"title":textfield14.text,
                    @"code":textfield15.text,
                    
                    @"default":textfield8.text,
                    str1:textfield9.text,
                    str2:textfield10.text,
                    str3:receiver_state,
                    str4:receiver_city,
                    str5:receiver_district,
                    str6:textfield12.text,
                    @"defaultStatus":strr,
                    };
        }
    }
    
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"order_invoice", @"setInvoice") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开票成功" message:@"提示" preferredStyle:1];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if ([textfi isEqual: textfield19]) {
        scrollview.frame = CGRectMake(0, -380, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield18]) {
        scrollview.frame = CGRectMake(0, -350, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield17]) {
        scrollview.frame = CGRectMake(0, -320, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield16]) {
        scrollview.frame = CGRectMake(0, -290, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield15]) {
        scrollview.frame = CGRectMake(0, -280, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield14]) {
        scrollview.frame = CGRectMake(0, -250, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield12]) {
        scrollview.frame = CGRectMake(0, -220, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield10]) {
        scrollview.frame = CGRectMake(0, -190, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if ([textfi isEqual: textfield9]) {
        scrollview.frame = CGRectMake(0, -160, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else {
        scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if ([textfield9.text isEqualToString:@"普通发票"]) {
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
    }
    if ([textfield9.text isEqualToString:@"增值税发票"]) {
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.45);
    }
}
- (void)GFAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city area:(NSString *)area{
    [self.pickerView removeFromSuperview];
    receiver_state = province;
    receiver_city = city;
    receiver_district = area;
    textfield11.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
}
- (void)GFAddressPickerCancleAction{
    [self.pickerView removeFromSuperview];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [textfield2 resignFirstResponder];
    [textfield3 resignFirstResponder];
    [textfield4 resignFirstResponder];
    
    [textfield6 resignFirstResponder];
    [textfield9 resignFirstResponder];
    [textfield10 resignFirstResponder];
    [textfield12 resignFirstResponder];
    
    [textfield19 resignFirstResponder];
    [textfield14 resignFirstResponder];
    [textfield15 resignFirstResponder];
    [textfield16 resignFirstResponder];
    [textfield17 resignFirstResponder];
    [textfield18 resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    if ([textfield9.text isEqualToString:@"增值税发票"]) {
//        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.45);
//    }else {
//        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
//    }


    return YES;
}
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr  = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}

@end
