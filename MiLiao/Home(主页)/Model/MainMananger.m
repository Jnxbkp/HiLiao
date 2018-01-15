//
//  MainMananger.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MainMananger.h"

@implementation MainMananger
//推荐
//GET /v1/index/recommand/{pageNumber}/{pageSize}/{token}
//关注
//GET /v1/index/care/{pageNumber}/{pageSize}/{token}
//新人
//GET /v1/index/new/{pageNumber}/{pageSize}/{token}
+ (void)NetGetMainListKind:(NSString *)kind token:(NSString *)token pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    NSString *url = [NSString string];
    if ([kind isEqualToString:@"new"]) {
        url = [NSString stringWithFormat:@"%@/v1/index/new/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    } else if ([kind isEqualToString:@"care"]) {
        url = [NSString stringWithFormat:@"%@/v1/index/care/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    } else {
        url = [NSString stringWithFormat:@"%@/v1/index/recommand/%@/%@/%@",HLRequestUrl,pageNumber,pageSize,token];
    }
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取主播信息/搜索
//GET /v1/user/getAnchorInfo  获取主播信息    (    *传入userId时查询，nickname参数值无效*
+ (void)NetGetgetAnchorInfoNickName:(NSString *)nickname token:(NSString *)token userid:(NSString *)userid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
 
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"nickname"] = nickname;
    param[@"token"] = token;
    param[@"userid"] = userid;
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/getAnchorInfo",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
