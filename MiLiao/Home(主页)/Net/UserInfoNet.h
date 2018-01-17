//
//  UserInfoNet.h
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"

//#import <RongCallLib/RCCallSession.h>


typedef NS_ENUM(NSUInteger, MoneyEnoughType) {
    ///不充足
    MoneyEnoughTypeNotEnough,
    ///充足
    MoneyEnoughTypeEnough,
    ///账户余额为0
    MoneyEnoughTypeEmpty
};

///保存到后台的通话状态
typedef NS_ENUM(NSUInteger, SelfCallEndState) {
    ///通话异常结束
    SelfCallEndStateUnusual,
    ///完成
    SelfCallEndStateComplete,
    ///已取消
    SelfCallEndStateCancle,
    ///已拒绝
    SelfCallEndStateReject,
    ///未接听
    SelfCallEndStateNoAnswer,
    ///对方繁忙
    SelfCallEndStateRemoteBusy,
    ///对方取消
    SelfCallEndStateRemoteCancle,
    ///对方拒绝
    SelfCallEndStateRemoteReject,
    ///对方未接听
    SelfCallEndStateRemoteNoAnswer
    
};


//获取当前用户的token
NSString *tokenForCurrentUser(void);

///返回当前要保存到后台的通话状态
SelfCallEndState getSelfCallState(NSInteger callState);

@interface UserInfoNet : Networking


/**
获取用户的M币

 @param balance M币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance;

///判定余额足够消费
+ (void)canCall:(void(^)(RequestState success, MoneyEnoughType moneyType))complete;


/**
 每分钟扣费

 @param costUserId 对端的id
 */
+ (void)perMinuteDedectionUserName:(NSString *)userName result:(RequestModelResult)result;


///保存通话记录
+ (void)saveCallAnchorAccount:(NSString *)anchorAccount anchorId:(NSString *)anchorId callId:(NSString *)callId callTime:(NSString *)callTime callType:(NSInteger)callType remark:(NSString *)remark complete:(CompleteBlock)complete;

///获取评价标签
+ (void)getEvaluate:(RequestResult)result;


@end
