//
//  ChatListController.m
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ChatListController.h"
#import "ChatRoomController.h"
#import "messageView.h"
//#import "DatingModel.h"
@interface ChatListController ()<RCIMUserInfoDataSource>

@end

@implementation ChatListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageWithColor:[UIColor colorWithHexString:@"7DC157"]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
//    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],
//                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FFFFFF"]};
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes; // 导航栏标题字体大小及颜色
//    self.navigationController.navigationBar.alpha = 1.00;
}
-(void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"消息"];
    // Do any additional setup after loading the view.
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    //设置需要显示哪些类型的会话
    

    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    messageView *vc = [[NSBundle mainBundle] loadNibNamed:
                       @"messageView" owner:nil options:nil ].lastObject;
    self.conversationListTableView.tableHeaderView = vc;
   
    
//    self.conversationListTableView.tableHeaderView
    if ([self.conversationListTableView respondsToSelector:@selector (setSeparatorInset:)]) {
        [self.conversationListTableView setSeparatorInset:UIEdgeInsetsZero ];
        [self.conversationListTableView setSeparatorColor:[UIColor colorWithHexString:@"EEEEEE"]];
    }
    
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"fanhui2"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [RCIM sharedRCIM].userInfoDataSource = self;

}
- (void)leftButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    //通过刷新列表给cell赋值
    NSLog(@"userid ==== %@",userId);
//    [[APIManager ShardInstance] postGetUserMessageDataUser_id:userId resultBlock:^(NSDictionary *data, NSError *error) {
//        if (error) return;
//        UserChatMegModel *model = [UserChatMegModel mj_objectWithKeyValues:data[@"list"]];
     RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""];
        completion(info);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatRoomController *conversationVC = [[ChatRoomController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}



@end
