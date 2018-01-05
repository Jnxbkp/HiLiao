//
//  registerViewController.m
//  MChat
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 Zc. All rights reserved.
//

#import "registerViewController.h"
#import "HLLoginManager.h"
#import "LoginViewController.h"
#import "phoneLoginViewController.h"
//#import "MeViewController.h"
#define CountDown 60

@interface registerViewController ()
@property(nonatomic,assign) NSInteger secondCountDown;
@property(nonatomic,strong) NSTimer *countDownTimer;
@property(nonatomic,strong) NSString *msgId;

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *yanzhengNum;
@property (strong, nonatomic) IBOutlet UIButton *getButton;//获取验证码

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [super viewWillDisappear:animated];
//}
//获取验证码
- (IBAction)yanzheng:(id)sender {
    self.getButton.enabled=NO;
    
    [HLLoginManager NetGetgetVerifyCodeMobile:self.phoneNum.text success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        self.msgId = info[@"data"][@"msgId"];
        NSLog(@"--------%@",self.msgId);
        //写在网络请求里
        [self getCodeFromSer];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}
- (void)getCodeFromSer{
    _secondCountDown = CountDown;
    _countDownTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
//60秒倒计时
-(void)timeFireMethod{
    
    _secondCountDown--;
    
    NSString*secondStr1=[NSString stringWithFormat:@"重新发送(%ld秒)",(long)_secondCountDown];
    [self.getButton setTitle:secondStr1 forState:UIControlStateDisabled];
    
    if (_secondCountDown==0) {
        [_countDownTimer invalidate];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateDisabled];
        self.getButton.enabled=YES;
        self.getButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    }
}
//下一步
- (IBAction)next:(id)sender {
    [HLLoginManager NetPostRegisterMobile:self.phoneNum.text password:self.password.text msgId:self.msgId verifyCode:self.yanzhengNum.text success:^(NSDictionary *info) {
        NSLog(@"注册---------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            phoneLoginViewController*bvc = [[phoneLoginViewController alloc]init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:bvc];
            [self presentViewController:nav animated:NO completion:^{
            }];
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
