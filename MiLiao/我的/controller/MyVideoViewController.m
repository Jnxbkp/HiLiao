//
//  MyVideoViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MyVideoViewController.h"
#import "MLDiscoverListCollectionViewCell.h"
#import "MainMananger.h"

#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9
@interface MyVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end
static NSString * const reuseIdentifier = @"Cell";
@implementation MyVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"小视频"];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray array];
    [self netGetUserVideoList];
    [self setupSubViews];

}
- (void)setupSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-ML_TopHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = Color242;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    _collectionView.mj_footer = footer;
    [self.collectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
}
//主播视频列表
- (void)netGetUserVideoList{
    [MainMananger NetPostgetVideoListById:_videoUserModel.ID token:[YZCurrentUserModel sharedYZCurrentUserModel].token pageNumber:@"1" pageSize:@"10" success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSArray *arr = [info objectForKey:@"data"];
            for (int i = 0; i < arr.count; i ++) {
                NSDictionary *dic = arr[i];
                [_dataArr addObject:dic];
            }
            [_collectionView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}
//加载更多
- (void)footerLoadMore:(MJRefreshFooter *)footer {
    [footer endRefreshing];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return _dataArr.count;
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    CGSize likeSize = [NSStringSize getNSStringHeight:@"2223" Font:12.0];
    cell.likeNumLabel.frame = CGRectMake(itemWidth-likeSize.width-12, cell.timeLabel.frame.origin.y, likeSize.width, 12);
    cell.iconImageView.frame = CGRectMake(cell.likeNumLabel.frame.origin.x-18, cell.timeLabel.frame.origin.y+1.5, 10, 9);
    cell.mainImgageView.image = [UIImage imageNamed:@"aaa"];
    cell.timeLabel.text = @"12小时";
    cell.messageLabel.text = @"来玩啊啊 ad福建省打客服";
    cell.likeNumLabel.text = @"22";
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentPage = self.magicController.currentPage;
    NSLog(@"==didSelectItemAtIndexPath%@ \n current page is: %ld==", indexPath, (long)currentPage);
    //    VTDetailViewController *detailViewController = [[VTDetailViewController alloc] init];
    //    detailViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailViewController animated:YES];
}
//UICollectionView item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(itemWidth, itemHeight);
    
}
//UICollectionView  margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 12, 0, 12);
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

@end
