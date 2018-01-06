//
//  HLLoginManager.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLLoginManager.h"

@implementation HLLoginManager
//获取短信验证码
//GET /v1/user/getVerifyCode
+ (void)NetGetgetVerifyCodeMobile:(NSString *)mobile success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
        //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    //设置返回StatusCodes422为成功标志
//    NSMutableIndexSet *indexSet=[[NSMutableIndexSet alloc] initWithIndexSet:manager.responseSerializer.acceptableStatusCodes];
//
//    [indexSet addIndex:422];
//    manager.responseSerializer.acceptableStatusCodes=indexSet;
    
    [manager GET:[NSString stringWithFormat:@"%@/v1/user/getVerifyCode?mobile=%@",HLRequestUrl,mobile] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
   
}
//oss-token获取
//GET /v1/oss/getOSSToken
+ (void)NetGetgetOSSToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager GET:[NSString stringWithFormat:@"%@/v1/oss/getOSSToken?token=%@",HLRequestUrl,token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//用户注册
//POST /v1/user/register
+ (void)NetPostRegisterMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"msgId"] = msgId;
    param[@"verifyCode"] = verifyCode;
    param[@"password"] = password;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/register",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//用户登录
//POST /v1/user/login
+ (void)NetPostLoginMobile:(NSString *)mobile password:(NSString *)password success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"password"] = password;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/login",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//重置密码
//POST /v1/user/resetpwd
+ (void)NetPostresetpwdMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = mobile;
    param[@"msgId"] = msgId;
    param[@"verifyCode"] = verifyCode;
    param[@"password"] = password;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/resetpwd",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//快速登录
//POST /v1/user/quickLogin
+ (void)NetPostquickLoginName:(NSString *)name platform:(NSString *)platform token:(NSString *)token uid:(NSString *)uid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"name"] = name;
    param[@"platform"] = platform;
    param[@"token"] = token;
    param[@"uid"] = uid;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/quickLogin",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//更新头像昵称
//POST   /v1/user/updateHeadUrl
+ (void)NetPostupdateHeadUrl:(NSString *)headUrl nickName:(NSString *)nickName token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [app sharedHTTPSession];
    
    //设置请求头
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"nickName"] = nickName;
    param[@"headUrl"] = headUrl;
    param[@"token"] = token;
    [manager POST:[NSString stringWithFormat:@"%@/v1/user/updateHeadUrl",HLRequestUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
