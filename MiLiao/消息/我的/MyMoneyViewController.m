//
//  MyMoneyViewController.m
//  MChat
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "UIImage+Common.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
@interface MyMoneyViewController ()<UINavigationControllerDelegate>

@end

@implementation MyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:RGBA(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.title = @"我的钱包";


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBA(48,59,76,1)] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
@end
