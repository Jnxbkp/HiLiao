//
//  PayWebViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PayWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"
@interface PayWebViewController ()<UIWebViewDelegate,NSURLSessionDelegate>
{
    NSURLRequest*_originRequest;
    
    NSURLConnection*_urlConnection;
    
    BOOL _authenticated;
}
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, strong)NSURL * url;

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
    NSString *urlStr = [NSString stringWithFormat:@"https://47.104.25.213:9000/payment/index?token=%@&username=%@&totalFee=%@",[YZCurrentUserModel sharedYZCurrentUserModel].token,[YZCurrentUserModel sharedYZCurrentUserModel].username,self.money];
    NSLog(@"支付宝连接~~~~~~~~~%@",urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];
    [NSURLRequest allowsAnyHTTPSCertificateForHost:@"https"];
    _originRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:_originRequest];
    [self.view addSubview:self.webView];
}

@end
