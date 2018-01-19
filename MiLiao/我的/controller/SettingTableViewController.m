//
//  SettingTableViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "IQActionSheetPickerView.h"

@interface SettingTableViewController ()<IQActionSheetPickerViewDelegate>
{
    NSUserDefaults *_userDefaults;

}
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UISwitch *swich;
@property (nonatomic, copy) NSString * strM;
@property (nonatomic, copy) NSString * strCM;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"设置"];
    self.swich.on = YES;//设置初始为ON的一边
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userDefaults = [NSUserDefaults standardUserDefaults];

}
- (IBAction)swich:(UISwitch *)sender {
    BOOL isButtonOn = [self.swich isOn];
    if (isButtonOn) {
        NSLog(@"开");
    }else {
        NSLog(@"关");
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
        //        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"向Ta收取"],@[@"100", @"95",@"90",@"85",@"80",@"75",@"70",@"65",@"60",@"55",@"50",@"45",@"40",@"35",@"30",@"25",@"20",@"15",@"10"],@[@"M币/分钟"]]];
        [picker show];
    }
    
}
#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
        self.strCM = [titles objectAtIndex:1];
        self.money.text = [NSString stringWithFormat:@"%@M币/分钟", self.strCM];
    
    [HLLoginManager setPrice:50 token:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"----------------%@",info);
        if (resultCode == SUCCESS) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }

    } failure:^(NSError *error) {
        NSLog(@"11111111111%@",error);
    }];
}
@end
