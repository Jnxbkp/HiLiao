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
#import "IdentificationVController.h"
#import "RCDCustomerServiceViewController.h"
@interface MeViewController () {
    NSUserDefaults   *_userDefaults;
}
//退出按钮
@property(nonatomic,strong)UIButton *LogoutButton;
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
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
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];
    NSLog(@"wowowowowowowowo%@",[_userDefaults objectForKey:@"headUrl"]);
    self.nickName.text = [_userDefaults objectForKey:@"nickname"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //导航栏透明
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]forBarMetrics:UIBarMetricsDefault];
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_userDefaults objectForKey:@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];
    self.nickName.text = [_userDefaults objectForKey:@"nickname"];
    
    NSLog(@"%@^^^",[User ShardInstance].nickname);

}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return 0;
//    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            //我的钱包
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            MyMoneyViewController *money = [story instantiateViewControllerWithIdentifier:@"MyMoneyViewController"];
            //设置导航条颜色
            UINavigationController *nav = (UINavigationController *)self.navigationController;
            //隐藏分隔线
            [nav.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController pushViewController:money animated:YES];

        }
        if (indexPath.row == 2) {
            //大V
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
            IdentificationVController *Identification = [story instantiateViewControllerWithIdentifier:@"IdentificationVController"];
            //设置导航条颜色
            UINavigationController *nav = (UINavigationController *)self.navigationController;
            //隐藏分隔线
            [nav.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController pushViewController:Identification animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //客服
            RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
            chatService.userName = @"客服";
            chatService.conversationType = ConversationType_CUSTOMERSERVICE;
            chatService.targetId = @"KEFU151540013396895";
            chatService.title = chatService.userName;
            [self.navigationController pushViewController :chatService animated:YES];
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
    edttViewController *edit = [[edttViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}





@end
