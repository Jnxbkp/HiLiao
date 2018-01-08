//
//  ChatListController.m
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ChatListController.h"
#import "ChatRoomController.h"
//#import "DatingModel.h"
@interface ChatListController ()<RCIMUserInfoDataSource>

@end

@implementation ChatListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageWithColor:[UIColor colorWithHexString:@"7DC157"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FFFFFF"]};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes; // 导航栏标题字体大小及颜色
    self.navigationController.navigationBar.alpha = 1.00;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.title = @"聊天";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.conversationListTableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
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
//    RtLog(@"userid ==== %@",userId);
//    [[APIManager ShardInstance] postGetUserMessageDataUser_id:userId resultBlock:^(NSDictionary *data, NSError *error) {
//        if (error) return;
//        UserChatMegModel *model = [UserChatMegModel mj_objectWithKeyValues:data[@"list"]];
//     RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:model.nickname portrait:model.face];
//        completion(info);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
