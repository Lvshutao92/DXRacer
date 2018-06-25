//
//  AppDelegate.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/14.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import <JPush/JPUSHService.h>

#import <AdSupport/ASIdentifierManager.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "MineFourViewController.h"

static NSString * const jpushAppKey = @"9286e629e9394a52fa0790fa";
static NSString * const channel = @"0d3e19374b845740264802c5";
static BOOL isProduction = true;

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property(nonatomic, strong)LoginViewController *login;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    // 获取IDFA  IDFA(广告标识符)-identifierForldentifier
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值   advertisingIdentifier:advertisingId
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:jpushAppKey
                                                channel:channel
                                                apsForProduction:isProduction
                                                ];
   
    __weak typeof(self) weakSelf = self;
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSSet *set1 = [[NSSet alloc] initWithObjects:registrationID,nil];
         [JPUSHService setTags:set1 alias:[[Manager sharedManager] redingwenjianming:@"user_id.text"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];
    }];
    
    self.window.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@",[[Manager sharedManager] redingwenjianming:@"login.text"]);
    if ([[[Manager sharedManager] redingwenjianming:@"login.text"] isEqualToString:@"YES"]) {
        HomePageViewController *home = [[HomePageViewController alloc]init];
        UINavigationController *homeVC = [[UINavigationController alloc]initWithRootViewController:home];
        MessageTableViewController *message = [[MessageTableViewController alloc]init];
        UINavigationController *messageVC = [[UINavigationController alloc]initWithRootViewController:message];
        ShoppingCartViewController *shooping = [[ShoppingCartViewController alloc]init];
        UINavigationController *shoopingVC = [[UINavigationController alloc]initWithRootViewController:shooping];
        MineViewController *mine = [[MineViewController alloc]init];
        UINavigationController *mineVC = [[UINavigationController alloc]initWithRootViewController:mine];
        UITabBarController *tabbarController = [[UITabBarController alloc]init];
        tabbarController.viewControllers = @[mineVC,messageVC,shoopingVC,homeVC];
        self.window.rootViewController = tabbarController;
        
        for (UIBarItem *item in tabbarController.tabBar.items) {
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName, nil]
                                forState:UIControlStateNormal];
            tabbarController.tabBar.tintColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:NSBackgroundColorAttributeName];
            [item setTitleTextAttributes:dict forState:UIControlStateSelected];
        }
        tabbarController.selectedIndex = 0;
        [self.window makeKeyWindow];
    }else {
        self.login = [[LoginViewController alloc]init];
        self.window.rootViewController = self.login;
        
        [self.window makeKeyWindow];
    }
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHidden:) name:@"hidden" object:nil];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    
    

    
    
    
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(32, 157, 149, 1.0)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    
    [[Manager sharedManager] writewenjianming:@"Y_N_Push"  content:@"YES"];
    [[Manager sharedManager] writewenjianming:@"Y_N_Push1" content:@"YES"];
    [[Manager sharedManager] writewenjianming:@"Y_N_Push2" content:@"YES"];
    [[Manager sharedManager] writewenjianming:@"Y_N_Push3" content:@"YES"];
    [[Manager sharedManager] writewenjianming:@"Y_N_Push4" content:@"YES"];

    return YES;
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"---rescode: %d, \n---tags: %@, \n---alias: %@\n", iResCode, tags , alias);
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    double delayInSeconds = 1800.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        exit(0);
    });
}
- (void)clickHidden:(NSNotification *)text {
    HomePageViewController *home = [[HomePageViewController alloc]init];
    UINavigationController *homeVC = [[UINavigationController alloc]initWithRootViewController:home];
    MessageTableViewController *message = [[MessageTableViewController alloc]init];
    UINavigationController *messageVC = [[UINavigationController alloc]initWithRootViewController:message];
    ShoppingCartViewController *shooping = [[ShoppingCartViewController alloc]init];
    UINavigationController *shoopingVC = [[UINavigationController alloc]initWithRootViewController:shooping];
    MineViewController *mine = [[MineViewController alloc]init];
    UINavigationController *mineVC = [[UINavigationController alloc]initWithRootViewController:mine];
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.viewControllers = @[mineVC,messageVC,shoopingVC,homeVC];
    self.window.rootViewController = tabbarController;
    
    for (UIBarItem *item in tabbarController.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:13.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        tabbarController.tabBar.tintColor = RGBACOLOR(32.0, 157.0, 149.0, 1.0);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:NSBackgroundColorAttributeName];
        [item setTitleTextAttributes:dict forState:UIControlStateSelected];
    }
    tabbarController.selectedIndex = 0;
    [self.window makeKeyWindow];
}


//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//添加处理APNs通知回调方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //NSLog(@"userInfo====%@",userInfo);
    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"extras"]; //服务端中Extras字段，key是自己定义的
//    NSLog(@"%@=======%ld----%@----%@",content,badge,customizeField1,sound);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 取到tabbarcontroller
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提醒，是否跳转" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 取到tabbarcontroller
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            // 取到navigationcontroller
            UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
            //跳转到我的消息
            MineFourViewController * messageVC = [[MineFourViewController alloc] init];
            messageVC.navigationItem.title = @"余额充值";
            [nav pushViewController:messageVC animated:YES];
        }];
        UIAlertAction *ca = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ca];
        [alert addAction:sure];
        [tabBarController presentViewController:alert animated:YES completion:nil];
    }
     else {
        if ([[[Manager sharedManager] redingwenjianming:@"login.text"] isEqualToString:@"YES"]) {
            // 取到tabbarcontroller
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            // 取到navigationcontroller
            UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
            //跳转到我的消息
            MineFourViewController * messageVC = [[MineFourViewController alloc] init];
            messageVC.navigationItem.title = @"余额充值";
            [nav pushViewController:messageVC animated:YES];
        }
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"----%@",userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    
//    NSLog(@"url---%@",url);
    return YES;
    
}
  

@end
