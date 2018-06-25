//
//  HomePageViewController.m
//  DXRacer
//
//  Created by ilovedxracer on 2017/6/15.
//  Copyright © 2017年 ilovedxracer. All rights reserved.
//

#import "HomePageViewController.h"
#import "SYOneCell.h"
#import "SYTwoCell.h"

#import "TijiaodingdanViewController.h"

#import "MineFourViewController.h"


#import "GongGaoModel.h"
#import "WebViewController.h"
#import "WebTitleCell.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat height;
    NSInteger page;
    NSInteger totalnum;
    
    
    NSString *biaoji;
}
@property(nonatomic, strong)NSMutableArray *ydArray;



@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HomePageViewController


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (NSMutableArray *)ydArray{
    if (_ydArray ==nil) {
        self.ydArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _ydArray;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self lod];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"公告";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"WebTitleCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line.backgroundColor = RGBACOLOR(230, 236, 240, 1);
    self.tableView.tableHeaderView = line;
    
    biaoji = [[Manager sharedManager] redingwenjianming:@"user_id.text"];
    
    
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml",biaoji]];
    self.ydArray = (NSMutableArray *)[NSArray arrayWithContentsOfFile:documentPath];

    
}



- (void)lod {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session setSecurityPolicy:[Manager customSecurityPolicy]];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"business_id":[[Manager sharedManager] redingwenjianming:@"business_id.text"],
           };
    NSString *str = [[Manager sharedManager] convertToJsonData:dic];
    NSString *jsonStr = [Manager encodeBase64String:str];
    NSString *tokenStr = [[Manager sharedManager] md5:[NSString stringWithFormat:@"%@%@",str,CHECKWORD]];
    NSDictionary *para = [[NSDictionary alloc]init];
    para = @{@"token":tokenStr,@"json":jsonStr};
    [session POST:KURLNSString(@"announce", @"getIndexAnnounce") parameters:para constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *array = [[dic objectForKey:@"rows"] objectForKey:@"annoList"];
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            GongGaoModel *model = [GongGaoModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArray addObject:model];            
        }
        
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView reloadData];
    }];
}



- (void)clickSearch{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GongGaoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    WebViewController *webview = [[WebViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webview];
    webview.webStr = model.ann_content;
    
    
    
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml",biaoji]];
    self.ydArray = (NSMutableArray *)[NSArray arrayWithContentsOfFile:documentPath];
    
    if (![self.dataArray containsObject:model.id]) {
        [self.ydArray addObject:model.id];
    }
    
    
    NSArray *array1 =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents1 = [array1 lastObject];
    NSString *documentPath1 = [documents1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml",biaoji]];
    [self.ydArray writeToFile:documentPath1 atomically:YES];
    
    
    
    
    webview.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
}

#pragma mark======UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60+height;
}
#pragma mark======UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WebTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GongGaoModel *model  = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.backgroundColor = RGBACOLOR(230, 236, 240, 1);
    
    
    cell.img1.contentMode = UIViewContentModeScaleAspectFit;
    cell.img2.contentMode = UIViewContentModeScaleAspectFit;
    
    
    cell.lab1.text = [NSString stringWithFormat:@"公告主题：%@",model.ann_theme];
    cell.lab1.numberOfLines = 0;
    cell.lab1.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.lab1 sizeThatFits:CGSizeMake(SCREEN_WIDTH-110, MAXFLOAT)];
    height = size.height;
    cell.lab1height.constant = height;
    cell.lab2.text = [NSString stringWithFormat:@"发布时间：%@",[Manager TimeCuoToTimes:model.createtime]];
    cell.img1top.constant = (height+50)/2-15;
    
    
    if ([self.ydArray containsObject:model.id] == YES) {
        cell.img2.hidden = YES;
        cell.img1.image = [UIImage imageNamed:@"yd"];
        cell.lab1.textColor = [UIColor grayColor];
    }else{
        cell.img2.hidden = NO;
        cell.img1.image = [UIImage imageNamed:@"gonggao"];
        cell.lab1.textColor = RGBACOLOR(16, 162, 158, 1);
    }
    return cell;
}

#pragma mark======标签设置
- (instancetype)init {
    if (self = [super init]) {
        [self setUpTabBarItem];
    }
    return self;
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"公告" image:[UIImage imageNamed:@"1"] selectedImage:[UIImage imageNamed:@"1"]];
    //tabBarItem.badgeValue = @"new";
    //tabBar自带渲染颜色，会将tabBarItem渲染成系统的蓝色，我们设置image的属性为原始状态即可；
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
//    tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
}




@end
