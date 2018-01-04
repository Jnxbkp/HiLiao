//
//  LoginViewController.m
//  MChat
//
//  Created by apple on 2017/12/29.
//  Copyright © 2017年 Zc. All rights reserved.
//

#import "LoginViewController.h"
#import "phoneLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *WeiBo;
@property (strong, nonatomic) IBOutlet UIButton *phoneNumber;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillDisappear:animated];
//}
//三方登录
- (IBAction)thirdLog:(UIButton *)sender {
    if (sender == self.weChat) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat unionid: %@", resp.unionId);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.unionGender);
                
                 [self quickLogInname:resp.name platform:@"WECHAT" token:resp.accessToken uid:resp.uid];
            }
        }];
    }
    if (sender == self.QQ) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"QQ uid: %@", resp.uid);
                NSLog(@"QQ openid: %@", resp.openid);
                NSLog(@"QQ unionid: %@", resp.unionId);
                NSLog(@"QQ accessToken: %@", resp.accessToken);
                NSLog(@"QQ expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"QQ name: %@", resp.name);
                NSLog(@"QQ iconurl: %@", resp.iconurl);
                NSLog(@"QQ gender: %@", resp.unionGender);
                
                [self quickLogInname:resp.name platform:@"QQ" token:resp.accessToken uid:resp.uid];
            
            }
        }];
    }
    if (sender == self.WeiBo) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                // 授权信息
                NSLog(@"Sina uid: %@", resp.uid);
                NSLog(@"Sina accessToken: %@", resp.accessToken);
                NSLog(@"Sina refreshToken: %@", resp.refreshToken);
                NSLog(@"Sina expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Sina name: %@", resp.name);
                NSLog(@"Sina iconurl: %@", resp.iconurl);
                NSLog(@"Sina gender: %@", resp.unionGender);
                [self quickLogInname:resp.name platform:@"SINA" token:resp.accessToken uid:resp.uid];
                
            }
        }];
    }
    if (sender == self.phoneNumber) {
//        phoneLoginViewController *phVC = [[phoneLoginViewController alloc]init];
//        [self presentViewController:phVC animated:YES completion:^{
//
//        }];
        phoneLoginViewController*bvc = [[phoneLoginViewController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bvc];
        
        [self presentViewController:nav animated:NO completion:^{
            
            
            
        }];
    }
}
//快速登录
- (void)quickLogInname:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid {
    [HLLoginManager NetPostquickLoginName:name platform:platform token:token uid:uid success:^(NSDictionary *info) {
        //                    NSLog(@"------>>%@",info);
        NSString *resultCode = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
        if ([resultCode isEqualToString:@"200"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:nil];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}



@end
