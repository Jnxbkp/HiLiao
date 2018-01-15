//
//  UserInfoNet.h
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"

@interface UserInfoNet : Networking


/**
获取用户的M币

 @param balance M币
 */
+ (void)getUserBalance:(void(^)(CGFloat balance))balance;


+ (void)perMinuteDedectionCostCoin:(CGFloat)price costUserId:(NSString *)costUserId ;
@end
