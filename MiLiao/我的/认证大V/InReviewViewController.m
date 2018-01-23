//
//  InReviewViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "InReviewViewController.h"

@interface InReviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation InReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_IS_IPHONEX) {
        self.bgView.image = [UIImage imageNamed:@"画板 1 拷贝"];
    }
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
- (IBAction)go:(id)sender {
//    self.tabBarController.hidesBottomBarWhenPushed=NO;
//    self.tabBarController.selectedIndex=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil];

}



@end
