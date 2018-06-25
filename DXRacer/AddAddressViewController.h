//
//  AddAddressViewController.h
//  
//
//  Created by ilovedxracer on 2017/6/20.
//
//

#import <UIKit/UIKit.h>

@interface AddAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView  *bottomView;


@property (weak, nonatomic) IBOutlet UITextField *addresstext;
@property (weak, nonatomic) IBOutlet UITextField *shouhuorentext;
@property (weak, nonatomic) IBOutlet UITextField *phonetext;
@property (weak, nonatomic) IBOutlet UITextField *youbiantext;
@property (weak, nonatomic) IBOutlet UITextField *shoujitext;


@property (weak, nonatomic) IBOutlet UITextField *qiqutext;








@property(nonatomic, strong)NSString  *str1;
@property(nonatomic, strong)NSString  *str2;
@property(nonatomic, strong)NSString  *str3;
@property(nonatomic, strong)NSString  *str4;
@property(nonatomic, strong)NSString  *str5;
@property(nonatomic, strong)NSString  *str6;

@end
