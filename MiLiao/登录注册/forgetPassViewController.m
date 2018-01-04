//
//  forgetPassViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "forgetPassViewController.h"
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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
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
//下一步
- (IBAction)next:(id)sender {
    
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

@end
