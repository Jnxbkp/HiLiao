//
//  messageViewController.m
//  MChat
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "messageViewController.h"
#import "messageCell.h"
@interface messageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView * tableView;

@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"消息"];
    [self setTableview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)setTableview
{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -30, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ML_Color(230, 230, 230, 1);
    self.tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"messageCell" bundle:nil] forCellReuseIdentifier:@"messageCell"];
    
    [self.view addSubview:tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}
//头部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *Identifier =@"messageCell";
    messageCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (indexPath.row == 0) {
        cell.image.backgroundColor = [UIColor blueColor];
        cell.title.text = @"我的通话";
    }
    if (indexPath.row == 1) {
        cell.image.backgroundColor = [UIColor redColor];
        cell.title.text = @"我的M币";
        
    }
    if (indexPath.row == 2) {
        cell.image.backgroundColor = [UIColor blackColor];
        cell.title.text = @"系统通知";
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64;
}
@end
