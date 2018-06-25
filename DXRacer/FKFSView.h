//
//  FKFSView.h
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/26.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectedFKFSDelegate <NSObject>
- (void)clickCancle;
@end

@interface FKFSView : UIView
@property(nonatomic, weak)id<selectedFKFSDelegate>delegate;
@end
