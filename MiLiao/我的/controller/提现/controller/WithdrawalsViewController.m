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
#import "CashMingXiViewController.h"
#import "administrateAccountViewController.h"
@interface WithdrawalsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSNumber * amount;

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:ML_Color(255, 255, 255, 1)};

    self.title = @"提现";
    [self setTableView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:ML_Color(250,114,152,1)] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavigationBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    
    
}
- (void)setTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = ML_Color(241, 241, 241, 1);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"tiXainTableViewCell" bundle:nil] forCellReuseIdentifier:@"tiXainTableViewCell"];
    headerView *header = [[NSBundle mainBundle] loadNibNamed:
                       @"headerView" owner:nil options:nil ].lastObject;
    //block回调
    header.sureBlock = ^{
        //确定按钮
        __weak typeof(self) weakSelf = self;
        [weakSelf tiXianLoad];
        
    };
    header.mingxiBlock = ^{
        //查看明细
        [self.view endEditing:YES];
        CashMingXiViewController *cashVC = [[CashMingXiViewController alloc]init];
        [self.navigationController pushViewController:cashVC animated:YES];
    };
    header.textFiledClick = ^(NSString *str) {
        //输入金额
        self.amount = @([str integerValue]);
        NSLog(@"输入的提现金额是:%@",self.amount);
    };
    self.tableView.tableHeaderView = header;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.637)];
    imageV.image = [UIImage imageNamed:@"组1"];
    [footView addSubview:imageV];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];

}
- (void)tiXianLoad
{
    [self.view endEditing:YES];

    
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
    __weak typeof(self) weakSelf = self;

    tiXainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tiXainTableViewCell"forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sureBlock = ^{
        //管理提现账户
        administrateAccountViewController *account = [[administrateAccountViewController alloc]init];
        [weakSelf.navigationController pushViewController:account animated:YES];
    };

    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
