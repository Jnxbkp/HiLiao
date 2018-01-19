//
//  AuditSuccessViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "AuditSuccessViewController.h"
#import "SettingTableViewController.h"
@interface AuditSuccessViewController ()
{
    NSUserDefaults *_userDefaults;
    
}
@end

@implementation AuditSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];

//    [HLLoginManager setPrice:50 token:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
//        NSInteger resultCode = [info[@"resultCode"] integerValue];
//        NSLog(@"----------------%@",info);
//        if (resultCode == SUCCESS) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"11111111111%@",error);
//    }];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)success:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    SettingTableViewController *set = [story instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
//    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:set];

    [self.navigationController pushViewController:set animated:YES];
    
    
//    [self presentViewController:set animated:NO completion:^{
////
////
////
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
