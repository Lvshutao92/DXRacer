//
//  AddOrEditController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/7.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "AddOrEditController.h"
#import "SQMenuShowView.h"
@interface AddOrEditController ()<UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)UIImage *image;


@property(nonatomic, strong)UITableView *tableview;



@property(nonatomic, strong)SQMenuShowView *showView;
@property(nonatomic, assign)BOOL isShow;
@property(nonatomic, strong)SQMenuShowView *showView1;
@property(nonatomic, assign)BOOL isShow1;
@property(nonatomic, strong)SQMenuShowView *showView3;
@property(nonatomic, assign)BOOL isShow3;

@end

@implementation AddOrEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]init];
    self.tableview.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.view bringSubviewToFront:self.tableview];
    
    self.textfield.delegate = self;
    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
    self.textfield2.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield3.delegate = self;
    self.textfield4.delegate = self;
    self.textfield5.delegate = self;
    self.textfield6.delegate = self;
   
    self.textview.delegate = self;
    [self.textview.layer setBorderWidth:1];
    [self.textview.layer setBorderColor:[UIColor colorWithWhite:.7 alpha:.3].CGColor];
    self.textview.layer.masksToBounds = YES;
    self.textview.layer.cornerRadius = 5;
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData  *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.strimg]];
        UIImage *imagesave = [[UIImage alloc]initWithData:data];
        NSData   *imageData = UIImagePNGRepresentation(imagesave);
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPathToFile = [documentsDirectory stringByAppendingString:@"/us.png"];
        [imageData writeToFile:fullPathToFile atomically:NO];
    });
    if ([self.str isEqualToString:@"bianji"]) {
        self.textfield1.text = self.str1;
        self.textfield2.text = self.str2;
        self.textfield3.text = self.str3;
        self.textfield4.text = self.str4;
        self.textfield5.text = self.str5;
        self.textfield6.text = self.str6;
        self.textview.text   = self.str7;
        
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.strimg]];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        [weakSelf setupbutton:index];       
    }];
    [self.showView1 selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow1 = NO;
        [weakSelf setupbutton1:index];
    }];
    [self.showView3 selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow3 = NO;
        [weakSelf setupbutton3:index];
    }];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30) ;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    
    
    
    
    
    
    
}



- (void)clickSave {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.str isEqualToString:@"bianji"]) {
        [self edit];
    }else {
        [self add];
    }
}

- (void)add {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/us.png"];
    UIImage * image =  [UIImage imageNamed:fullPathToFile];
    
    
    CGSize size = image.size;
    size.height = size.height/5;
    size.width  = size.width/5;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (self.textfield1.text.length != 0 && self.textfield2.text.length != 0 && self.textfield3.text.length != 0 && self.textfield4.text.length != 0 && self.textfield5.text.length != 0 && self.textfield6.text.length != 0 && self.textview.text.length != 0) {
        dic = @{@"amount":self.textfield2.text,
                @"paytype":self.textfield3.text,
                @"payaccount":self.textfield4.text,
                @"colaccount":self.textfield6.text,
                @"payremark":self.textview.text,
                @"coltype":self.textfield5.text,
                @"topuptype":self.textfield1.text,
                @"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"topup",@"add") parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(scaledImage);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"certificateurl" fileName:fileName mimeType:@"image/png"];
            //        NSLog(@"%@===%@",data,fileName);
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            //        NSLog(@"---------%@",dic);
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dic objectForKey:@"result_msg"] message:@"温馨提示" preferredStyle:1];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
}
- (void)edit {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/us.png"];
    UIImage * image =  [UIImage imageNamed:fullPathToFile];

    CGSize size = image.size;
    size.height = size.height/5;
    size.width  = size.width/5;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (self.textfield1.text.length != 0 && self.textfield2.text.length != 0 && self.textfield3.text.length != 0 && self.textfield4.text.length != 0 && self.textfield5.text.length != 0 && self.textfield6.text.length != 0 && self.textview.text.length != 0 && self.strid.length != 0) {
        dic = @{@"amount":self.textfield2.text,
                @"paytype":self.textfield3.text,
                @"payaccount":self.textfield4.text,
                @"colaccount":self.textfield6.text,
                @"payremark":self.textview.text,
                @"coltype":self.textfield5.text,
                @"topuptype":self.textfield1.text,
                
                @"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                
                @"id":self.strid,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        
        [session POST:KURLNSString(@"topup",@"update") parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(scaledImage);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:data name:@"certificateurl" fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
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
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.textfield isEqual:self.textfield4]) {
        self.textfield4.text = [Manager sharedManager].array[indexPath.row];
    }
    if ([self.textfield isEqual:self.textfield6]){
        self.textfield6.text = [Manager sharedManager].arr[indexPath.row];
    }
    self.tableview.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.textfield isEqual:self.textfield4]) {
        return [Manager sharedManager].array.count;
    }
    if ([self.textfield isEqual:self.textfield6]){
        return [Manager sharedManager].arr.count;
    }
   return [Manager sharedManager].arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.textfield isEqual:self.textfield4]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
        cell.textLabel.text = [Manager sharedManager].array[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    cell.textLabel.backgroundColor = [UIColor colorWithWhite:.99 alpha:.05];
    cell.textLabel.text = [Manager sharedManager].arr[indexPath.row];
    
    return cell;
}



- (IBAction)clickCommitPicture:(id)sender {
    [self selectedImage];
}
- (void)selectedImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片获取路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickerPictureFromAlbum];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pictureFromCamera];
    }];
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionA setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
    [actionB setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
    [actionC setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [alert addAction:actionC];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//从手机相册选取图片功能
- (void)pickerPictureFromAlbum {
    //1.创建图片选择器对象
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.allowsEditing = YES;
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}
//拍照--照相机是否可用
- (void)pictureFromCamera {
    //照相机是否可用
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        //提示框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"摄像头不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;//如果不存在摄像头，直接返回即可，不需要做调用相机拍照的操作；
    }
    //创建图片选择器对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置图片选择器选择图片途径
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//从照相机拍照选取
    //设置拍照时下方工具栏显示样式
    imagePicker.allowsEditing = YES;
    //设置代理对象
    imagePicker.delegate = self;
    //最后模态退出照相机即可
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
//当得到选中的图片或视频时触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        UIImage *imagesave = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        UIImageOrientation imageOrientation = imagesave.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(imagesave.size);
        [imagesave drawInRect:CGRectMake(0, 0, imagesave.size.width, imagesave.size.height)];
        imagesave = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
        }
        self.imageview.image = imagesave;
    
        NSData * imageData = UIImagePNGRepresentation(imagesave);
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/us.png"];
        [imageData writeToFile:fullPathToFile atomically:NO];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    if ([textField isEqual:self.textfield2]) {
        return YES;
    }
    if ([textField isEqual:self.textfield1]){
        self.tableview.hidden = YES;
        [self.showView1 dismissView];
        [self.showView3 dismissView];

         [self.textfield2 resignFirstResponder];
        _isShow = !_isShow;
        if (_isShow) {
            [self.showView showView];
        }else{
            [self.showView dismissView];
        }
    }
    if ([textField isEqual:self.textfield3]){
        self.tableview.hidden = YES;
        [self.showView dismissView];
        [self.showView3 dismissView];
         [self.textfield2 resignFirstResponder];
        self.textfield4.text = nil;
        self.tableview.hidden = YES;
        _isShow1 = !_isShow1;
        if (_isShow1) {
            [self.showView1 showView1];
        }else{
            [self.showView1 dismissView];
        }
        return NO;
    }
    if ([textField isEqual:self.textfield5]){
        self.tableview.hidden = YES;
        [self.showView dismissView];
        [self.showView1 dismissView];
         [self.textfield2 resignFirstResponder];
        self.textfield6.text = nil;
        self.tableview.hidden = YES;
        _isShow3 = !_isShow3;
        if (_isShow3) {
            [self.showView3 showView3];
        }else{
            [self.showView3 dismissView];
        }
        return NO;
    }
    
    if ([textField isEqual:self.textfield4]){
        
        [self.showView dismissView];
        [self.showView1 dismissView];
        [self.showView3 dismissView];
         [self.textfield2 resignFirstResponder];
        self.tableview.frame = CGRectMake(0, 0, 0, 0);
        if ([Manager sharedManager].array.count != 0) {
            self.tableview.frame = CGRectMake(90, 220, SCREEN_WIDTH-100, 150);
            if (self.tableview.hidden == NO) {
                self.tableview.hidden = YES;
            }else {
                self.tableview.hidden = NO;
            }
        }
        return NO;
    }
    if ([textField isEqual:self.textfield6]){
        [self.showView dismissView];
        [self.showView1 dismissView];
        [self.showView3 dismissView];
        [self.textfield2 resignFirstResponder];
        self.tableview.frame = CGRectMake(0, 0, 0, 0);
        if ([Manager sharedManager].arr.count != 0) {
            self.tableview.frame = CGRectMake(90, 300, SCREEN_WIDTH-100, 150);
            if (self.tableview.hidden == NO) {
                self.tableview.hidden = YES;
            }else {
                self.tableview.hidden = NO;
            }
        }
       return NO;
    }
    return NO;
}
//充值类型
- (SQMenuShowView *)showView{
    if (_showView) {
        return _showView;
    }
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){90,92,SCREEN_WIDTH-100,120}
                                               items:@[@"货款充值",@"挂帐充值",@"虚拟充值"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-100,120}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}
- (void)setupbutton:(NSInteger )index{
    if (index == 0) {
        self.textfield1.text = @"货款充值";
    }
    if (index == 1) {
        self.textfield1.text = @"挂帐充值";
    }
    if (index == 2) {
        self.textfield1.text = @"虚拟充值";
    }
}


//支付方式
- (SQMenuShowView *)showView1{
    if (_showView1) {
        return _showView1;
    }
    _showView1 = [[SQMenuShowView alloc]initWithFrame:(CGRect){90,172,SCREEN_WIDTH-100,80}
                                               items:@[@"支付宝",@"网银转账"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-100,80}];
    _showView1.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView1];
    return _showView1;
}
- (void)setupbutton1:(NSInteger )index{
    if (index == 0) {
        self.textfield3.text = @"支付宝";
    }
    if (index == 1) {
        self.textfield3.text = @"网银转账";
    }
    [self lodzhifufangshi];
}
- (void)lodzhifufangshi {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (self.textfield3.text != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"paytype":self.textfield3.text,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"topup",@"initPayaccount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"payaccountList"];
            NSString *str;
            [[Manager sharedManager].arr removeAllObjects];
            [[Manager sharedManager].array removeAllObjects];
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                for (NSDictionary *dic in arr) {
                    
                    
                    if ([self.textfield3.text isEqualToString:@"支付宝"]) {
                        str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"company_name"],[dic objectForKey:@"payaccount"],[dic objectForKey:@"field1"]];
                    }else {
                        str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"company_name"],[dic objectForKey:@"payaccount"],[dic objectForKey:@"bank_name"]];
                    }
                    
                    [[Manager sharedManager].array addObject:str];
                    
                    
                    weakSelf.textfield4.text = [[Manager sharedManager].array firstObject];
                }
                
            }
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}





//收款方式
- (SQMenuShowView *)showView3{
    if (_showView3) {
        return _showView3;
    }
    _showView3 = [[SQMenuShowView alloc]initWithFrame:(CGRect){90,252,SCREEN_WIDTH-100,80}
                                                items:@[@"支付宝",@"网银转账"]
                                            showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-100,80}];
    _showView3.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView3];
    return _showView3;
}
- (void)setupbutton3:(NSInteger )index{
    if (index == 0) {
        self.textfield5.text = @"支付宝";
    }
    if (index == 1) {
        self.textfield5.text = @"网银转账";
    }
    [self lodshoukuanfangshi];
}
- (void)lodshoukuanfangshi {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    
    if (self.textfield5.text != nil) {
        dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
                @"partner_name":[[Manager sharedManager] redingwenjianming:@"partner_name.text"],
                @"coltype":self.textfield5.text,
                };
        NSString *str = [[Manager sharedManager] convertToJsonData:dic];
        NSString *jsonStr = [Manager encodeBase64String:str];
        NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
        NSDictionary *para = [[NSDictionary alloc]init];
        para = @{@"token":tokenStr,@"json":jsonStr};
        [session POST:KURLNSString(@"topup",@"initColaccount") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
            
            [[Manager sharedManager].arr removeAllObjects];
            [[Manager sharedManager].array removeAllObjects];
            NSString *str;
            NSMutableArray *arr = [[dic objectForKey:@"rows"] objectForKey:@"collaccountList"];
            if ([[dic objectForKey:@"result_code"]isEqualToString:@"success"]) {
                for (NSDictionary *dic in arr) {
                    
                    if ([self.textfield5.text isEqualToString:@"支付宝"]) {
                        str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"companyname"],[dic objectForKey:@"colaccount"],[dic objectForKey:@"remark1"]];
                    }else{
                        str = [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"companyname"],[dic objectForKey:@"colaccount"],[dic objectForKey:@"back_name"]];
                    }
                    [[Manager sharedManager].arr addObject:str];
                    weakSelf.textfield6.text = [[Manager sharedManager].arr firstObject];
                }
            }
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}








-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [self.textfield resignFirstResponder];
     [self.textview resignFirstResponder];
   
     [self.showView dismissView];
     [self.showView1 dismissView];
     [self.showView3 dismissView];
    
    
     self.tableview.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
