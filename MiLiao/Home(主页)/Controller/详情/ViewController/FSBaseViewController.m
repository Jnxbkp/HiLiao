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

//
//#import "FUManager.h"
//#import <FUAPIDemoBar/FUAPIDemoBar.h>
//#import "FUVideoFrameObserverManager.h"

#define downButtonTag   2000
@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate> {
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

- (void)setupSubViews
{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
}
- (void)addNavView {
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _navView.backgroundColor = [UIColor clearColor];
    _colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ML_TopHeight)];
    _colorView.backgroundColor = NavColor;
    _colorView.alpha = 0;
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 20, 50, 40);
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
    chat.automaticallyAdjustsScrollViewInsets = NO;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

///视频聊天
- (void)videoCall {
    [[RCCall sharedRCCall] startSingleVideoCallToVideoUser:self.videoUserModel];
//     [[RCCall sharedRCCall] startSingleVideoCall:@"18678899778" price:self.videoUserModel.price costUserId:self.videoUserModel.ID];
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
                    [contentVCs addObject:videoVC];
                } else {
                    MLCommentsViewController *vc = [[MLCommentsViewController alloc]init];
                    vc.title = title;
                    vc.str = title;
                    [contentVCs addObject:vc];
                }
            }
            _contentCell.viewControllers = contentVCs;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 50) childVCs:contentVCs parentVC:self delegate:self];
//            for (UIViewController *VC in contentVCs) {
//                if ([VC isKindOfClass:[HLZiLiaoController class]]) {
//                    _contentCell.frame = CGRectMake(0, 0, WIDTH, 386);
//                    _contentCell.pageContentView.frame = CGRectMake(0, 0, WIDTH, 386);
//                }
//               
//            }
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    if (indexPath.row == 0) {
        FSBaseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaseTopTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaseTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaseTopTableViewCellIdentifier];
        }
    
        if (_imageMuArr.count >0) {
            cell.loopView.imgResourceArr = _imageMuArr;
        }
        
        [cell.priceView setPrice:@"20"];
        cell.nameLabel.text = _womanModel.nickname;
        cell.messageLabel.text = _womanModel.descriptionStr;
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

#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
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
