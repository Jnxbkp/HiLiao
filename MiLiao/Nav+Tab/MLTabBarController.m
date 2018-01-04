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
#import "MLUploadViewController.h"
#import "messageViewController.h"
#import "MeViewController.h"

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
    NSString *isV = @"no";
    self.delegate = self;
    [self addChildViewController:[[MLHomeViewController alloc]init] title:nil imageName:@"heart_white" navigationIsHidden:@"yes"];
    [self addChildViewController:[[MLDiscoverViewController alloc]init] title:nil imageName:@"heart_white" navigationIsHidden:@"yes"];
//    if ([isV isEqualToString:@"yes"]) {
        [self addChildViewController:[[MLUploadViewController alloc] init] title:nil imageName:@"heart_white" navigationIsHidden:@"no"];
//    } else {
//
//    }

    [self addChildViewController:[[messageViewController alloc] init] title:nil imageName:@"heart_white" navigationIsHidden:@"no"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MeViewController *meViewController = [story instantiateViewControllerWithIdentifier:@"MeViewController"];
    [self addChildViewController:meViewController title:nil imageName:@"heart_white" navigationIsHidden:@"yes"];
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName navigationIsHidden:(NSString *)isHidden {
    
//    childController.tabBarItem.title = title;
    
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
//    [childController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    NSString *selectedImageName = [NSString string];
    if ([imageName isEqualToString:@"heart_white"]) {
        selectedImageName = @"heart_blue";
    }
//    else if ([imageName isEqualToString:@"home_default_icon"]) {
//        selectedImageName = @"event_default_icon";
//    } else if ([imageName isEqualToString:@"home_default_icon"]) {
//        selectedImageName = @"event_default_icon";
//    } else if ([imageName isEqualToString:@"home_default_icon"]) {
//        selectedImageName = @"event_default_icon";
//    } else if ([imageName isEqualToString:@"home_default_icon"]) {
//        selectedImageName = @"event_default_icon";
//    }
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectedImage;
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
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
        itemSelect = @"Search";
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
