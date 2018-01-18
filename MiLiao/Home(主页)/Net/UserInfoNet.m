//
//  UserInfoNet.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "UserInfoNet.h"

/////////API
///获取用户信息的api
static NSString *GetUserInfo = @"/v1/user/getUserInfo";

static NSString *CanCallEnoughAPI = @"/v1/cost/enoughCall";

//每分钟扣费
static NSString *EveryMinuAPI = @"/v1/cost/minuteCost";
///保存通话记录
static NSString *SaveCall = @"/v1/call/saveUserCall";

///获取评价标签
static NSString *GetEvaluate = @"/v1/dict/getTags";
///最终扣费
static NSString *FinalDeduct = @"/v1/cost/overCost";
///评价标签模型
static NSString *EvaluateTagModel = @"EvaluateTagModel";

///保存对大V的评价
static NSString *SaveEvaluate = @"/v1/bigV/saveBigVEvaluation";


/////////类名
static NSString *UserCallPowerModelClass = @"UserCallPowerModel";


//获取当前用户的token
NSString *tokenForCurrentUser() {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"token"];
}

///返回当前要保存到后台的通话状态
/*callState 由融云返回，具体字段请参考RongCallLib/RCCallSession.h下的disconnectReason属性
 */
SelfCallEndState getSelfCallState(NSInteger callState) {
    switch (callState) {
        case 0:
            return 100;
        case 1:
            return SelfCallEndStateCancle;
        case 2:
            return SelfCallEndStateUnusual;
        case 3:
            return SelfCallEndStateCancle;
        case 4:
            return SelfCallEndStateUnusual;
        case 5:
            return SelfCallEndStateNoAnswer;
        case 6:
//            return SelfCallEndStateUnusual;
        case 7:
            return SelfCallEndStateUnusual;
//        case 8:
//            return
//        case 9:
//            return
//        case 10:
//            return
        case 11:
            return SelfCallEndStateRemoteCancle;
        case 12:
            return SelfCallEndStateRemoteCancle;
        case 13:
            return SelfCallEndStateRemoteNoAnswer;
        case 14:
            return SelfCallEndStateRemoteNoAnswer;
        case 15:
            return SelfCallEndStateRemoteNoAnswer;
        case 16:
            return SelfCallEndStateUnusual;
//        case 17:
//            return
//        case 18:
//            return
        
        default:
            return SelfCallEndStateUnusual;
    }
}

@implementation UserInfoNet

/**
 获取用户的M币
 
 @param balance M币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance {
    
    NSString *token = tokenForCurrentUser();
    NSString *userName = [YZCurrentUserModel sharedYZCurrentUserModel].username;
    
    NSDictionary *parameter = @{@"token":token,
                                @"userName":userName
                                };
    
    [self Get:GetUserInfo parameters:parameter result:^(RequestState success, NSDictionary *dict, NSString *errMsg) {
        if (success) {
            !balance?:balance([dict[@"balance"] floatValue]);
        }
    }];
}

///判定余额足够消费
+ (void)canCall:(void(^)(RequestState success, MoneyEnoughType moneyType))complete {
    NSDictionary *parameters = @{@"token":tokenForCurrentUser(),
                                 @"userName":[YZCurrentUserModel sharedYZCurrentUserModel].username
                                 };
    [self Get:CanCallEnoughAPI parameters:parameters result:^(RequestState success, NSDictionary *dict, NSString *errMsg) {
        RequestState state = Failure;
        if (success) {
            MoneyEnoughType type = [dict[@"typeCode"] integerValue];
            !complete?:complete(Success, type);
        } else {
            !complete?:complete(Failure, 100);
        }
        
    }];
   
    
}

/**
 分钟扣费
 
 @param userName 发起通话的用户名
 @param costUserName 大V的用户名
 @param pid pid
 @param result 返回
 */
+ (void)perMinuteDedectionUserName:(NSString *)userName costUserName:(NSString *)costUserName pid:(NSString *)pid result:(RequestModelResult)result {
   ;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"costUserName"] = costUserName;
    parameter[@"token"] = tokenForCurrentUser();
    parameter[@"userName"] = userName;
    if (pid || pid.length < 1) {
        parameter[@"pid"] = @"0";
    } else {
        parameter[@"pid"] = pid;
    }
    NSLog(@"\n\n\n执行扣费接口的pid:%@", pid);
    
    [self Post:EveryMinuAPI parameters:parameter modelClass:NSClassFromString(UserCallPowerModelClass) modelResult:result];
    
}

///保存通话记录
+ (void)saveCallAnchorAccount:(NSString *)anchorAccount anchorId:(NSString *)anchorId callId:(NSString *)callId callTime:(NSString *)callTime callType:(NSInteger)callType remark:(NSString *)remark complete:(CompleteBlock)complete {
    
    YZCurrentUserModel *user = [YZCurrentUserModel sharedYZCurrentUserModel];
    NSDictionary *parameters = @{@"anchorAccount":anchorAccount,
                                 @"anchorId":anchorId,
                                 @"callId":callId,
                                 @"callTime":callTime,
                                 @"callType":@(callType),
                                 @"remark":remark,
                                 @"token":tokenForCurrentUser(),
                                 @"userAccount":user.username,
                                 @"userId":user.user_id
                                 };
    [self Post:SaveCall parameters:parameters complete:complete];
    
}

/**
 视频通话的最终扣费
 
 @param callTime 通话时间
 @param costUserName 对端用户名
 @param pid pid
 @param result 返回的结果
 */
+ (void)finalDeductMoneyCallTime:(NSString *)callTime costUserName:(NSString *)costUserName pid:(NSString *)pid result:(RequestModelResult)result {
    
    NSDictionary *parameters = @{
                                 @"callTime":callTime,
                                 @"costUserName":costUserName,
                                 @"pid":pid,
                                 @"token":tokenForCurrentUser(),
                                 @"userName":[YZCurrentUserModel sharedYZCurrentUserModel].username
                                 };
    [self Post:FinalDeduct parameters:parameters modelClass:nil modelResult:result];
}

///获取评价标签
+ (void)getEvaluate:(RequestResult)result {
    [self Get:GetEvaluate parameters:@{@"token":tokenForCurrentUser()} modelClass:NSClassFromString(EvaluateTagModel) result:result];
}


/**
 保存对大V的评价
 
 @param anchorName 大V的用户名
 @param callId 通话id
 @param score 评级 星星的个数
 @param tags 标签id数组
 @param complete 完成
 */
+ (void)saveEvaluateAnchorName:(NSString *)anchorName callId:(NSString *)callId score:(NSString *)score tags:(NSArray *)tags complete:(CompleteBlock)complete {
    NSDictionary *parameters = @{
                                 @"anchorName":anchorName,
                                 @"callId":callId,
                                 @"score":score,
                                 @"tags":tags,
                                 @"token":tokenForCurrentUser(),
                                 @"userName":[YZCurrentUserModel sharedYZCurrentUserModel].username
                                 };
    [self Post:SaveEvaluate parameters:parameters complete:complete];
}


@end
