//
//  HLVideoListViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/8.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLVideoListViewController.h"

@interface HLVideoListViewController () {

}

@property (nonatomic, strong)UIButton   *backButton;

@end

@implementation HLVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButton];
   
}
//返回按钮
- (void)addBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, 27, 40, 30);
    [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

//返回
- (void)backBarButtonSelect:(UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
