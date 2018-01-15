//
//  RCCallSingleCallViewController.m
//  RongCallKit
//
//  Created by 岑裕 on 16/3/21.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCCallSingleCallViewController.h"
#import "RCCallFloatingBoard.h"
#import "RCCallKitUtility.h"
#import "RCUserInfoCacheManager.h"
#import "RCloudImageView.h"

#import "FUVideoFrameObserverManager.h"
#import "FUManager.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>

#import "CountDownView.h"//倒计时view
#import "PayViewController.h"

#import "Networking.h"

@interface RCCallSingleCallViewController ()<FUAPIDemoBarDelegate, UIGestureRecognizerDelegate, CountDownViewDelegate>

@property(nonatomic, strong) RCUserInfo *remoteUserInfo;

///是否关闭相关控件
@property (nonatomic, assign, getter=isCloseControl) BOOL closeControl;
///是否展示底部的bar
@property (nonatomic, assign, getter=isShowBar) BOOL showBar;

@property (nonatomic, strong) FUAPIDemoBar *bar;
///控件容器数组
@property (nonatomic, strong) NSArray *controlContainerArray;
///显示剩余时间的定时器
@property (nonatomic, strong) dispatch_source_t showTimeTimer;
///检查M币的定时器
@property (nonatomic, strong) dispatch_source_t checkMoneyTimer;

///倒计时view
@property (nonatomic, strong) CountDownView *countDownView;

@property (nonatomic, strong) PayViewController *payViewController;

@end

///测试倒计时时间
static NSInteger TestCountDown = 5;


@implementation RCCallSingleCallViewController

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

- (CountDownView *)countDownView {
    if (!_countDownView) {
        _countDownView = [CountDownView CountDownView];
        _countDownView.delegate = self;
    }
    return _countDownView;
}

- (PayViewController *)payViewController {
    if (!_payViewController) {
        _payViewController = [[PayViewController alloc] init];
    }
    return _payViewController;
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

// init
- (instancetype)initWithIncomingCall:(RCCallSession *)callSession {
    return [super initWithIncomingCall:callSession];
}

- (instancetype)initWithOutgoingCall:(NSString *)targetId mediaType:(RCCallMediaType)mediaType {
    return [super initWithOutgoingCall:ConversationType_PRIVATE
                              targetId:targetId
                             mediaType:mediaType
                            userIdList:@[ targetId ]];
}

- (instancetype)initWithActiveCall:(RCCallSession *)callSession {
    return [super initWithActiveCall:callSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];

    RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
   
    
    if (!userInfo) {
        userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
    }
    self.remoteUserInfo = userInfo;
    [self.remoteNameLabel setText:userInfo.name];
    [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    
    //加载手势
    [self loadGesture];
    
    //加载底部的美颜bar 并默认隐藏
    [self addBottomBar];
    
    //注册监听 美颜视频流
    [FUVideoFrameObserverManager registerVideoFrameObserver];
    
    //初始化美颜
    [[FUManager shareManager] setUpFaceunity];

    
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

//检查M币
- (void)checkMoney {
    
    self.checkMoneyTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //没分钟执行一次检查M币
    dispatch_source_set_timer(self.checkMoneyTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(self.checkMoneyTimer, ^{
        TestCountDown--;
        NSLog(@"控制器内倒计时：%ld", TestCountDown);
        if (TestCountDown <= 0) {
            self.countDownView.hidden = NO;
            [self.countDownView startCountDowun];
            dispatch_cancel(self.checkMoneyTimer);
        }
        
    });
    
    dispatch_resume(self.checkMoneyTimer);
}

- (void)showTime {
    self.showTimeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.showTimeTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.showTimeTimer, ^{
        
    });
    dispatch_resume(self.showTimeTimer);
}


#pragma mark - FUAPIDemoBarDelegate
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


#pragma mark - 倒计时view代理方法
//充值回调
- (void)payAction {
    UIView *view = self.payViewController.view;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    
}

///倒计时结束 通话结束
- (void)callEnd {
    
    [self hangupButtonClicked];
}


#pragma mark - 手势相关
///添加手势
- (void)loadGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.mainVideoView addGestureRecognizer:tap];
    
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

#pragma mark - 控件点击方法
//静音按钮
- (void)didTapMuteButton {
    //隐藏相关控件
    self.closeControl = YES;
    //显示底部的美颜bar
    self.showBar = YES;
}

//点击切换前后摄像头
- (void)didTapCameraSwitchButton {
    [[FUManager shareManager] onCameraChange];
}


#pragma mark - 回调方法
///通话已连接
- (void)callDidConnect {
    [super callDidConnect];
    if ([self.callSession.caller isEqualToString:self.callSession.myProfile.userId]) {
        NSLog(@"我发起的通话");
        //添加倒计时view
         [self.mainVideoView addSubview:self.countDownView];
        [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainVideoView).offset(20);
            make.top.equalTo(self.remoteNameLabel).offset(30);
            make.width.equalTo(@120);
            make.height.equalTo(@40);
        }];
        self.countDownView.hidden = YES;
        //检查M币
        [self checkMoney];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *api = @"/v1/cost/minuteCost";
        NSDictionary *parameters = @{@"costCoin":@"10",
                                     @"costUserId":@"0",
                                     @"token":[userDefaults objectForKey:@"token"],
                                     @"userId":@"13969001510"
                                     };
        NSLog(@"token %@", [userDefaults objectForKey:@"token"]);
        User *user = [User ShardInstance];
        NSLog(@"%@", user.user_id);
        [Networking Post:api parameters:parameters complete:^(RequestState success, NSString *msg) {
            
        }];
        
        
    } else {
        NSLog(@"我收到的通话");
    }
}


- (RCloudImageView *)remotePortraitView {
    if (!_remotePortraitView) {
        _remotePortraitView = [[RCloudImageView alloc] init];

        [self.view addSubview:_remotePortraitView];
        _remotePortraitView.hidden = YES;
        [_remotePortraitView setPlaceholderImage:[RCCallKitUtility getDefaultPortraitImage]];
        _remotePortraitView.layer.cornerRadius = 4;
        _remotePortraitView.layer.masksToBounds = YES;
    }
    return _remotePortraitView;
}

- (UILabel *)remoteNameLabel {
    if (!_remoteNameLabel) {
        _remoteNameLabel = [[UILabel alloc] init];
        _remoteNameLabel.backgroundColor = [UIColor clearColor];
        _remoteNameLabel.textColor = [UIColor whiteColor];
        _remoteNameLabel.font = [UIFont systemFontOfSize:18];
        _remoteNameLabel.textAlignment = NSTextAlignmentCenter;

        [self.view addSubview:_remoteNameLabel];
        _remoteNameLabel.hidden = YES;
    }
    return _remoteNameLabel;
}

- (UIImageView *)statusView {
    if (!_statusView) {
        _statusView = [[RCloudImageView alloc] init];
        [self.view addSubview:_statusView];
        _statusView.hidden = YES;
        _statusView.image = [RCCallKitUtility imageFromVoIPBundle:@"voip/voip_connecting"];
    }
    return _statusView;
}

- (UIView *)mainVideoView {
    if (!_mainVideoView) {
        _mainVideoView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        _mainVideoView.backgroundColor = RongVoIPUIColorFromRGB(0x262e42);

        [self.backgroundView addSubview:_mainVideoView];
        _mainVideoView.hidden = YES;
    }
    return _mainVideoView;
}

- (UIView *)subVideoView {
    if (!_subVideoView) {
        _subVideoView = [[UIView alloc] init];
        _subVideoView.backgroundColor = [UIColor blackColor];
        _subVideoView.layer.borderWidth = 1;
        _subVideoView.layer.borderColor = [[UIColor whiteColor] CGColor];

        [self.view addSubview:_subVideoView];
        _subVideoView.hidden = YES;

        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subVideoViewClicked)];
        [_subVideoView addGestureRecognizer:tap];
    }
    return _subVideoView;
}

- (void)subVideoViewClicked {
    if ([self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [RCIMClient sharedRCIMClient].currentUserInfo;

        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
        [self.callSession setVideoView:self.subVideoView userId:self.callSession.targetId];
    } else {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];

        [self.callSession setVideoView:self.subVideoView userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
        [self.callSession setVideoView:self.mainVideoView userId:self.remoteUserInfo.userId];
    }
}

- (void)resetLayout:(BOOL)isMultiCall mediaType:(RCCallMediaType)mediaType callStatus:(RCCallStatus)callStatus {
    [super resetLayout:isMultiCall mediaType:mediaType callStatus:callStatus];

    UIImage *remoteHeaderImage = self.remotePortraitView.image;

    if (mediaType == RCCallMediaAudio) {
        self.remotePortraitView.frame = CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2,
                                                   RCCallVerticalMargin * 3, RCCallHeaderLength, RCCallHeaderLength);
        self.remotePortraitView.image = remoteHeaderImage;
        self.remotePortraitView.hidden = NO;

        self.remoteNameLabel.frame =
            CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                       self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
        self.remoteNameLabel.hidden = NO;

        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;

        self.statusView.frame = CGRectMake((self.view.frame.size.width - 17) / 2,
                                           RCCallVerticalMargin * 3 + (RCCallHeaderLength - 4) / 2, 17, 4);

        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
            self.statusView.hidden = NO;
        } else {
            self.statusView.hidden = YES;
            self.remotePortraitView.alpha = 1.0;
        }

        self.mainVideoView.hidden = YES;
        self.subVideoView.hidden = YES;
        [self resetRemoteUserInfoIfNeed];
    } else {
        if (callStatus == RCCallDialing) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView
                                    userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.blurView.hidden = YES;
        } else if (callStatus == RCCallActive) {
            self.mainVideoView.hidden = NO;
            [self.callSession setVideoView:self.mainVideoView userId:self.callSession.targetId];
            self.blurView.hidden = YES;
        } else {
            self.mainVideoView.hidden = YES;
        }

        if (callStatus == RCCallActive) {
            self.remotePortraitView.hidden = YES;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        } else if (callStatus == RCCallDialing) {
            self.remotePortraitView.frame =
                CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2, RCCallVerticalMargin * 3,
                           RCCallHeaderLength, RCCallHeaderLength);
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        } else if (callStatus == RCCallIncoming || callStatus == RCCallRinging) {
            self.remotePortraitView.frame =
                CGRectMake((self.view.frame.size.width - RCCallHeaderLength) / 2, RCCallVerticalMargin * 3,
                           RCCallHeaderLength, RCCallHeaderLength);
            self.remotePortraitView.image = remoteHeaderImage;
            self.remotePortraitView.hidden = NO;

            self.remoteNameLabel.frame =
                CGRectMake(RCCallHorizontalMargin, RCCallVerticalMargin * 3 + RCCallHeaderLength + RCCallInsideMargin,
                           self.view.frame.size.width - RCCallHorizontalMargin * 2, RCCallLabelHeight);
            self.remoteNameLabel.hidden = NO;
            self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        }

        if (callStatus == RCCallActive) {
            if ([RCCallKitUtility isLandscape] && [self isSupportOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation]) {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength * 1.5, RCCallHeaderLength);
            } else {
                self.subVideoView.frame =
                    CGRectMake(self.view.frame.size.width - RCCallHeaderLength - RCCallHorizontalMargin / 2,
                               RCCallVerticalMargin, RCCallHeaderLength, RCCallHeaderLength * 1.5);
            }
            [self.callSession setVideoView:self.subVideoView
                                    userId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
            self.subVideoView.hidden = NO;
        } else {
            self.subVideoView.hidden = YES;
        }

        self.remoteNameLabel.textAlignment = NSTextAlignmentCenter;
        self.statusView.frame = CGRectMake((self.view.frame.size.width - 17) / 2,
                                           RCCallVerticalMargin * 3 + (RCCallHeaderLength - 4) / 2, 17, 4);

        if (callStatus == RCCallRinging || callStatus == RCCallDialing || callStatus == RCCallIncoming) {
            self.remotePortraitView.alpha = 0.5;
            self.statusView.hidden = NO;
        } else {
            self.statusView.hidden = YES;
            self.remotePortraitView.alpha = 1.0;
        }
    }
    
    //将最小化按钮移除 暂时用不到此按钮
    self.minimizeButton.hidden = YES;
}

- (void)resetRemoteUserInfoIfNeed {
    if (![self.remoteUserInfo.userId isEqualToString:self.callSession.targetId]) {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.callSession.targetId];
        if (!userInfo) {
            userInfo = [[RCUserInfo alloc] initWithUserId:self.callSession.targetId name:nil portrait:nil];
        }
        self.remoteUserInfo = userInfo;
        [self.remoteNameLabel setText:userInfo.name];
        [self.remotePortraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    }
}

- (BOOL)isSupportOrientation:(UIInterfaceOrientation)orientation {
    return [[UIApplication sharedApplication]
               supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow] &
           (1 << orientation);
}

#pragma mark - UserInfo Update
- (void)onUserInfoUpdate:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.object;
    NSString *updateUserId = userInfoDic[@"userId"];
    RCUserInfo *updateUserInfo = userInfoDic[@"userInfo"];

    if ([updateUserId isEqualToString:self.remoteUserInfo.userId]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.remoteUserInfo = updateUserInfo;
            [weakSelf.remoteNameLabel setText:updateUserInfo.name];
            [weakSelf.remotePortraitView setImageURL:[NSURL URLWithString:updateUserInfo.portraitUri]];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[FUManager shareManager] destoryFaceunityItems];
}

@end
