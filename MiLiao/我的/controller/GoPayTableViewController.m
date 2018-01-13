//
//  GoPayTableViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "GoPayTableViewController.h"
#import <Masonry.h>
#import "MyQianBaoTableViewCell.h"
#import "jiaYouYZBankTableViewCell.h"//支付方式新

@interface GoPayTableViewController ()
@property(nonatomic,assign)BOOL boolBtnSelected;

@end

@implementation GoPayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"充值"];
    [self registerCell];

}

- (void)registerCell {
    //选择金额
    [self.tableView registerNib:[UINib nibWithNibName:@"MyQianBaoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyQianBaoTableViewCell"];
    //支付方式
    [self.tableView registerNib:[UINib nibWithNibName:@"jiaYouYZBankTableViewCell" bundle:nil] forCellReuseIdentifier:@"jiaYouYZBankTableViewCell"];
}




@end
