//
//  MessageeViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MessageeViewController.h"
#import "messageCell.h"
#import "ChatRoomController.h"

@interface MessageeViewController ()<RCIMUserInfoDataSource>

@end

@implementation MessageeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"消息"];
    // Do any additional setup after loading the view.
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    //设置需要显示哪些类型的会话
    
    
   
}






@end
