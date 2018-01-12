//
//  AppDelegate+SetupBeauty.m
//  MiLiao
//
//  Created by King on 2018/1/10.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "AppDelegate+SetupBeauty.h"
//#import "FURenderer.h"

#import "FUVideoFrameObserverManager.h"


@implementation AppDelegate (SetupBeauty)

- (void)setupBeauty {
    
    [FUVideoFrameObserverManager registerVideoFrameObserver];
    
}


@end
