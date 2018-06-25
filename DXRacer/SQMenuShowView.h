//
//  SQMenuShowView.h
//  JHTDoctor
//
//  Created
//  Copyright All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQMenuShowView : UIView


- (id)initWithFrame:(CGRect)frame items:(NSArray <NSString *> *)items showPoint:(CGPoint)showPoint;



@property (strong, nonatomic) UIColor *sq_selectColor; //选后的颜色
@property (strong, nonatomic) UIColor *sq_backGroundColor;
@property (copy, nonatomic) void(^selectBlock)(SQMenuShowView *view, NSInteger index);

@property (copy, nonatomic) UIColor *itemTextColor;

@property (strong, nonatomic)UIView *bgview;
- (void)selectBlock:(void(^)(SQMenuShowView *view, NSInteger index))block;

- (void)showView;
- (void)dismissView;

- (void)showView1;
- (void)showView2;
- (void)showView3;
- (void)showView4;


- (void)showViewEditFaPiao1;
- (void)showViewEditFaPiao2;
- (void)showViewEditFaPiao3;

- (void)showViewkaipiao1;
- (void)showViewkaipiao2;
- (void)showViewkaipiao3;

- (void)showViewlsfpsearch1;
- (void)showViewlsfpsearch2;

@end
