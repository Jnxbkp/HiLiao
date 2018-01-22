//
//  CallPowerMoel.h
//  MiLiao
//
//  Created by King on 2018/1/22.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, MoneyEnoughType) {
    ///不充足
    MoneyEnoughTypeNotEnough,
    ///充足
    MoneyEnoughTypeEnough,
    ///账户余额为0
    MoneyEnoughTypeEmpty
};

/**
 通话能力
 */
@interface CallPowerMoel : NSObject
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *seconds;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) MoneyEnoughType typeCode;
@end
