//
//  VideoViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "VideoViewController.h"
#import "MLDiscoverListCollectionViewCell.h"

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) BOOL fingerIsTouch;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;
@end

static NSString * const reuseIdentifier = @"Cell";
@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市", nil];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 2.5, 0);
    layout.itemSize =  CGSizeMake((WIDTH-5)/2, (WIDTH-5)/2*1.2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.collectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    //    __weak typeof(self) weakSelf = self;
    //    [self.tableView addInfiniteScrollingWithActionHandler:^{
    //        [weakSelf insertRowAtBottom];
    //    }];
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
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
#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    DebugLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //    DebugLog(@"离开屏幕");
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
