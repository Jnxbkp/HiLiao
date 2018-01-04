//
//  AppDelegate.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//qwwewe
@property (strong, nonatomic) UIWindow *window;

- (AFHTTPSessionManager *)sharedHTTPSession;
//1
@end

