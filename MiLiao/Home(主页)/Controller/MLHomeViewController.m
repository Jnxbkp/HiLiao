//
//  MLHomeViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLSearchViewController.h"
#import "MLHomeListTableViewCell.h"
#import "MainMananger.h"
#import "FSBaseViewController.h"

#define choseButtonTag          1000
#define tabHight   HEIGHT-ML_TopHeight-35-ML_TabBarHeight

#define newStr                     @"new"
#define careStr                    @"care"
#define recommandStr               @"recommand"
#define page                       @"1"

static NSString *const bigIdentifer = @"bigCell";
@interface MLHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    
    NSUserDefaults      *_userDefaults;
    UICollectionView    *_bigCollectionView;
    UITableView         *_newTabelView;
    UITableView         *_careTabelView;
    UITableView         *_recommandTabelView;
    NSMutableArray      *_recommandList;
    NSMutableArray      *_careList;
    NSMutableArray      *_newsList;
    UIView              *_downView;
    
    NSString            *_selectStr;
    UIView              *_choseView;
    UIButton            *_newButton;
    UIButton            *_recommandButton;
    UIButton            *_careButton;
    
    NSString            *_newPage;
    NSString            *_carePage;
    NSString            *_recommandPage;
    
}

@end

@implementation MLHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, WIDTH-10, 44)];
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateNormal];
    [searchBut setBackgroundImage:[UIImage imageNamed:@"sousuokuang"] forState:UIControlStateHighlighted];
    searchBut.frame = CGRectMake(19, 10, WIDTH-48, 28);
    
    [searchBut addTarget:self action:@selector(pushSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBut];
    self.navigationItem.titleView = titleView;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _careList = [NSMutableArray array];
    _newsList = [NSMutableArray array];
    _recommandList = [NSMutableArray array];
    _selectStr = recommandStr;
    _newPage = @"1";
    _carePage = @"1";
    _recommandPage = @"1";
    
    [self addTableChoseView];
    
    UICollectionViewFlowLayout *dealLayout = [[UICollectionViewFlowLayout alloc]init];
    dealLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    dealLayout.minimumLineSpacing = 0;
    dealLayout.minimumInteritemSpacing = 0;
    _bigCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, tabHight) collectionViewLayout:dealLayout];
    [_bigCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bigIdentifer];
    
    _bigCollectionView.showsVerticalScrollIndicator = NO;
    _bigCollectionView.showsHorizontalScrollIndicator = NO;
    _bigCollectionView.delegate = self;
    _bigCollectionView.pagingEnabled = YES;
    _bigCollectionView.scrollEnabled = YES;
    _bigCollectionView.dataSource = self;
    _bigCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bigCollectionView];
  
    [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage];
}
//table选择视图
- (void)addTableChoseView {
    _choseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    _choseView.backgroundColor = [UIColor whiteColor];
    _choseView.userInteractionEnabled = YES;
    NSArray *arr = [NSArray arrayWithObjects:@"推荐",@"关注",@"新人", nil];
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDTH/3*i, 0, WIDTH/3, 33);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateSelected];
        [button setTitleColor:ML_Color(77, 77, 77, 1) forState:UIControlStateNormal];
        [button setTitleColor:NavColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = choseButtonTag+i;
        [button addTarget:self action:@selector(choseStyle:) forControlEvents:UIControlEventTouchUpInside];
        CGSize strSize = [NSStringSize getNSStringHeight:@"推荐" Font:15.0];
        if (i == 0) {
            button.selected = YES;
            _recommandButton = button;
            _downView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH/3-(strSize.width+20))/2, 33, strSize.width+20, 2)];
            [_downView setBackgroundColor:NavColor];
            [_choseView addSubview:_downView];
        } else if (i == 1) {
            button.selected = NO;
            _careButton = button;
        } else if (i == 2) {
            button.selected = NO;
            _newButton = button;
        }
        [_choseView addSubview:button];
    }
    [self.view addSubview:_choseView];
}
#pragma mark - 选择种类列表
- (void)choseStyle:(UIButton *)button {
    if (button.selected == NO) {
        
        if (button.tag == choseButtonTag) {
            _recommandButton.selected = YES;
            _newButton.selected = NO;
            _careButton.selected = NO;
            _selectStr = recommandStr;
            if (_recommandList.count > 0) {
                [self recommandTabReload];
            } else {
                _recommandPage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage];
            }
            
        } else if (button.tag == choseButtonTag+1) {
            _recommandButton.selected = NO;
            _careButton.selected = YES;
            _newButton.selected = NO;
            
            _selectStr = careStr;
            if (_careList.count > 0) {
                [self careTabReload];
            } else {
                _carePage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_carePage];
            }
            
        } else if (button.tag == choseButtonTag+2) {
            _recommandButton.selected = NO;
            _careButton.selected = NO;
            _newButton.selected = YES;
            
            _selectStr = newStr;
            if (_careList.count > 0) {
                [self newTabReload];
            } else {
                _newPage = @"1";
                [self netGetListPageSelectStr:_selectStr pageNumber:_newPage];
            }
        }
        CGSize strSize = [NSStringSize getNSStringHeight:@"推荐" Font:15.0];
        [UIView animateWithDuration:0.2 animations:^{
            [_downView setFrame:CGRectMake(button.frame.origin.x+(WIDTH/3-(strSize.width+20))/2, 33, strSize.width+20, 2)];
        }];
        _bigCollectionView.contentOffset = CGPointMake((button.tag-choseButtonTag)*WIDTH, 0);
    }
    
}
//请求网络接口
- (void)netGetListPageSelectStr:(NSString *)selectStr pageNumber:(NSString *)pageNumber {
    [MainMananger NetGetMainListKind:selectStr token:[_userDefaults objectForKey:@"token"] pageNumber:pageNumber pageSize:@"10" success:^(NSDictionary *info) {
        NSLog(@"---success--%@",info);
        NSMutableArray *muArr = [NSMutableArray array];
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            NSArray *dataArr = [info objectForKey:@"data"];
            for (int i = 0; i < dataArr.count; i ++) {
                NSDictionary *dic = [dataArr objectAtIndex:i];
                [muArr addObject:dic];
            }
            
            if([selectStr isEqualToString:newStr]) {
                [_newsList addObjectsFromArray:muArr];
                [self newTabReload];
            } else if ([selectStr isEqualToString:careStr]) {
                [_careList addObjectsFromArray:muArr];
                [self careTabReload];
            } else {
                [_recommandList addObjectsFromArray:muArr];
                [self recommandTabReload];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}

#pragma mark refresh
- (void)headerRefreshing:(MJRefreshNormalHeader *)header {
    
    if ([_selectStr isEqualToString:newStr]) {
        _newPage = page;
        [self netGetListPageSelectStr:_selectStr pageNumber:_newPage];
//        //获取tableview的数据
//        [self getHomeVCTableViewDataWithKind:_selectStr andHeader:header andFooter:nil andAnchor:_homeAnchor];
    } else if ([_selectStr isEqualToString:careStr]) {
        _carePage = page;
        [self netGetListPageSelectStr:_selectStr pageNumber:_carePage];
    } else {
        _recommandPage = page;
        [self netGetListPageSelectStr:_selectStr pageNumber:_recommandPage];
    }
}
#pragma mark - 加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    
    
    NSString *anchor = [NSString string];
    if ([_selectStr isEqualToString:newStr]) {
        anchor = _newPage;
    } else if ([_selectStr isEqualToString:careStr]) {
        anchor = _carePage;
    } else {
        anchor = _recommandPage;
    }
    [self netGetListPageSelectStr:_selectStr pageNumber:anchor];
    

}
//collection section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//collectiion rows
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigIdentifer forIndexPath:indexPath];
        
    for(id subView in cell.contentView.subviews){
        if(subView){
            [subView removeFromSuperview];
        }
    }
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, tabHight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = WIDTH-16;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;

    tableView.mj_footer = footer;
    if (indexPath.row == 0) {
        _recommandTabelView = tableView;
        [cell.contentView addSubview:_recommandTabelView];
    } else if (indexPath.row == 1) {
        _careTabelView = tableView;
        [cell.contentView addSubview:_careTabelView];

    } else {
        _newTabelView = tableView;
        [cell.contentView addSubview:_newTabelView];

    }
    return cell;
}

//UICollectionView item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH, tabHight);
}
//UICollectionView  margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
#pragma mark - tableview的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark  tablecell每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
    if (tableView == _newTabelView) {
//        return _newsList.count;
        return 1;
    } else if (tableView == _careTabelView) {
        return _careList.count;
    } else {
        return _recommandList.count;
    }
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
//tableview尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark 添加tabelcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLHomeListTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MLHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *muArr = [NSMutableArray array];
    if(tableView == _newTabelView) {
        muArr = _newsList;
    } else if (tableView == _careTabelView) {
        muArr = _careList;
    } else {
        muArr = _recommandList;
    }
    
    [cell.stateButton setTitle:@"在线" forState:UIControlStateNormal];
//    [cell.mainImgageView sd_setImageWithURL:[NSURL URLWithString:[[muArr objectAtIndex:indexPath.row] objectForKey:@"posterUrl"]] placeholderImage:nil];
    cell.mainImgageView.image = [UIImage imageNamed:@"aaa"];
    cell.nameLabel.text = [[muArr objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.messageLabel.text = [[muArr objectAtIndex:indexPath.row] objectForKey:@"personalSign"];
    [cell.priceView setPrice:[[muArr objectAtIndex:indexPath.row] objectForKey:@"price"]];
    
    return cell;
    
}
#pragma mark 点击tablecell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSBaseViewController *baseVC = [[FSBaseViewController alloc]init];
    if (tableView == _newTabelView) {
        
    } else if (tableView == _careTabelView) {
        
    } else {
        
    }
    [self.navigationController pushViewController:baseVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bigCollectionView) {
        
        int index = scrollView.contentOffset.x/scrollView.frame.size.width;
        NSLog(@"------------>>>%d",index);
        [self choseStyle:(UIButton *)[self.view viewWithTag:choseButtonTag+index]];
    }
}

//跳转搜索页
- (void)pushSearchVC:(UIButton *)button {
    MLSearchViewController *searchVC = [[MLSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)recommandTabReload {
    [UIView performWithoutAnimation:^{
        [_recommandTabelView reloadData];
        [_recommandTabelView beginUpdates];
        [_recommandTabelView endUpdates];
    }];
}
- (void)newTabReload {
    [UIView performWithoutAnimation:^{
        [_newTabelView reloadData];
        [_newTabelView beginUpdates];
        [_newTabelView endUpdates];
    }];
}
- (void)careTabReload {
    [UIView performWithoutAnimation:^{
        [_careTabelView reloadData];
        [_careTabelView beginUpdates];
        [_careTabelView endUpdates];
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
