//
//  InReviewViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "InReviewViewController.h"

@interface InReviewViewController ()

@end

@implementation InReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)go:(id)sender {
//    self.tabBarController.hidesBottomBarWhenPushed=NO;
//    self.tabBarController.selectedIndex=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KSwitchRootViewControllerNotification" object:nil];

}



@end
