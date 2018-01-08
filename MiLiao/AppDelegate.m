//
//  AppDelegate.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MLTabBarController.h"
#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>
@interface AppDelegate () {
    NSUserDefaults *_userDefaults;
}

@end

@implementation AppDelegate

//test
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *isLog = [_userDefaults stringForKey:@"isLog"];
    if ([isLog isEqualToString:@"yes"]) {
        self.window.rootViewController = [[MLTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:@"KSwitchRootViewControllerNotification" object:nil];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    //融云
    [[RCIM sharedRCIM] initWithAppKey:@"mgb7ka1nmwthg"];//8brlm7uf8djg3(release)    8luwapkv8rtcl(debug)
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [self settingRCIMToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    return YES;
}

// [_userDefaults objectForKey:@"token"]
- (void)settingRCIMToken:(NSString *)token {
    if (!token) return;
    [HLLoginManager  NetGetupdateRongYunToken:token success:^(NSDictionary *info) {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:info[@"data"][@"RongYunToken"] forKey:@"rcim_token"];
        [[RCIM sharedRCIM] connectWithToken:info[@"data"][@"RongYunToken"] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
            //把自己信息存起来
            //            [[UserDataManager ShardInstance] RCIM_currentUserInfo:userId];
            
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

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaWeiboAppKey  appSecret:SinaWeiboSecret redirectURL:@"https://www.baidu.com"];
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    UIViewController *topmostVC = [self topViewController];
    if ([topmostVC isKindOfClass:[ViewController class]]) {
        ViewController *VC = topmostVC;
        [VC resumeCapturePreview];
    } else {
        
    }
//    [self switchRootViewController:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UIViewController *topmostVC = [self topViewController];
    if ([topmostVC isKindOfClass:[ViewController class]]) {
        ViewController *VC = topmostVC;
        [VC clear];
    } else {
        
    }
}
//AFNetWorking leaks
static AFHTTPSessionManager *manager ;
- (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10;
        
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [security setValidatesDomainName:NO];
        security.allowInvalidCertificates = YES;
        manager.securityPolicy = security;
        
    });
        return manager;
}
//获取最上层VC
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
//选择bar
- (void)switchRootViewController:(NSNotification *)note {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isBigV = [userDefaults objectForKey:@"isBigV"];
    NSString *isLog = [userDefaults objectForKey:@"isLog"];
  
    if ([isLog isEqualToString:@"yes"]) {
        MLTabBarController *tabBarVC = [[MLTabBarController alloc] init];
        tabBarVC.selectedViewController = [tabBarVC.viewControllers objectAtIndex:0];
        self.window.rootViewController = tabBarVC;
    } else {
        self.window.rootViewController = [[LoginViewController alloc]init];
        
    }
    
}
@end
