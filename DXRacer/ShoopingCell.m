//
//  ShoopingCell.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "ShoopingCell.h"

@interface ShoopingCell()

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *imageView_cell;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//时间
@property (nonatomic,retain) UILabel *dateLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;

@end
@implementation ShoopingCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(245, 246, 248);
        
        
        if ([[[Manager sharedManager] redingwenjianming:@"showmoney.text"] isEqualToString:@"N"]) {
            [self setupview];
        }else {
            [self setupMainView];
        }
    }
    return self;
}
//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}

// 数量加按钮
-(void)addBtnClick
{
    if (self.numAddBlock) {
        self.numAddBlock();
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}

-(void)reloadDataWith:(ShoppingListModel *)model
{    
    [self.imageView_cell sd_setImageWithURL:[NSURL URLWithString:NSString(model.img_url)]placeholderImage:[UIImage imageNamed:@"mine"]];
    self.nameLabel.text = model.skucode;
    self.priceLabel.text = [Manager jinegeshi:model.realprice];
    ;

    self.dateLabel.text = [NSString stringWithFormat:@"总价：%@",[Manager jinegeshi:[NSString stringWithFormat:@"%ld",[model.realprice integerValue]*[model.amount integerValue]]]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.amount];
    self.sizeLabel.text = [NSString stringWithFormat:@"颜色：%@",model.chair_color_name];
    self.selectBtn.selected = self.isSelected;
    model.number = [model.amount integerValue];
    
}

- (void)setupview {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, 100);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = kUIColorFromRGB(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(5, 36, 28, 28);
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.selectBtn setImage:theImage forState:UIControlStateSelected];
    [self.selectBtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.selectBtn];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(40, 5, 60, 90);
    imageBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:imageBgView];
    
    //显示照片
    self.imageView_cell = [[UIImageView alloc]init];
    self.imageView_cell.frame = CGRectMake(40.1, 5.1, 59.8, 89.8);
    //    self.imageView_cell.image = [UIImage imageNamed:@"default_pic_1"];
    self.imageView_cell.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:self.imageView_cell];
    
    
    
    
    //商品名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = CGRectMake(105, 10, 150, 40);
    self.imageView_cell.frame = CGRectMake(40, 5, 60, 90);
    //    self.nameLabel.text = @"海报";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.nameLabel];
    
    //尺寸
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.frame = CGRectMake(105, 60, 100, 30);
    //    self.sizeLabel.text = @"尺寸:58*86cm";
    self.sizeLabel.textColor = RGBCOLOR(132, 132, 132);
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:self.sizeLabel];
    
    //时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.frame = CGRectMake(0, 0, 0, 0);
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = RGBCOLOR(132, 132, 132);
    //    self.dateLabel.text = @"2015-12-03 17:49";
    [bgView addSubview:self.dateLabel];
    
    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.frame = CGRectMake(0,0, 0, 0);
    //    self.priceLabel.text = @"￥100.11";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
    self.priceLabel.textColor = RGBACOLOR(32, 157, 149, 1.0);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.priceLabel];
    
    //数量加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(SCREEN_WIDTH-60, 25, 50, 50);
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.addBtn];
    
    //数量减按钮
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(SCREEN_WIDTH-140, 25, 50, 50);
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [self.cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.frame = CGRectMake(SCREEN_WIDTH-100, 25, 50, 50);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.numberLabel];
}

-(void)setupMainView
{
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, 100);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = kUIColorFromRGB(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(5, 36, 28, 28);
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    
    
    UIImage *theImage = [UIImage imageNamed:@"cart_selected_btn"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.selectBtn setImage:theImage forState:UIControlStateSelected];
    [self.selectBtn setTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    
    
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.selectBtn];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(40, 5, 60, 90);
    imageBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:imageBgView];
    
    //显示照片
    self.imageView_cell = [[UIImageView alloc]init];
    self.imageView_cell.frame = CGRectMake(40.1, 5.1, 59.8, 89.8);
    //    self.imageView_cell.image = [UIImage imageNamed:@"default_pic_1"];
    self.imageView_cell.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:self.imageView_cell];
    
    
    
    
    //商品名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.frame = CGRectMake(105, 5, 150, 30);
    self.imageView_cell.frame = CGRectMake(40, 5, 60, 90);
    //    self.nameLabel.text = @"海报";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.nameLabel];
    
    //尺寸
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.frame = CGRectMake(105, 45, 100, 20);
    //    self.sizeLabel.text = @"尺寸:58*86cm";
    self.sizeLabel.textColor = RGBCOLOR(132, 132, 132);
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:self.sizeLabel];
    
    //时间
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.frame = CGRectMake(105, 75, 100, 20);
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = RGBCOLOR(132, 132, 132);
    //    self.dateLabel.text = @"2015-12-03 17:49";
    [bgView addSubview:self.dateLabel];
    
    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH-125, 5, 100, 30);
    //    self.priceLabel.text = @"￥100.11";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
    self.priceLabel.textColor = RGBACOLOR(32, 157, 149, 1.0);
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.priceLabel];
    
    //数量加按钮
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(SCREEN_WIDTH-60, 50, 50, 50);
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.addBtn];
    
    //数量减按钮
    self.cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutBtn.frame = CGRectMake(SCREEN_WIDTH-140, 50, 50, 50);
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [self.cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [self.cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.frame = CGRectMake(SCREEN_WIDTH-100, 50, 50, 50);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:self.numberLabel];
    
}

@end
