//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSBaseTableView.h"
#import "FSBaseTopTableViewCell.h"
#import "FSBaselineTableViewCell.h"
#import "FSScrollContentView.h"
#import "FSScrollContentViewController.h"
#import "FSBottomTableViewCell.h"

#import "HLZiLiaoController.h"
#import "MLCommentsViewController.h"
#import "VideoViewController.h"
#import "ChatListController.h"
#import "ChatRoomController.h"

#import "RongCallKit.h"
#import <RongIMKit/RongIMKit.h>


#import "UserInfoNet.h"
#import "MainMananger.h"

#import "VideoUserModel.h"
#import "LoveViewController.h"
#import "EvaluateVideoViewController.h"//评价
//#import "FUManager.h"
//#import <FUAPIDemoBar/FUAPIDemoBar.h>
//#import "FUVideoFrameObserverManager.h"

#define buyVChatButtonTag 800
#define downButtonTag   2000

@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate,topButtonDelegate> {
    NSUserDefaults  *_userDefaults;
    WomanModel      *_womanModel;
    UIButton        *_backButton;
    UIButton        *_stateButton;
    UIButton        *_focusButton;
    PriceView       *_priceView;
    float           detailHeight;
    UIView          *_navView;
    UIView          *_colorView;
    NSMutableArray  *_imageMuArr;
    
    UIView          *_backGroundView;
    UIView          *_buyVChatView;
    UIButton        *_foucusButton;
    
}
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
///当前用户的M币
@property (nonatomic, assign) CGFloat balance;
///当前网红的价格
@property (nonatomic, assign) CGFloat netHotPrice;
@end

@implementation FSBaseViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//     [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"tableView嵌套tableView手势Demo";
   
    ListenNotificationName_Func(VideoCallEnd, @selector(notificationFunc:));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _womanModel = [[WomanModel alloc]init];
    _imageMuArr = [NSMutableArray array];
    //主播信息请求
    [self NetGetUserInformation:_user_id];
    
    _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, -ML_StatusBarHeight, WIDTH, HEIGHT-50+ML_StatusBarHeight) style:UITableViewStylePlain];
   
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [self addBackButton];
    [self addFootView];
     [self addNavView];
    [self setupSubViews];
    
}


- (void)notificationFunc:(NSNotification *)notification {
    [UserInfoNet getEvaluate:^(RequestState success, NSArray *modelArray, NSInteger code, NSString *msg) {
        
    }];
    EvaluateVideoViewController *vc = [[EvaluateVideoViewController alloc] init];
    UIView *view = vc.view;
    [self addChildViewController:vc];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(5);
        make.right.bottom.equalTo(self.view).offset(-5);
    }];
}

- (void)setupSubViews
{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
    _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backGroundView.backgroundColor = ML_Color(0, 0, 0, 0.49);
    _backGroundView.hidden = YES;
    
    _buyVChatView = [[UIView alloc]initWithFrame:CGRectMake(54*Iphone6Size, 266*Iphone6Size, WIDTH-(54*Iphone6Size)*2, 150*Iphone6Size)];
    _buyVChatView.hidden = YES;
    _buyVChatView.backgroundColor = Color255;
    _buyVChatView.layer.cornerRadius = 5.0;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, _buyVChatView.frame.size.width, 14)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.text = @"需支付2000M币，是否立即支付";
    titleLabel.textColor = Color155;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSArray *buttonArr = [NSArray arrayWithObjects:@"否",@"是", nil];
    for (int i = 0; i < buttonArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = buyVChatButtonTag+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        [button addTarget:self action:@selector(buyVChatButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.frame = CGRectMake(24, _buyVChatView.frame.size.height-62, 48, 34);
            button.backgroundColor = Color242;
            [button setTitleColor:Color75 forState:UIControlStateNormal];
        } else {
            button.frame = CGRectMake(_buyVChatView.frame.size.width-24-48, _buyVChatView.frame.size.height-62, 48, 34);
            button.backgroundColor = ML_Color(255, 239, 239, 1);
            [button setTitleColor:ML_Color(250, 114, 152, 1) forState:UIControlStateNormal];
        }
        [_buyVChatView addSubview:button];
    }
    [_buyVChatView addSubview:titleLabel];
    [self.view addSubview:_backGroundView];
    [self.view addSubview:_buyVChatView];
}
- (void)addNavView {
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _navView.backgroundColor = [UIColor clearColor];
    _colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _colorView.backgroundColor = NavColor;
    _colorView.alpha = 0;
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, ML_StatusBarHeight, 50, 40);
    if (UI_IS_IPHONEX) {
        _backButton.frame = CGRectMake(10, ML_StatusBarHeight, 50, 40);
    }
//    _backButton.backgroundColor = [UIColor brownColor];
    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 12, 11, 25);
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_colorView];
    [_navView addSubview:_backButton];
    [self.view addSubview:_navView];
}

- (void)backBarButtonSelect:(UIButton *)button {
        [self.navigationController popViewControllerAnimated:YES];
}
//底部视图
- (void)addFootView {
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = [NSArray arrayWithObjects:@"私信她",@"与TA视频", nil];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12+((WIDTH-48)/2+24)*i, 10, (WIDTH-48)/2, 30);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:Color255 forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0;
        button.backgroundColor = NavColor;
        if (i == 0) {
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, (WIDTH-48)/2-36);
            [button setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateHighlighted];
        } else {
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 12, 5, (WIDTH-48)/2-40);
            [button setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"shipin"] forState:UIControlStateHighlighted];
        }
        button.tag = downButtonTag+i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
    }
    [self.view addSubview:footView];
}
#pragma mark - 请求主播数据
- (void)NetGetUserInformation:(NSString *)user_id {
    NSLog(@"-------%@",user_id);
    [MainMananger NetGetgetAnchorInfoNickName:@"a" token:[_userDefaults objectForKey:@"token"] userid:user_id success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
        
            _womanModel = [[WomanModel alloc]initWithDictionary:[[info objectForKey:@"data"] objectAtIndex:0]];
            for (int i = 0; i < _womanModel.imageList.count; i++) {
                NSDictionary *dic = _womanModel.imageList[i];
                NSString *fileUrl = [dic objectForKey:@"fileUrl"];
                [_imageMuArr addObject:fileUrl];
                
            }
            NSDictionary *userDic = [NSDictionary dictionaryWithObject:_womanModel forKey:@"womanModel"];
            NSNotification *notification =[NSNotification notificationWithName:@"getWomanInformation" object:nil userInfo:userDic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//微信购买
- (void)buyVChatButton:(UIButton *)button {
    _backGroundView.hidden = YES;
    _buyVChatView.hidden = YES;
    
    if (button.tag == buyVChatButtonTag) {
        
    } else {
        
    }
}
//底部按钮点击
- (void)downButtonClick:(UIButton *)but {
    
    __weak typeof(self) weakSelf = self;
    [UserInfoNet canCall:^(RequestState success, MoneyEnoughType moneyType) {
        if (success) {
            
            //余额不充足 不能聊天 可以视频
            if (moneyType == MoneyEnoughTypeNotEnough) {
                if (but.tag == downButtonTag) {
                    [self showPayAlertController:^{
                        
                    }];
                } else {
                    [self showPayAlertController:^{
                        //去充值
                    } continueCall:^{
                        //继续视频
                        [weakSelf videoCall];
                    }];
                }
            }
            
            //余额充足 既能聊天 有能视频
            if (moneyType == MoneyEnoughTypeEnough) {
                if (but.tag == downButtonTag) {
                    [self chat];
                } else {
                    [self videoCall];
                }
            }
            
            //余额为0
            if (moneyType == MoneyEnoughTypeEmpty) {
                [self showPayAlertController:^{
                    
                }];
            }
        }
    }];

    
//    //计算可通话时长
//    [self calculatorCallTime:^(BOOL canCall) {
//        if (canCall) {
//            [weakSelf downButtonClickAction:but];
//        } else {
//            [weakSelf showPayAlertController:^{
//                //跳转充值
//            } continueCall:^{
//                [weakSelf downButtonClickAction:but];
//            }];
//        }
//    }];
    
    
}

///聊天
- (void)chat {
    //新建一个聊天会话View Controller对象,建议这样初始化
    ChatRoomController *chat = [[ChatRoomController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.videoUserModel.ID];
    chat.title = @"hehehe";
    chat.videoUser = self.videoUserModel;
    chat.automaticallyAdjustsScrollViewInsets = NO;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

///视频聊天
- (void)videoCall {
    [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:self.videoUserModel];

    
    
}

#pragma mark - 计算可通话时长
//计算可通话时长
- (void)calculatorCallTime:(void(^)(BOOL canCall))canCall {
    
    [UserInfoNet getUserBalance:^(CGFloat balance) {
        self.balance = balance;
       !canCall?:canCall(self.balance - [self.videoUserModel.price integerValue] * 5 >= 0);
    }];
//    
//    
//    __weak typeof(self) weakSelf = self;
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);;
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_enter(group);
//    [UserInfoNet getUserBalance:^(CGFloat balance) {
//        self.balance = balance;
//        dispatch_group_leave(group);
//    }];
//    
//     dispatch_group_enter(group);
//    [self getNetHotPrice:^(CGFloat price) {
//        weakSelf.netHotPrice = price;
//        dispatch_group_leave(group);
//    }];
//   
//    dispatch_group_notify(group, queue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !canCall?:canCall(self.balance - self.netHotPrice * 5 >= 0);
//            
//        });
//    });
    
}

///去充值
- (void)showPayAlertController:(void(^)(void))pay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足" message:@"是否立即充值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    [alertController addAction:cancleAction];
    [alertController addAction:payAction];
     [self presentViewController:alertController animated:YES completion:nil];
}

///弹出是否充值的alert
- (void)showPayAlertController:(void(^)(void))pay continueCall:(void(^)(void))continueCall {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的M不足不够与大V通话5分钟" message:@"是否去充值" preferredStyle:UIAlertControllerStyleAlert];
    //继续通话
    UIAlertAction *continueCallAction = [UIAlertAction actionWithTitle:@"继续通话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !continueCall?:continueCall();
    }];
    
    //充值
    UIAlertAction *payAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !pay?:pay();
    }];
    [payAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
    
    [alertController addAction:continueCallAction];
    [alertController addAction:payAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)insertRowAtTop
{
    NSArray *sortTitles = @[@"资料",@"视频",@"评论"];
    self.contentCell.currentTagStr = sortTitles[self.titleView.selectIndex];
    self.contentCell.isRefresh = YES;
//    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return WIDTH+158;
        }
        return 0;
    }
//    return CGRectGetHeight(self.view.bounds);
    return HEIGHT-ML_TopHeight-50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50) titles:@[@"资料",@"视频",@"评论"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = ML_Color(77, 77, 77, 1);
    self.titleView.titleSelectColor = NavColor;
    self.titleView.indicatorColor = NavColor;
    self.titleView.indicatorExtension = 15;
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.7, WIDTH, 0.3)];
    label.backgroundColor = Color242;
    [self.titleView addSubview:label];
    return self.titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FSBaseTopTableViewCellIdentifier = @"FSBaseTopTableViewCellIdentifier";
    static NSString *FSBaselineTableViewCellIdentifier = @"FSBaselineTableViewCellIdentifier";
    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            NSArray *titles = @[@"资料",@"视频",@"评论"];
            NSMutableArray *contentVCs = [NSMutableArray array];
            for (NSString *title in titles) {
                if ([title isEqualToString:@"资料"]) {
                    HLZiLiaoController *detailVC = [[HLZiLiaoController alloc]init];
                    detailVC.womanModel = _womanModel;
                    
                    [contentVCs addObject:detailVC];
                } else if ([title isEqualToString:@"视频"]) {
                    VideoViewController *videoVC = [[VideoViewController alloc]init];
                    videoVC.videoUserModel = _videoUserModel;
                    [contentVCs addObject:videoVC];
                } else {
                    MLCommentsViewController *vc = [[MLCommentsViewController alloc]init];
                    vc.title = title;
                    vc.str = title;
                    vc.videoUserModel = _videoUserModel;
                    [contentVCs addObject:vc];
                }
            }
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 50) childVCs:contentVCs parentVC:self delegate:self];

            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    if (indexPath.row == 0) {
        FSBaseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaseTopTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaseTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaseTopTableViewCellIdentifier];
        }
        cell.delegate = self;
        if (_imageMuArr.count >0) {
            cell.loopView.imgResourceArr = _imageMuArr;
        }
        
        [cell.priceView setPrice:_womanModel.nickname];

        cell.nameLabel.text = _womanModel.nickname;
        cell.messageLabel.text = _womanModel.descriptionStr;
        [cell.stateButton setStateStr:_womanModel.status];
        cell.numFocusLabel.text = [NSString stringWithFormat:@"%@关注",_womanModel.nickname];
        NSLog(@"----------%@",_womanModel.orderList);
        
        cell.headImage3.hidden = NO;
        cell.headImage2.hidden = NO;
        cell.headImage1.hidden = NO;
        
        if (_womanModel.orderList.count == 0) {
            cell.headImage1.hidden = YES;
            cell.headImage2.hidden = YES;
            cell.headImage3.hidden = YES;
        } else if (_womanModel.orderList.count == 1) {
            cell.headImage2.hidden = YES;
            cell.headImage3.hidden = YES;
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
        } else if (_womanModel.orderList.count == 2) {
            cell.headImage3.hidden = YES;
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
            [cell.headImage2 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[1] objectForKey:@"headUrl"]] placeholderImage:nil];
        } else {
            [cell.headImage1 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[0] objectForKey:@"headUrl"]] placeholderImage:nil];
             [cell.headImage2 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[1] objectForKey:@"headUrl"]] placeholderImage:nil];
            [cell.headImage3 sd_setImageWithURL:[NSURL URLWithString:[_womanModel.orderList[2] objectForKey:@"headUrl"]] placeholderImage:nil];
        }
        
        cell.weixinLabel.text = _womanModel.wechat;
        cell.getweixinLabel.hidden = YES;
        if ([_womanModel.sfgz isEqualToString:@"1"]) {
            cell.focusButton.selected = YES;
            [cell.focusButton setImage:nil forState:UIControlStateNormal];
            [cell.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            cell.focusButton.selected = NO;
            [cell.focusButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            [cell.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            cell.focusButton.imageEdgeInsets = UIEdgeInsetsMake(5, 13, 5, 42);
        }
        return cell;
    }else{
        FSBaselineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaselineTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaselineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaselineTableViewCellIdentifier];
        }
        return cell;
    }
    return nil;
}

#pragma mark topCellDelegate
- (void)focusButtonSelect:(UIButton *)button {
    _focusButton = [[UIButton alloc]init];
    _focusButton = button;
    if (button.selected == YES) {
        NSLog(@"--------<>><><><><>");
        button.selected = NO;
        [_focusButton setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self NetPostSelectFocusButtonisFocus:@"0"];
    } else {
        NSLog(@"--------->>>");
        button.selected = YES;
        [_focusButton setImage:nil forState:UIControlStateNormal];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self NetPostSelectFocusButtonisFocus:@"1"];
    }

}

- (void)loveNumButtonselect {
    LoveViewController *loveVC = [[LoveViewController alloc]init];
    loveVC.womanModel = _womanModel;
    [self.navigationController pushViewController:loveVC animated:YES];
}

- (void)weiXinButtonSelect {
   
    _backGroundView.hidden = NO;
    _buyVChatView.hidden = NO;
}
//关注的请求方法
- (void)NetPostSelectFocusButtonisFocus:(NSString *)isFocus {
  
    [MainMananger NetPostCareuserBgzaccount:_womanModel.username gzaccount:[YZCurrentUserModel sharedYZCurrentUserModel].username sfgz:isFocus token:[YZCurrentUserModel sharedYZCurrentUserModel].token success:^(NSDictionary *info) {
        NSLog(@"---%@--",info);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    NSLog(@"-----------------%lu",endIndex);
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    NSLog(@"--------------->>>select--%lu",endIndex);
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 200;
    if (scrollView == _tableView) {
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
//            NSLog(@"--------%lf",alpha);
        _colorView.alpha = alpha;
    }
  
 
    CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y-85;
//    NSLog(@"--------%lf-----%lf",bottomCellOffset,scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}


#pragma mark - 网络方法
///获取当前网红的价格
- (void)getNetHotPrice:(void(^)(CGFloat price))price {
//    sleep(0.5);
    !price?:price(5);
}

#pragma mark LazyLoad
//- (FSBaseTableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

@end
