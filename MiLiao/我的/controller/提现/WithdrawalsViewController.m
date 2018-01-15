//
//  WithdrawalsViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "tiXainTableViewCell.h"
#import "headerView.h"
@interface WithdrawalsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"提现"];
    [self setTableView];

}
- (void)setTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"tiXainTableViewCell" bundle:nil] forCellReuseIdentifier:@"tiXainTableViewCell"];
    headerView *header = [[NSBundle mainBundle] loadNibNamed:
                       @"headerView" owner:nil options:nil ].lastObject;
    //block回调
    self.tableView.tableHeaderView = header;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    imageV.image = [UIImage imageNamed:@"组1"];
    [footView addSubview:imageV];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tiXainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tiXainTableViewCell"forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
    
}
@end
