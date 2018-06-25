//
//  LookPictureController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/7/7.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "LookPictureController.h"

@interface LookPictureController ()

@end

@implementation LookPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@",self.str);
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.str]];
    });
    
    
    imageview.userInteractionEnabled = YES;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30) ;
    [btn setImage:[UIImage imageNamed:@"back11"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view addSubview:imageview];
    [self.view bringSubviewToFront:btn];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [imageview addGestureRecognizer:pinchGestureRecognizer];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [imageview addGestureRecognizer:panGestureRecognizer];
}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer

{
    
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);          pinchGestureRecognizer.scale = 1;
        
    }  
    
}

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}








- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
