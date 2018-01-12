//
//  MLTabBarController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLTabBarController.h"
#import "MLHomeViewController.h"
#import "MLDiscoverViewController.h"
#import "messageViewController.h"
#import "MeViewController.h"
#import "HLTabBar.h"
#import "ViewController.h"

#import "ChatListController.h"

@interface MLTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MLTabBarController

+ (void)initialize {
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.0];
//    attrs[NSForegroundColorAttributeName] = KColor(163, 163, 163);
//
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSFontAttributeName] = [UIFont fontWithName:proLight size:10.0];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor clearColor];
//
//    UITabBarItem *item = [UITabBarItem appearance];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *isV = @"no";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isBigV = [userDefaults objectForKey:@"isBigV"];
    self.delegate = self;
//    if ([isBigV isEqualToString:@"1"]) {
        [self InitMiddleView];
//    } else {
//
//    }
    
    
    [self addChildViewController:[[MLHomeViewController alloc]init] title:nil imageName:@"tab_main_nomal" navigationIsHidden:@"no"];
    
    [self addChildViewController:[[MLDiscoverViewController alloc]init] title:nil imageName:@"tab_discover_nomal" navigationIsHidden:@"yes"];
   

    [self addChildViewController:[[ChatListController alloc] init] title:nil imageName:@"tab_message_nomal" navigationIsHidden:@"no"];
        
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MeViewController *meViewController = [story instantiateViewControllerWithIdentifier:@"MeViewController"];
    [self addChildViewController:meViewController title:nil imageName:@"tab_my_nomal" navigationIsHidden:@"yes"];
    
}
- (void)InitMiddleView
{
    HLTabBar *tabBar = [[HLTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar setDidMiddBtn:^{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewController *VC = [story instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *ANavigationController = [[UINavigationController alloc] initWithRootViewController:VC];
        ANavigationController.navigationBarHidden = YES;
        [self presentViewController:ANavigationController animated:YES completion:nil];
//        [self presentViewController:VC animated:YES completion:nil];
    }];
}
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName navigationIsHidden:(NSString *)isHidden {
    
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    NSString *selectedImageName = [NSString string];
    if ([imageName isEqualToString:@"tab_main_nomal"]) {
        selectedImageName = @"tab_main";
    } else if ([imageName isEqualToString:@"tab_discover_nomal"]) {
        selectedImageName = @"tab_discover";
    } else if ([imageName isEqualToString:@"tab_message_nomal"]) {
        selectedImageName = @"tab_message";
    } else if ([imageName isEqualToString:@"tab_my_nomal"]) {
        selectedImageName = @"tab_my";
    } 
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectedImage;
    
    
    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:childController];
    if ([isHidden isEqualToString:@"yes"]) {
        nav.navigationBarHidden = YES;
    }
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSString *itemSelect = [NSString string];
    if (tabBarController.selectedIndex == 0) {
        itemSelect = @"Home";
    } else if (tabBarController.selectedIndex == 1) {
        itemSelect = @"Shop";
    } else if (tabBarController.selectedIndex == 2) {
        NSLog(@"----------------%@",viewController.view.subviews);
    } else {
        
    }
    
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    NSLog(@"-=-==-%f",tabBar.frame.size.width);
//
//    [self animationWithIndex:index];
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    for (int i = 0; i < tabbarbuttonArray.count; i ++) {
        UIView *tabBarButton = (UIView *)tabbarbuttonArray[i];
        if (index == i) {
            tabBarButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } else {
            tabBarButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
        [UIView animateWithDuration:0.3 animations:^{
            if (i == index) {
                tabBarButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } else {
                tabBarButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
            
        }];
    }
    
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
