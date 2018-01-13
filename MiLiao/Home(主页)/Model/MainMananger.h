//
//  MainMananger.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainMananger : NSObject
//推荐
//GET /v1/index/recommand/{pageNumber}/{pageSize}/{token}
//关注
//GET /v1/index/care/{pageNumber}/{pageSize}/{token}
//新人
//GET /v1/index/new/{pageNumber}/{pageSize}/{token}
+ (void)NetGetMainListKind:(NSString *)kind token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;


@end
