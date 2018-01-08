//
//  ChatRoomController.m
//  XinMart
//
//  Created by iMac on 2017/9/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ChatRoomController.h"
//#import "PersonHomepageController.h"
//#import "DatingModel.h"
@interface ChatRoomController ()<RCIMUserInfoDataSource>

@end

@implementation ChatRoomController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageWithColor:[UIColor colorWithHexString:@"7DC157"]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"FFFFFF"]};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes; // 导航栏标题字体大小及颜色
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
//    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
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
//    RtLog(@"userid ==== %@",userId);
//    [[APIManager ShardInstance] postGetUserMessageDataUser_id:userId resultBlock:^(NSDictionary *data, NSError *error) {
//        if (error) return;
//        UserChatMegModel *model = [UserChatMegModel mj_objectWithKeyValues:data[@"list"]];
//        RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:userId name:model.nickname portrait:model.face];
//        completion(info);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// @param userId  点击头像对应的用户ID
- (void)didTapCellPortrait:(NSString *)userId {
//    RtLog(@"%@",userId);
//    PersonHomepageController *person = [[UIStoryboard XinMartStoryboard] instantiateViewControllerWithIdentifier:@"PersonHomepageController"];
//    person.user_id = userId;
//    [self.navigationController pushViewController:person animated:YES];
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
