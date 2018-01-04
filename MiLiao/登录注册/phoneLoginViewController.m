//
//  phoneLoginViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "phoneLoginViewController.h"
#import "registerViewController.h"
@interface phoneLoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *weChat;
@property (strong, nonatomic) IBOutlet UIButton *QQ;
@property (strong, nonatomic) IBOutlet UIButton *weiBo;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation phoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillDisappear:animated];
//}
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:nil];
    } failure:^(NSError *error) {
        
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil userInfo:nil];
}
//三方登录
- (IBAction)thirdLog:(UIButton *)sender {
    if (sender == self.weChat) {
        
    }
    if (sender == self.QQ) {
        
    }if (sender == self.weiBo) {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
