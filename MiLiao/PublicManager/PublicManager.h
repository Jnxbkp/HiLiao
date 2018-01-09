//
//  PublicManager.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicManager : NSObject

//video-sts-token获取
// GET /v1/oss/getOSSVideoToken
+ (void)NetGetgetOSSVideoToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

@end
