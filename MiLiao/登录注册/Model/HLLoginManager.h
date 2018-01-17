//
//  HLLoginManager.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLoginManager : NSObject

//获取短信验证码
//GET /v1/user/getVerifyCode
+ (void)NetGetgetVerifyCodeMobile:(NSString *)mobile success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//oss-token获取
//GET /v1/oss/getOSSToken
+ (void)NetGetgetOSSToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//用户注册
//POST /v1/user/register
+ (void)NetPostRegisterMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//用户登录
//POST /v1/user/login
+ (void)NetPostLoginMobile:(NSString *)mobile password:(NSString *)password success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//重置密码
//POST /v1/user/resetpwd
+ (void)NetPostresetpwdMobile:(NSString *)mobile password:(NSString *)password msgId:(NSString *)msgId verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;

//快速登录
//POST /v1/user/quickLogin
+ (void)NetPostquickLoginName:(NSString *)name platform:(NSString *)platform token:(NSString *)platform uid:(NSString *)uid success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//更新头像昵称
//POST /v1/user/updateHeadUrl
+ (void)NetPostupdateHeadUrl:(NSString *)headUrl nickName:(NSString *)nickName token:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//POST /v1/bigV/saveBigV 认证大V
+ (void)NetPostupdateV:(NSString *)country province:(NSString *)province city:(NSString *)city constellation :(NSString *)constellation  description:(NSString *)description height:(NSString *)height nickName:(NSString *)nickName personalSign:(NSString *)personalSign personalTags :(NSString *)personalTags posters:(NSArray *)posters token:(NSString *)token weight :(NSString *)weight  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//获取用户信息
//GET /v1/user/getUserInfo
+ (void)NetGetgetUserInfoToken:(NSString *)token UserId:(NSString *)userId success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//获取通话记录
//POST /v1/call/getCallInfoList
+ (void)NetGetgetCallInfoListToken:(NSString *)token success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//提现信息申请
//POST /v1/wirthdraw/saveWirthdrawInfo
+ (void)saveWirthdrawInfoamount:(NSNumber *)amount bz:(NSString *)Token collectionAccount:(NSString *)collectionAccount mobile :(NSString *)mobile  userId:(NSString *)userId userName:(NSString *)userName success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
//保存用户账户提现信息
//POST /v1/user/saveUserWirthdrawInfo
+ (void)saveUserWirthdrawInfoverifyCode:(NSString *)verifyCode token:(NSString *)token account:(NSString *)account accountName :(NSString *)accountName  success:(void(^)(NSDictionary *info))success failure:(void(^)(NSError *error))failure;
@end
