//
//  PayWebViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PayWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface PayWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView * webView;

@end

@implementation PayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"支付"];
    self.view.backgroundColor = ML_Color(248, 248, 248, 1);
    [self wwebview];

}
- (void)wwebview
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - ML_TopHeight)];
    self.webView.delegate = self;
    NSURL * url = [NSURL URLWithString:@"https://47.104.25.213:9000/payment/index?token=9b6c12ec5754705b85030235861c2d6c&username=15662696090&totalFee=10"];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}




@end
