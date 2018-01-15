//
//  MyMoneyViewController.m
//  MChat
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "UIImage+Common.h"
#import "GoPayTableViewController.h"
#import "WithdrawalsViewController.h"

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
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"我的钱包"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //充值
            GoPayTableViewController *goPayVC  = [[GoPayTableViewController alloc]init];
            [self.navigationController pushViewController:goPayVC animated:YES];
        }
        if (indexPath.row == 1) {
            //提现
            WithdrawalsViewController  * WithdrawalsVC = [[WithdrawalsViewController alloc]init];
            [self.navigationController pushViewController:WithdrawalsVC animated:YES];

        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //收入明细
        }
        if (indexPath.row == 1) {
            //支出明细
        }
        if (indexPath.row == 2) {
            //提现明细
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }
    if (section == 1) {
        return 8;
    }
    return 0.01;
}
@end
