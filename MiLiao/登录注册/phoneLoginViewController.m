//
//  phoneLoginViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "phoneLoginViewController.h"
#import "registerViewController.h"
#import "forgetPassViewController.h"
@interface phoneLoginViewController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *weiBo;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation phoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}
//注册
- (IBAction)registe:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:^{
        
    }];
}
//登录
- (IBAction)login:(id)sender {
    [HLLoginManager NetPostLoginMobile:self.phoneNum.text password:self.password.text success:^(NSDictionary *info) {
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:nil];
        }
       
    } failure:^(NSError *error) {
        
    }];

}
//三方登录
- (IBAction)thirdLog:(UIButton *)sender {
    if (sender == self.weChat) {
        
    }
    if (sender == self.QQ) {
        
    }if (sender == self.weiBo) {
        
    }
}
//忘记密码
- (IBAction)forget:(id)sender {
//    forgetPassViewController*bvc = [[forgetPassViewController alloc]init];
//
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bvc];
//
//    [self presentViewController:nav animated:NO completion:^{
//
//
//
//    }];
    

    forgetPassViewController *forget = [[forgetPassViewController alloc]init];
//    [self presentViewController:forget animated:YES completion:^{
//    }];
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
