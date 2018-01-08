//
//  TagViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "TagViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TagViewController ()<TTGTextTagCollectionViewDelegate>
@property(strong, nonatomic)TTGTextTagCollectionView *textTagCollectionView2;
@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"选择形象标签"];
}



@end
