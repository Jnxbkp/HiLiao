//
//  MeViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "MeViewController.h"
#import "MyMoneyViewController.h"
#import "edttViewController.h"
@interface MeViewController () {
    NSUserDefaults   *_userDefaults;
}
//退出按钮
@property(nonatomic,strong)UIButton *LogoutButton;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //导航栏透明
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的钱包
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            MyMoneyViewController *money = [story instantiateViewControllerWithIdentifier:@"MyMoneyViewController"];
            //设置导航条颜色
            UINavigationController *nav = (UINavigationController *)self.navigationController;
            //隐藏分隔线
            [nav.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController pushViewController:money animated:YES];
        }
        if (indexPath.row == 1) {
            //大V
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //客服
            
        }
        if (indexPath.row == 1) {
            //帮助
            
        }
    }
    if (indexPath.section == 2) {
        //版本更新
    }
    if (indexPath.section == 3) {
        //退出登录
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [_userDefaults setObject:@"0" forKey:@"isBigV"];
        [_userDefaults setObject:@"no" forKey:@"isLog"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"isBigV",@"no",@"isLog", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
        NSLog(@"退出登录");
    }
}
//编辑资料
- (IBAction)edit:(id)sender {
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
//    editViewController *edit = [story instantiateViewControllerWithIdentifier:@"editViewController"];
//    [self.navigationController pushViewController:edit animated:YES];
    edttViewController *edit = [[edttViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}





@end
