//
//  forgetNextViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "forgetNextViewController.h"

@interface forgetNextViewController ()
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation forgetNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"忘记密码"];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
//确定
- (IBAction)confirm:(id)sender {
    [HLLoginManager NetPostresetpwdMobile:self.phoneNum password:self.password.text msgId:self.msgId verifyCode:self.yanZhengNum success:^(NSDictionary *info) {
        NSLog(@"------>>%@",info);

        NSString *resultCode = [NSString stringWithFormat:@"%@",[info objectForKey:@"resultCode"]];
        if ([resultCode isEqualToString:@"200"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
