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
@property (strong, nonatomic) NSArray *tags;

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"选择形象标签"];
    self.view.backgroundColor = [UIColor whiteColor];
    _textTagCollectionView2 = [[TTGTextTagCollectionView alloc]initWithFrame:CGRectMake(20, 10, WIDTH-40, HEIGHT)];
    _tags = @[
              @"情感专家",
              @"清纯美女", @"宅男女神",@"邻家小妹",@"长发飘逸",@"长发飘逸",@"长发飘逸",@"长发飘逸",@"长发飘逸"
              ];
    _textTagCollectionView2.delegate = self;
    _textTagCollectionView2.showsVerticalScrollIndicator = NO;
    // Style2
    TTGTextTagConfig *config = _textTagCollectionView2.defaultConfig;

    config = _textTagCollectionView2.defaultConfig;
    
    config.tagTextFont = [UIFont systemFontOfSize:20.0f];
    
    config.tagExtraSpace = CGSizeMake(12, 12);
    
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    
    config.tagBackgroundColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor redColor];
    
    config.tagCornerRadius = 8.0f;
    config.tagSelectedCornerRadius = 4.0f;
    
    config.tagBorderWidth = 0;
    
    config.tagBorderColor = [UIColor whiteColor];
    config.tagSelectedBorderColor = [UIColor whiteColor];
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 1);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 2;
    
    _textTagCollectionView2.horizontalSpacing = 8;
    _textTagCollectionView2.verticalSpacing = 8;
    _textTagCollectionView2.selectionLimit = 2;
    [_textTagCollectionView2 addTags:_tags];
    [_textTagCollectionView2 reload];
    [self.view addSubview:_textTagCollectionView2];
}
#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    NSLog(@"%@",tagText);
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}


@end
