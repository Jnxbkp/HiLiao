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

#import "VideoCallViewController.h"

#import "FUManager.h"
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "FUVideoFrameObserverManager.h"

#define downButtonTag   2000
@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate, FUAPIDemoBarDelegate> {
    UIButton        *_backButton;
    UIButton        *_stateButton;
    UIButton        *_focusButton;
    PriceView       *_priceView;
    float           detailHeight;
}
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) FUAPIDemoBar *bar;
@end

@implementation FSBaseViewController


/**
 Faceunity道具美颜工具条
 初始化 FUAPIDemoBar，设置初始美颜参数
 
 @param bar
 */
-(FUAPIDemoBar *)bar {
    if (!_bar ) {
        _bar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, 380, self.view.frame.size.width, 208)];
        
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"tableView嵌套tableView手势Demo";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addBackButton];
    [self addFootView];
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
//返回按钮
- (void)addBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, 27, 40, 30);
    [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}
- (void)backBarButtonSelect:(UIButton *)button {
        [self.navigationController popViewControllerAnimated:YES];
}
//底部视图
- (void)addFootView {
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = [NSArray arrayWithObjects:@"与TA私信",@"与TA视频", nil];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25+((WIDTH-100)/2+50)*i, 10, (WIDTH-100)/2, 30);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 8.0;
        if (i == 0) {
            button.backgroundColor = [UIColor redColor];
            [button setImage:[UIImage imageNamed:@"heart_blue"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"heart_blue"] forState:UIControlStateHighlighted];
        } else {
            button.backgroundColor = [UIColor blueColor];
            [button setImage:[UIImage imageNamed:@"heart_blue"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"heart_blue"] forState:UIControlStateHighlighted];
        }
        button.tag = downButtonTag+i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
    }
    [self.view addSubview:footView];
}
//底部按钮点击
- (void)downButtonClick:(UIButton *)but {
    if (but.tag == downButtonTag) {
//        ChatListController *chat = [[ChatListController alloc] init];
////        [chat setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:chat animated:YES];
        
        //新建一个聊天会话View Controller对象,建议这样初始化
        ChatRoomController *chat = [[ChatRoomController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"18678899778"];
        chat.title = @"hehehe";
//        chat.title = [NSString stringWithFormat:@"%@",self.personModel.user.nickname];

        chat.automaticallyAdjustsScrollViewInsets = NO;
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    } else {
        
//        [[RCCall sharedRCCall] startSingleCall:@"18678899778"
//                                     mediaType:RCCallMediaVideo];
//        
//         [FUVideoFrameObserverManager registerVideoFrameObserver];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            // 将 FUAPIDemoBar 添加到页面上
//            [[UIApplication sharedApplication].keyWindow addSubview:self.bar];
//            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.bar];
//            
//            // 初始化Faceunity
//            [[FUManager shareManager] setUpFaceunity];
//            
//        });
        
        VideoCallViewController *callViewController = [[VideoCallViewController alloc] initWithOutgoingCall:@"18678899778" mediaType:RCCallMediaVideo];
        [self presentViewController:callViewController animated:YES completion:nil];

    }
}

// 贴纸
- (void)demoBarDidSelectedItem:(NSString *)item {
    
    [[FUManager shareManager] loadItem:item];
}
// 滤镜
- (void)demoBarDidSelectedFilter:(NSString *)filter {
    
    [FUManager shareManager].selectedFilter = filter ;
}
// 美颜
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
            return WIDTH*0.76+60;
        }
        return 0;
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50) titles:@[@"资料",@"视频",@"评论"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.backgroundColor = [UIColor whiteColor];
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
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    if (indexPath.row == 0) {
        FSBaseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaseTopTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaseTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaseTopTableViewCellIdentifier];
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
    CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y ;
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
