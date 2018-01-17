//
//  NotificationName.h
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#ifndef NotificationName_h
#define NotificationName_h


#define PostNotificationNameUserInfo(_notificationName_, _userInfo_)  [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName_ object:nil userInfo:_userInfo_];                                    

#define ListenNotificationName_Func(_notificationName_, _Func_) [[NSNotificationCenter defaultCenter] addObserver:self selector:_Func_ name:_notificationName_ object:nil];

#define VideoCallEnd @"VideoCallEnd"

#endif /* NotificationName_h */
