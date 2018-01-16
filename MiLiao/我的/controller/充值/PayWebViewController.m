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

#import <AlipaySDK/AlipaySDK.h>

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
    NSURL * url = [NSURL URLWithString:@"https://47.104.25.213:9000/payment/index?token=dc3b9456f8f7772e145027e95fdd099b&username=15662696090&totalFee=1"];
    [NSURLRequest allowsAnyHTTPSCertificateForHost:@"https"];
    _originRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:_originRequest];
    [self.view addSubview:self.webView];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    // NOTE: ------  对alipays:相关的scheme处理 -------
//    // NOTE: 若遇到支付宝相关scheme，则跳转到本地支付宝App
//    NSString* reqUrl = request.URL.absoluteString;
//    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
//        // NOTE: 跳转支付宝App
//        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
//
//        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
//        if (!bSucc) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                           message:@"未检测到支付宝客户端，请安装后重试。"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"立即安装"
//                                                 otherButtonTitles:nil];
//            [alert show];
//        }
//        return NO;
//    }
//    return YES;
    
  
    
//}

@end
