//
//  VideoCallViewController.m
//  MiLiao
//
//  Created by King on 2018/1/10.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoCallViewController.h"

#import <RongCallLib/RCCallClient.h>

#import "FUManager.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>

#import "FUVideoFrameObserverManager.h"


@interface VideoCallViewController ()<RCCallReceiveDelegate, FUAPIDemoBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FUAPIDemoBar *bar;
///控件容器数组
@property (nonatomic, strong) NSArray *controlContainerArray;

///是否关闭相关控件
@property (nonatomic, assign, getter=isCloseControl) BOOL closeControl;
///是否展示底部的bar
@property (nonatomic, assign, getter=isShowBar) BOOL showBar;
@end

@implementation VideoCallViewController


#pragma mark - getter
- (NSArray *)controlContainerArray {
    if (!_controlContainerArray) {
        NSMutableArray *array = [NSMutableArray array];
        //挂断的button
        [array addObject:self.hangupButton];
        //切换前后摄像头
        [array addObject:self.cameraSwitchButton];
        //静音
        [array addObject:self.muteButton];
        _controlContainerArray = [array copy];
    }
    return _controlContainerArray;
}


/**
 Faceunity道具美颜工具条
 初始化 FUAPIDemoBar，设置初始美颜参数
 
 @param bar 
 */
-(FUAPIDemoBar *)bar {
    if (!_bar ) {
        _bar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 208)];
        
        _bar.itemsDataSource =  [FUManager shareManager].itemsDataSource;
        _bar.filtersDataSource = [FUManager shareManager].filtersDataSource;
        
        _bar.selectedItem = [FUManager shareManager].selectedItem;
        _bar.selectedFilter = [FUManager shareManager].selectedFilter;
        _bar.selectedBlur = [FUManager shareManager].selectedBlur;
        _bar.beautyLevel = [FUManager shareManager].beautyLevel;
        _bar.thinningLevel = [FUManager shareManager].thinningLevel;
        _bar.enlargingLevel = [FUManager shareManager].enlargingLevel;
        _bar.faceShapeLevel = [FUManager shareManager].faceShapeLevel;
        _bar.faceShape = [FUManager shareManager].faceShape;
        _bar.redLevel = [FUManager shareManager].redLevel;
        _bar.delegate = self;
        
        
    }
    return _bar ;
}

#pragma mark - setter
- (void)setCloseControl:(BOOL)closeControl {
    _closeControl = closeControl;
    //显示或隐藏相关控件
    for (UIView *view in self.controlContainerArray) {
        view.hidden = closeControl;
    }
}


///显示或隐藏底部的美颜bar
- (void)setShowBar:(BOOL)showBar {
    _showBar = showBar;
    self.bar.hidden = !showBar;
}


- (void)demoBarDidSelectedItem:(NSString *)item {
    [[FUManager shareManager] loadItem:item];
}

- (void)demoBarDidSelectedFilter:(NSString *)filter {

    [FUManager shareManager].selectedFilter = filter ;
}

- (void)demoBarBeautyParamChanged {

    [self syncBeautyParams];
}

- (void)syncBeautyParams {
    
    [FUManager shareManager].selectedBlur = self.bar.selectedBlur;
    [FUManager shareManager].redLevel = self.bar.redLevel ;
    [FUManager shareManager].faceShapeLevel = self.bar.faceShapeLevel ;
    [FUManager shareManager].faceShape = self.bar.faceShape ;
    [FUManager shareManager].beautyLevel = self.bar.beautyLevel ;
    [FUManager shareManager].thinningLevel = self.bar.thinningLevel ;
    [FUManager shareManager].enlargingLevel = self.bar.enlargingLevel ;
    [FUManager shareManager].selectedFilter = self.bar.selectedFilter ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载手势
    [self loadGesture];
    
    //加载底部的美颜bar 并默认隐藏
    [self addBottomBar];
}
#pragma mark - 手势相关
///添加手势
- (void)loadGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.mainVideoView addGestureRecognizer:tap];
    
}

//加载底部的美颜bar,并默认隐藏
- (void)addBottomBar {
    [self.view addSubview:self.bar];
    [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@208);
    }];
    self.bar.hidden = YES;
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    if (self.isShowBar) {
        self.showBar = NO;
        self.closeControl = YES;
    } else {
       self.closeControl = !self.isCloseControl;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重新布局
- (void)resetLayout:(BOOL)isMultiCall mediaType:(RCCallMediaType)mediaType callStatus:(RCCallStatus)callStatus {
    [super resetLayout:isMultiCall mediaType:mediaType callStatus:callStatus];
    //将最小化按钮移除 暂时用不到此按钮
    self.minimizeButton.hidden = YES;

}


#pragma mark - RCCallReceiveDelegate

///*!
// 通话即将接通
// */
//- (void)callWillConnect {
//
//}
//
////已接通
//- (void)callDidConnect {
//
//}

///最小化
- (void)didTapMinimizeButton {
    
}

///点击切换前后摄像头
- (void)didTapCameraSwitchButton {
    [[FUManager shareManager] onCameraChange];
}

///点击静音 （添加美颜 后期也要更换图标）
- (void)didTapMuteButton {
    //隐藏相关控件
    self.closeControl = YES;
    //显示底部的美颜bar
    self.showBar = YES;
    
}

/*!
 接收到通话呼入的回调
 
 @param callSession 呼入的通话实体
 */
- (void)didReceiveCall:(RCCallSession *)callSession {
    
}

/*!
 接收到通话呼入的远程通知的回调
 
 @param callId        呼入通话的唯一值
 @param inviterUserId 通话邀请者的UserId
 @param mediaType     通话的媒体类型
 @param userIdList    被邀请者的UserId列表
 @param userDict      远程推送包含的其他扩展信息
 */
- (void)didReceiveCallRemoteNotification:(NSString *)callId
                           inviterUserId:(NSString *)inviterUserId
                               mediaType:(RCCallMediaType)mediaType
                              userIdList:(NSArray *)userIdList
                                userDict:(NSDictionary *)userDict {
    
}

/*!
 接收到取消通话的远程通知的回调
 
 @param callId        呼入通话的唯一值
 @param inviterUserId 通话邀请者的UserId
 @param mediaType     通话的媒体类型
 @param userIdList    被邀请者的UserId列表
 */
- (void)didCancelCallRemoteNotification:(NSString *)callId
                          inviterUserId:(NSString *)inviterUserId
                              mediaType:(RCCallMediaType)mediaType
                             userIdList:(NSArray *)userIdList {
    
}



- (void)dealloc {
//    [[FUManager shareManager] destoryFaceunityItems];
    [self.bar removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
