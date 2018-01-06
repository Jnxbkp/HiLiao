//
//  UZCurrentUserModel.h
//  fangchan
//
//  Created by cuibin on 16/3/31.
//  Copyright © 2016年 youzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface YZCurrentUserModel : NSObject

/**商家id*/
@property (nonatomic, copy) NSString * userid;

@property (nonatomic, copy) NSString * id;

/**用户名*/
@property (nonatomic, strong) NSString      * username;
@property (nonatomic, strong) NSString      * balance;
@property (nonatomic, strong) NSString      * user_id;
@property (nonatomic, strong) NSString      * isBigv;
@property (nonatomic, strong) NSString      * nickname;
@property (nonatomic, strong) NSString      * height;
@property (nonatomic, strong) NSString      * isAgent;
@property (nonatomic, strong) NSString      * loginType;
@property (nonatomic, strong) NSString      * token;
@property (nonatomic, strong) NSString      * weight;
@property (nonatomic, strong) NSString      * headUrl;
singleton_h(YZCurrentUserModel)

- (instancetype)initWithDictionary:(NSDictionary *)d;

+ (instancetype)userInfoWithDictionary:(NSDictionary *)d;

- (void)cleanUserData;

@end
