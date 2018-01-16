//
//  VideoViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoViewController.h"
#import "MLDiscoverListCollectionViewCell.h"
#import "MainMananger.h"

#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

static NSString * const reuseIdentifier = @"Cell";
@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
//    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市", nil];
    _dataArr = [NSMutableArray array];
    
    [self netGetUserVideoList];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50-ML_TopHeight-50) collectionViewLayout:layout];
    _collectionView.backgroundColor = Color242;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    _collectionView.mj_footer = footer;
    [self.collectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];

    //    __weak typeof(self) weakSelf = self;
    //    [self.tableView addInfiniteScrollingWithActionHandler:^{
    //        [weakSelf insertRowAtBottom];
    //    }];
}
//主播视频列表
- (void)netGetUserVideoList {
    [MainMananger NetPostgetVideoListById:_videoUserModel.ID token:[YZCurrentUserModel sharedYZCurrentUserModel].token pageNumber:@"1" pageSize:@"10" success:^(NSDictionary *info) {
        NSLog(@"---------------->>><<<<<>>><<<>>%@",info);
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
#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
        NSLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
        //            return;
        //        }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.collectionView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma - (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
 <#code#>
 }
 
 - (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 <#code#>
 }
 
 - (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
 <#code#>
 }
 
 - (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
 <#code#>
 }
 
 - (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
 <#code#>
 }
 
 - (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
 <#code#>
 }
 
 - (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
 <#code#>
 }
 
 - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
 <#code#>
 }
 
 - (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
 <#code#>
 }
 
 - (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
 <#code#>
 }
 
 - (void)setNeedsFocusUpdate {
 <#code#>
 }
 
 - (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
 <#code#>
 }
 
 - (void)updateFocusIfNeeded {
 <#code#>
 }
 
 mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
