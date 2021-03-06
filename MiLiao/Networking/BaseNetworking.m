//
//  BaseNetworking.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BaseNetworking.h"



@implementation BaseNetworking

/**
 POST - 基类请求请求
 
 @param urlString url
 @param parameters 参数
 @param success 成功
 @param failure 失败
 */
+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kAPIURLBaseURL,urlString]);
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIURLBaseURL,urlString];
    NSLog(@"\n\n请求参数parameter\n:%@\n\n", [parameters mj_JSONString]);
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n\n接口：%@\n\n", urlString);
        NSLog(@"\n\n\n网络返回responseObject:\n\n%@\n\n",responseObject);
        if (success) {
            
            NSString *errMsg = responseObject[@"err_msg"];
            errMsg = [errMsg stringByRemovingPercentEncoding];
            if (errMsg.length > 1) NSLog(@"\n=====================================================\n 网络返回信息err_msg:%@\n", errMsg);
            success(task, responseObject);
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
        NSLog(@"\n\n接口：%@\n\n", urlString);
    NSLog(@"\n=====================================================\n\n=====================================================\n\n=====================================================\n网络返回失败:%@", error.userInfo);
        NSLog(@"%@", task);
    }];
}


/**
 上传的post请求
 
 @param urlString 上传的url
 @param parameters 参数
 @param data 数据流
 @param typeName 类型名字 (与后台约定)
 @param fileName 文件名字
 @param fileType 文件类型 ((图片image/jpeg, 音频amr/mp3/wmr))
 @param success 成功
 @param failure 失败
 */
+ (void)Upload:(NSString *)urlString
     parameter:(id)parameters
          data:(NSData *)data
     typeyName:(NSString *)typeName
      fileName:(NSString *)fileName
      fileType:(NSString *)fileType
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@", kUPLOADBaseURL, urlString];
    NSLog(@"uploadURL:%@", uploadUrl);
    [manager POST:uploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (data) {
            [formData appendPartWithFileData:data name:typeName fileName:fileName mimeType:fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n==================================================");
        NSLog(@"ResponseObject:%@\n", responseObject);
        NSLog(@"======================================================");
        !success?:success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Upload error:%@", error.userInfo);
        !failure?:failure(task, error);
    }];
    
}


+ (void)GET:(NSString *)urlString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    NSLog(@"接口地址:%@",[NSString stringWithFormat:@"%@%@",kAPIURLBaseURL,urlString]);
    
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;
    
    [manager GET:[NSString stringWithFormat:@"%@%@",kAPIURLBaseURL,urlString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"接口地址:%@", [NSString stringWithFormat:@"%@%@",kAPIURLBaseURL,urlString]);
        NSLog(@"\n\nGET基类请求返回:\n%@", responseObject);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}





@end
