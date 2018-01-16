//
//  UserInfoNet.h
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"

typedef NS_ENUM(NSUInteger, MoneyEnoughType) {
    ///不充足
    MoneyEnoughTypeNotEnough,
    ///充足
    MoneyEnoughTypeEnough,
    ///账户余额为0
    MoneyEnoughTypeEmpty
};


//获取当前用户的token
NSString *tokenForCurrentUser(void);


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

 @param price 价格
 @param costUserId 对端的id
 */
+ (void)perMinuteDedectionCostCoin:(NSString *)price costUserId:(NSString *)costUserId ;
@end
