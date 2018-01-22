//
//  forgetPassViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "forgetPassViewController.h"
#import "forgetNextViewController.h"
#define CountDown 60

@interface forgetPassViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *yanZhengNum;
@property (strong, nonatomic) IBOutlet UIButton *getButton;
@property(nonatomic,assign) NSInteger secondCountDown;
@property(nonatomic,strong) NSTimer *countDownTimer;
@property(nonatomic,strong) NSString *msgId;
@end

@implementation forgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"忘记密码"];
    UIButton *leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 50, 30);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)leftButtonDidClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)yanzheng:(id)sender {
    [self.view endEditing:YES];
    self.getButton.enabled=NO;
    
    [HLLoginManager NetGetgetVerifyCodeMobile:self.phoneNum.text success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            self.msgId = info[@"data"][@"verifyCode"];
            NSLog(@"--------%@",self.msgId);
            //写在网络请求里
            [self getCodeFromSer];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
     
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//下一步
- (IBAction)next:(id)sender {
    [HLLoginManager verifyCodeResetPWD:self.phoneNum.text verifyCode:self.yanZhengNum.text success:^(NSDictionary *info){
        NSLog(@"----------------%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            forgetNextViewController *next = [[forgetNextViewController alloc]init];
            next.phoneNum = self.phoneNum.text;
            next.yanZhengNum = self.yanZhengNum.text;
            next.msgId = self.msgId;//验证码
            [self.navigationController pushViewController:next animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:info[@"resultMsg"]];

        }
        
    } failure:^(NSError *error) {
        
    }];
  
}
- (void)getCodeFromSer{
    _secondCountDown = CountDown;
    _countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
//60秒倒计时
-(void)timeFireMethod{
    
    _secondCountDown--;
    
    NSString*secondStr1=[NSString stringWithFormat:@"重新发送(%ld秒)",(long)_secondCountDown];
    [self.getButton setTitle:secondStr1 forState:UIControlStateNormal];
    
    if (_secondCountDown==0) {
        [_countDownTimer invalidate];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getButton setTitle:@"重新发送" forState:UIControlStateDisabled];
        self.getButton.enabled=YES;
        self.getButton.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
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
