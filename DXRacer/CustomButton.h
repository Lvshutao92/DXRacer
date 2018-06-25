//
//  CustomButton.h
//  test
//
//  Created by on 16/9/8.
//  Copyright © 2016年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
//- (void)setbutton {
//    
//    int b = 0;
//    int hangshu;
//    if (self.dataArray.count % 3 == 0 ) {
//        hangshu = (int )self.dataArray.count / 3;
//    } else {
//        hangshu = (int )self.dataArray.count / 3 + 1;
//    }
//    //j是小于你设置的列数
//    for (int i = 0; i < hangshu; i++) {
//        for (int j = 0; j < 3; j++) {
//            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
//            if ( b  < self.dataArray.count) {
//                ZWFUModel *model = self.dataArray[b];
//                btn.frame = CGRectMake((0  + j * ScreenW/3), (150*Kscaleh + i * 120*Kscaleh) ,ScreenW/3, 120*Kscaleh);
//                btn.backgroundColor = [UIColor whiteColor];
//                btn.tag = b;
//                [btn setTitle:model.name forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                
//                height = i * 120*Kscaleh + 400*Kscaleh;
//                [self.scrollview setContentSize:CGSizeMake(ScreenW, height)];
//                //NSLog(@"-------%lf------%lf",ScreenH,height);
//                
//                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.logo]];
//                UIImage *image = [[UIImage alloc]initWithData:data];
//                
//                [btn setImage:image forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(yejian:) forControlEvents:UIControlEventTouchUpInside];
//                [btn.layer setBorderColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor];
//                [btn.layer setBorderWidth:0.5f];
//                [btn.layer setMasksToBounds:YES];
//                [self.scrollview addSubview:btn];
//                
//                if (b > self.dataArray.count   )
//                {
//                    [btn removeFromSuperview];
//                }
//            }
//            b++;
//            
//        }
//    }
//    
//    
//}

@end
