//
//  MLHomeViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLHomeListTableViewController.h"
#import "MLSearchViewController.h"

#define kSearchBarWidth (30.0f)
@interface MLHomeViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) MLHomeListTableViewController *hotViewController;
@property (nonatomic, strong) MLHomeListTableViewController *focusViewController;
@property (nonatomic, strong) MLHomeListTableViewController *newViewController;

@property (nonatomic, strong) NSArray       *menuList;

@end

@implementation MLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, WIDTH-10, 44)];
//    titleView.backgroundColor = [UIColor blueColor];
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateNormal];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateHighlighted];
    searchBut.frame = CGRectMake(19, 10, WIDTH-48, 28);

    [searchBut addTarget:self action:@selector(pushSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBut];
    self.navigationItem.titleView = titleView;
    
    self.view.backgroundColor = [UIColor grayColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
//    [self integrateComponents];
    
    [self generateTestData];
    [_magicController.magicView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

//
- (void)pushSearchVC:(UIButton *)button {
    MLSearchViewController *searchVC = [[MLSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in _menuList) {
        
        [titleList addObject:menu.title];
    }
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    MenuInfo *menuInfo = _menuList[pageIndex];
    if ([menuInfo.title isEqualToString:@"推荐"]) { // if (0 == pageIndex) {
        return self.hotViewController;
    } else if ([menuInfo.title isEqualToString:@"关注"]) {
        return self.focusViewController;
    } else {
        return self.newViewController;
    }
}

#pragma mark - functional methods
- (void)generateTestData {
    _menuList = @[[MenuInfo menuInfoWithTitl:@"推荐"], [MenuInfo menuInfoWithTitl:@"关注"], [MenuInfo menuInfoWithTitl:@"新人"]];
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 40.f;
//        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (MLHomeListTableViewController *)hotViewController {
    if (!_hotViewController) {
        _hotViewController = [[MLHomeListTableViewController alloc] init];
    }
    return _hotViewController;
}

- (MLHomeListTableViewController *)focusViewController {
    if (!_focusViewController) {
        _focusViewController = [[MLHomeListTableViewController alloc] init];
    }
    return _focusViewController;
}

- (MLHomeListTableViewController *)newViewController {
    if (!_newViewController) {
        _newViewController = [[MLHomeListTableViewController alloc] init];
    }
    return _newViewController;
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
