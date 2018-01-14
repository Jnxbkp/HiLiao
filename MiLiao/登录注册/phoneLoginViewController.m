//
//  phoneLoginViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "phoneLoginViewController.h"
#import "registerViewController.h"
#import "forgetPassViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>
@interface phoneLoginViewController ()<UINavigationControllerDelegate>
{
    NSUserDefaults *_userDefaults;
}
@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *weiBo;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation phoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
//注册
- (IBAction)registe:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc]init];
//    [self presentViewController:registerVC animated:YES completion:^{
    
//    }];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//登录
- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];

    [HLLoginManager NetPostLoginMobile:self.phoneNum.text password:self.password.text success:^(NSDictionary *info) {
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
              NSLog(@"---------------->>%@",info);
            //保存用户信息
//            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];
            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",@"yes",@"isLog", nil];
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [_userDefaults setObject:@"yes" forKey:@"isLog"];
            NSString *token = info[@"data"][@"token"];
            [_userDefaults setObject:token forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"nickname"]] forKey:@"nickname"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"headUrl"]] forKey:@"headUrl"];
            [_userDefaults setObject:self.phoneNum.text forKey:@"phoneNum"];
            [_userDefaults setObject:self.password.text forKey:@"password"];

            [_userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            //融云登录操作
            [self settingRCIMToken:[[info objectForKey:@"data"] objectForKey:@"token"]];
        }
       
    } failure:^(NSError *error) {
        NSLog(@"----<<<>>>error%@",error);
    }];

}
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
    }if (sender == self.weiBo) {
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
}
//忘记密码
- (IBAction)forget:(id)sender {
    forgetPassViewController *forget = [[forgetPassViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}
//快速登录
- (void)quickLogInname:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid {
    [HLLoginManager NetPostquickLoginName:name platform:platform token:token uid:uid success:^(NSDictionary *info) {
        //                    NSLog(@"------>>%@",info);
        NSString *resultCode = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
        if ([resultCode isEqualToString:@"200"]) {
            //保存用户信息
//            [YZCurrentUserModel userInfoWithDictionary:info[@"data"]];

            NSString *isBigV = [NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"isBigv"]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:isBigV,@"isBigV",@"yes",@"isLog", nil];
            [_userDefaults setObject:isBigV forKey:@"isBigV"];
            [_userDefaults setObject:@"yes" forKey:@"isLog"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"token"]] forKey:@"token"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"nickname"]] forKey:@"nickname"];
            [_userDefaults setObject:[NSString stringWithFormat:@"%@",[[info objectForKey:@"data"] objectForKey:@"headUrl"]] forKey:@"headUrl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:dic];
            
            //融云登录操作
            [self settingRCIMToken:[[info objectForKey:@"data"] objectForKey:@"token"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
// [_userDefaults objectForKey:@"token"]
- (void)settingRCIMToken:(NSString *)token {
    if (!token) return;
    [HLLoginManager  NetGetupdateRongYunToken:token success:^(NSDictionary *info) {
        
         NSLog(@"获取融云token!!!!!!：%@", info);
        [_userDefaults setObject:info[@"data"][@"RongYunToken"][@"token"] forKey:@"rcim_token"];

//        [[NSUserDefaults standardUserDefaults] setObject:info[@"data"][@"RongYunToken"] [@"token"]forKey:@"rcim_token"];
        [[RCIM sharedRCIM] connectWithToken:[_userDefaults objectForKey:@"rcim_token"] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            //把自己信息存起来
            [self RCIM_currentUserInfo:userId];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    } failure:^(NSError *error) {
        
    }];
}
- (void)RCIM_currentUserInfo:(NSString *)userId {
    //自己的信息
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                  name:[_userDefaults objectForKey:@"nickname"]
                              portrait:[_userDefaults objectForKey:@"headUrl"]];
    [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
}
@end
