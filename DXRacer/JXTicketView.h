//
//  FinalTableViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/19.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketViewDelegate <NSObject>

- (void)closeBtnDidClicked;
- (void)ensureBtnDidClicked;
- (void)problomeBtnDidClicked;
- (void)clickSelectedFuKuanFangshi;
@end

@interface JXTicketView : UIView

@property (nonatomic, weak) id<TicketViewDelegate>delegate;

@end
