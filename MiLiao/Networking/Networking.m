//
//  Networking.m
//  MiLiao
//
//  Created by King on 2018/1/13.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "Networking.h"



@implementation Networking



+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(Class)modelClass result:(RequestResult)result {
    [self POST:urtString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState success;
        NSArray *modelArray;
        if ([responseObject isKindOfClass:[NSDictionary class]]
            &&
            [responseObject[@"success"] integerValue] == SUCCESS
            &&
            [responseObject[@"data"] isKindOfClass:[NSArray class]])
        {
            
            if (modelClass) modelArray = [modelClass mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            success = Success;
        } else {
            success = Failure;
        }
        !result?:result(success, modelArray,[responseObject[@"err_cd"] integerValue], responseObject[@"err_msg"]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !result?:result(Failure, nil, 0, @"网络连接失败,请稍后再试");
    }];
}




+ (void)Post:(NSString *)urtString parameters:(id)parameters modelClass:(NSString *)modelClass modelResult:(RequestModelResult)modelResult
{
    [self POST:urtString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        RequestState success;
        id model;
        
        if ([responseObject isKindOfClass:[NSDictionary class]]
            &&
            [responseObject[@"success"] integerValue] == SUCCESS)
        {
            if (modelClass) model = [NSClassFromString(modelClass) mj_objectWithKeyValues:responseObject[@"data"]];
            success = Success;
        }
        else
        {
            success = Failure;
        }
        !modelResult?:modelResult(success, model,[responseObject[@"err_cd"] integerValue], responseObject[@"err_msg"]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !modelResult?:modelResult(Failure, nil, 0, @"网络连接失败,请稍后再试");
    }];
}




+ (void)Post:(NSString *)urlString parameters:(id)parameters complete:(CompleteBlock)complete {
    [self POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            RequestState state = [responseObject[@"success"] integerValue];
            NSString *msg = responseObject[@"err_msg"];
            !complete?:complete(state, msg);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !complete?:complete(Failure, @"网络连接失败,请稍后再试");
    }];
}

@end
