//
//  AddAddressViewController.m
//  
//
//  Created by ilovedxracer on 2017/6/20.
//
//

#import "AddAddressViewController.h"
#import "GFAddressPicker.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


#import "FYLCityPickView.h"


@interface AddAddressViewController ()<UITextFieldDelegate,CNContactPickerDelegate,GFAddressPickerDelegate>
@property (nonatomic, strong) GFAddressPicker *pickerView;
@property(nonatomic, strong)UITextField  *textfiel;

@property(nonatomic, strong)UITextField  *textfiel1;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupdelegate];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30) ;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
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
    
    self.addresstext.text   =self.str1 ;
    self.youbiantext.text   =self.str2;
    self.phonetext.text     =self.str3;
    self.shoujitext.text    =self.str4;
    self.shouhuorentext.text=self.str5;
    
    self.qiqutext.text      = self.str6;
    
    
//    self.pickerView.province =
//    self.pickerView.city =
//    self.pickerView.area =
 
    
}

- (void)clickSave {
    [self.navigationController popViewControllerAnimated:YES];
    
//    if ([[Manager sharedManager].shenga isEqual:[NSNull null]] || [Manager sharedManager].shenga.length == 0) {
//        [Manager sharedManager].shenga = @" ";
//    }
//    if ([[Manager sharedManager].shia isEqual:[NSNull null]] || [Manager sharedManager].shia.length == 0) {
//        [Manager sharedManager].shia = @" ";
//    }
//    if ([[Manager sharedManager].qua isEqual:[NSNull null]] || [Manager sharedManager].qua.length == 0) {
//        [Manager sharedManager].qua = @" ";
//    }
    
    [Manager sharedManager].addr2   = self.addresstext.text;
    [Manager sharedManager].youbian = self.youbiantext.text;
    [Manager sharedManager].mobile  = self.phonetext.text;

    [Manager sharedManager].addressPhone   = self.shoujitext.text;
    [Manager sharedManager].addressName    = self.shouhuorentext.text;
    
    [Manager sharedManager].addressDetails = [NSString stringWithFormat:@"%@%@%@%@",[Manager sharedManager].shenga,[Manager sharedManager].shia,[Manager sharedManager].qua,self.addresstext.text];
}

#pragma mark---------CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSArray *phonebumber = contact.phoneNumbers;
    for (CNLabeledValue<CNPhoneNumber*>*phone in phonebumber) {
        CNPhoneNumber *phoneNumber = (CNPhoneNumber *)phone.value;
        self.shoujitext.text = [phoneNumber valueForKey:@"digits"];
    }
}

//- (void)GFAddressPickerWithProvince:(NSString *)province
//                               city:(NSString *)city area:(NSString *)area{
//    [self.pickerView removeFromSuperview];
//    self.qiqutext.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
//    self.qiqutext.textColor = [UIColor blackColor];
//    
//    
//    
//    [Manager sharedManager].shenga   = province;
//    [Manager sharedManager].shia     = city;
//    [Manager sharedManager].qua      = area;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.qiqutext]) {
        [self.shouhuorentext resignFirstResponder];
        [self.shoujitext resignFirstResponder];
        [self.phonetext resignFirstResponder];
        [self.addresstext resignFirstResponder];
        [self.youbiantext resignFirstResponder];
        
//        self.pickerView = [[GFAddressPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        self.pickerView.delegate = self;
//        self.pickerView.font = [UIFont boldSystemFontOfSize:18];
//        [self.view addSubview:self.pickerView];
        
        [FYLCityPickView showPickViewWithComplete:^(NSArray *arr) {
            self.qiqutext.text = [NSString stringWithFormat:@"%@-%@-%@",arr[0],arr[1],arr[2]];
            self.qiqutext.textColor = [UIColor blackColor];
            
            [Manager sharedManager].shenga   = arr[0];
            [Manager sharedManager].shia     = arr[1];
            [Manager sharedManager].qua      = arr[2];
        }];
        
        
         return NO;
    }
    if ([textField isEqual:self.youbiantext]) {
        self.textfiel1 = textField;
    }
    self.textfiel = textField;
    return YES;
}

























- (IBAction)clickButtonAddPhone:(id)sender {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CNContactPickerViewController *picker = [[CNContactPickerViewController alloc]init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"系统版本过低，暂不支持该功能" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}




- (void)GFAddressPickerCancleAction{
    [self.pickerView removeFromSuperview];
}



//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
//    if ([self.textfiel1 isEqual:self.youbiantext]) {
//        //获取键盘的高度
//        NSDictionary *userInfo = [aNotification userInfo];
//        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];
//        int height = keyboardRect.size.height;
//        self.bottomView.frame = CGRectMake(0, 20-height, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//    }
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.pickerView removeFromSuperview];
    [self.textfiel resignFirstResponder];
    [self.textfiel1 resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)setupdelegate{
    self.textfiel.delegate = self;
    
    self.addresstext.delegate = self;
    self.addresstext.borderStyle = UITextBorderStyleNone;
    
    self.shouhuorentext.delegate = self;
    self.shouhuorentext.borderStyle = UITextBorderStyleNone;
    
    self.phonetext.delegate = self;
    self.phonetext.keyboardType = UIKeyboardTypeNumberPad;
    self.phonetext.borderStyle = UITextBorderStyleNone;
    
    self.youbiantext.delegate = self;
    self.youbiantext.keyboardType = UIKeyboardTypeNumberPad;
    self.youbiantext.borderStyle = UITextBorderStyleNone;
    
    self.shoujitext.delegate = self;
    self.shoujitext.keyboardType = UIKeyboardTypeNumberPad;
    self.shoujitext.borderStyle = UITextBorderStyleNone;
    
    self.qiqutext.delegate = self;
    self.qiqutext.borderStyle = UITextBorderStyleNone;
    
    self.textfiel1.delegate = self;
    
}

@end
