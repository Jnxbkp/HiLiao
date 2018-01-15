//
//  MLDiscoverViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLDiscoverViewController.h"
#import "MLDiscoverListCollectionViewCell.h"
#import "DiscoverMananger.h"
/**** Controller ****/
#import "PlayViewController.h"

#define selectButtonTag          2000
#define tabHight   HEIGHT-ML_TopHeight-ML_TabBarHeight

#define newStr                     @"NEW"
#define hotStr                    @"HOT"
#define page                       @"1"
#define itemWidth                 (WIDTH-32)/2
#define itemHeight                 itemWidth*16/9

static NSString *const bigIdentifer = @"bigCell";
static NSString *const newIdentifer = @"newCell";
static NSString *const hotIdentifer = @"hotCell";

@interface MLDiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    
    NSUserDefaults      *_userDefaults;
    UICollectionView    *_bigCollectionView;
    UICollectionView    *_newCollectionView;
    UICollectionView    *_hotCollectionView;
   
    NSMutableArray      *_hotList;
    NSMutableArray      *_newsList;
    UIView              *_downView;
    
    NSString            *_selectStr;
    UIButton            *_newButton;
    UIButton            *_hotButton;
    
    NSString            *_newPage;
    NSString            *_hotPage;

}

@end

@implementation MLDiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];

    _newsList = [NSMutableArray array];
    _hotList = [NSMutableArray array];
    _selectStr = newStr;
    _newPage = @"1";
    _hotPage = @"1";

    
    [self addHeadView];
    UICollectionViewFlowLayout *dealLayout = [[UICollectionViewFlowLayout alloc]init];
    dealLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    dealLayout.minimumLineSpacing = 0;
    dealLayout.minimumInteritemSpacing = 0;
    _bigCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, tabHight) collectionViewLayout:dealLayout];
    [_bigCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bigIdentifer];
    
    _bigCollectionView.showsVerticalScrollIndicator = NO;
    _bigCollectionView.showsHorizontalScrollIndicator = NO;
    _bigCollectionView.delegate = self;
    _bigCollectionView.pagingEnabled = YES;
    _bigCollectionView.scrollEnabled = YES;
    _bigCollectionView.dataSource = self;
    _bigCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bigCollectionView];
    
    [self netGetVideoListPageSelectStr:_selectStr pageNumber:_newPage];

}
- (void)addHeadView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, WIDTH-10, 44)];
    NSArray *arr = [NSArray arrayWithObjects:@"最新",@"热门", nil];
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDTH/4*(i+1), 0, WIDTH/4, 38);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = selectButtonTag+i;
        [button addTarget:self action:@selector(choseStyle:) forControlEvents:UIControlEventTouchUpInside];
        CGSize strSize = [NSStringSize getNSStringHeight:@"推荐" Font:15.0];
        if (i == 0) {
            button.selected = YES;
            _newButton = button;
            _downView = [[UIView alloc]initWithFrame:CGRectMake((button.frame.origin.x+(button.frame.size.width-(strSize.width+10))/2), 38, strSize.width+10, 2)];
            [_downView setBackgroundColor:[UIColor whiteColor]];
            [titleView addSubview:_downView];
        } else if (i == 1) {
            button.selected = NO;
            _hotButton = button;
        }
        [titleView addSubview:button];
    }
    self.navigationItem.titleView = titleView;
}
//请求网络接口
- (void)netGetVideoListPageSelectStr:(NSString *)selectStr pageNumber:(NSString *)pageNumber {
    [DiscoverMananger NetGetVideoListVideoType:selectStr token:[_userDefaults objectForKey:@"token"] pageNumber:pageNumber pageSize:@"20" success:^(NSDictionary *info) {
        NSLog(@"---success--%@",info);
        NSMutableArray *muArr = [NSMutableArray array];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
//            NSArray *dataArr = [info objectForKey:@"data"];
//            for (int i = 0; i < dataArr.count; i ++) {
//                NSDictionary *dic = [dataArr objectAtIndex:i];
//                [muArr addObject:dic];
//            }
//
//            if([selectStr isEqualToString:newStr]) {
//                [_newsList addObjectsFromArray:muArr];
//                [_newCollectionView reloadData];
//            } else {
//                [_hotList addObjectsFromArray:muArr];
//                [_hotCollectionView reloadData];
//            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
   
    
}
- (void)choseStyle:(UIButton *)button {
    NSLog(@"---------->>%lu",button.tag);
    if (button.selected == NO) {
        if (button.tag == selectButtonTag) {
            _newButton.selected = YES;
            _hotButton.selected = NO;
            _selectStr = newStr;
            if (_newsList.count > 0) {
                [_newCollectionView reloadData];
            } else {
                _newPage = @"1";
                [self netGetVideoListPageSelectStr:_selectStr pageNumber:_newPage];

            }
            
        } else  {
            _newButton.selected = NO;
            _hotButton.selected = YES;
            _selectStr = hotStr;
            if (_hotList.count > 0) {
                [_hotCollectionView reloadData];
            } else {
                _hotPage = @"1";
                [self netGetVideoListPageSelectStr:_selectStr pageNumber:_hotPage];
            }
            
        }
        CGSize strSize = [NSStringSize getNSStringHeight:@"最新" Font:15.0];
        [UIView animateWithDuration:0.2 animations:^{
            [_downView setFrame:CGRectMake((button.frame.origin.x+(button.frame.size.width-(strSize.width+10))/2), 38, strSize.width+10, 2)];
        }];
        
        _bigCollectionView.contentOffset = CGPointMake((button.tag-selectButtonTag)*WIDTH, 0);
    }
}
#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    
    if ([_selectStr isEqualToString:newStr]) {
        _newPage = page;
        [self netGetVideoListPageSelectStr:_selectStr pageNumber:_newPage];
        //        //获取tableview的数据
        //        [self getHomeVCTableViewDataWithKind:_selectStr andHeader:header andFooter:nil andAnchor:_homeAnchor];
    } else {
        _hotPage = page;
        [self netGetVideoListPageSelectStr:_selectStr pageNumber:_hotPage];
    }
}
#pragma mark - 加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    
    
    NSString *anchor = [NSString string];
    if ([_selectStr isEqualToString:newStr]) {
        anchor = _newPage;
    } else {
        anchor = _hotPage;
    }
    [self netGetVideoListPageSelectStr:_selectStr pageNumber:anchor];
    
    
}
//collection scroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bigCollectionView) {
        
        int index = scrollView.contentOffset.x/scrollView.frame.size.width;
        if (index == 0) {
            [self choseStyle:_newButton];
        } else {
            [self choseStyle:_hotButton];
        }
        
    }
}
//collection section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//collectiion rows
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _bigCollectionView) {
        return 2;
    } else if (collectionView == _newCollectionView) {
        
    } else {
        
    }
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bigCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigIdentifer forIndexPath:indexPath];
        
        for(id subView in cell.contentView.subviews){
            if(subView){
                [subView removeFromSuperview];
            }
        }
        UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc]init];
        UICollectionView *CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0 ,0 ,WIDTH ,tabHight) collectionViewLayout:layou];
       
        CollectionView.backgroundColor =  [UIColor clearColor];//背景色
        CollectionView.delegate = self;//代理
        CollectionView.dataSource = self;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
//        CollectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
        footer.stateLabel.hidden = YES;
        footer.refreshingTitleHidden = YES;
        
//        CollectionView.mj_footer = footer;
        if (indexPath.row == 0) {
            [CollectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:newIdentifer];
            _newCollectionView = CollectionView;
            [cell.contentView addSubview:_newCollectionView];
        } else {
            [CollectionView registerClass:[MLDiscoverListCollectionViewCell class] forCellWithReuseIdentifier:hotIdentifer];
            _hotCollectionView = CollectionView;
            [cell.contentView addSubview:_hotCollectionView];
            
        }
        return cell;
    } else if (collectionView == _newCollectionView) {
        MLDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newIdentifer forIndexPath:indexPath];
        CGSize likeSize = [NSStringSize getNSStringHeight:@"2223" Font:12.0];
        cell.likeNumLabel.frame = CGRectMake(itemWidth-likeSize.width-12, cell.timeLabel.frame.origin.y, likeSize.width, 12);
        cell.iconImageView.frame = CGRectMake(cell.likeNumLabel.frame.origin.x-18, cell.timeLabel.frame.origin.y+1.5, 10, 9);
        cell.mainImgageView.image = [UIImage imageNamed:@"aaa"];
        cell.timeLabel.text = @"12小时";
        cell.messageLabel.text = @"来玩啊啊 ad福建省打客服";
        cell.likeNumLabel.text = @"22";
        return cell;
    } else {
        MLDiscoverListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotIdentifer forIndexPath:indexPath];
        CGSize likeSize = [NSStringSize getNSStringHeight:@"2223" Font:12.0];
        cell.likeNumLabel.frame = CGRectMake(itemWidth-likeSize.width-12, cell.timeLabel.frame.origin.y, likeSize.width, 12);
        cell.iconImageView.frame = CGRectMake(cell.likeNumLabel.frame.origin.x-18, cell.timeLabel.frame.origin.y+1.5, 10, 9);
        cell.mainImgageView.image = [UIImage imageNamed:@"aaa"];
        cell.timeLabel.text = @"12小时";
        cell.messageLabel.text = @"aaaaaaaa";
        cell.likeNumLabel.text = @"22";
        return cell;
    }
    
}

//UICollectionView item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bigCollectionView) {
        return CGSizeMake(WIDTH, tabHight);
    } else {
        return CGSizeMake(itemWidth, itemHeight);
    }
    
}
//UICollectionView  margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (collectionView == _bigCollectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(8, 12, 0, 12);
    }
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _bigCollectionView) {
        return 0;
    } else {
        return 8;
    }
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == _bigCollectionView) {
        return 0;
    } else {
        return 8;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *playController = [[PlayViewController alloc] init];
    [self.navigationController pushViewController:playController animated:YES];
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
