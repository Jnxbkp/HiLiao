//
//  UserInfoNet.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "UserInfoNet.h"

///获取用户信息的api
static NSString *GetUserInfo = @"/v1/user/getUserInfo";

//每分钟扣费
static NSString *EveryMinuAPI = @"/v1/cost/minuteCost";


//获取当前用户的token
NSString *tokenForCurrentUser() {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"token"];
}

@implementation UserInfoNet

/**
 获取用户的M币
 
 @param balance M币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    
    NSDictionary *parameter = @{@"token":token,
                                @"userId":@"0"
                                };
    
    [self Get:GetUserInfo parameters:parameter result:^(RequestState success, NSDictionary *dict, NSString *errMsg) {
        if (success) {
            !balance?:balance([dict[@"balance"] floatValue]);
        }
    }];
}

+ (void)perMinuteDedectionCostCoin:(NSString *)price costUserId:(NSString *)costUserId {
    NSDictionary *parameters = @{@"costCoin":price,
                                 @"costUserId":costUserId,
                                 @"token":tokenForCurrentUser(),
                                 @"userId":@"48"
                                 };
    [self Post:EveryMinuAPI parameters:parameters complete:^(RequestState success, NSString *msg) {
        
    }];
}

@end
