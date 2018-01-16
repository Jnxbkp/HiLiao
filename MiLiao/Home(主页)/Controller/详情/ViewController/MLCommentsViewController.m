//
//  testViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLCommentsViewController.h"
#import "CommentTableViewCell.h"
#import "MainMananger.h"


@interface MLCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (strong, nonatomic) NSMutableArray *dataArr;


@end

@implementation MLCommentsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---%@",self.title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSMutableArray array];
//    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"接听率",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市",@"身高",@"体重",@"星座",@"城市", nil];
    
    [self NetGetBigVEvaluationList];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-ML_TopHeight-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.bounces = NO;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    _tableView.mj_footer = footer;
    
    [self.view addSubview:_tableView];
    //    __weak typeof(self) weakSelf = self;
    //    [self.tableView addInfiniteScrollingWithActionHandler:^{
    //        [weakSelf insertRowAtBottom];
    //    }];
}

//主播评论列表
- (void)NetGetBigVEvaluationList {
    [MainMananger NetGetBigVEvaluationListUsername:_videoUserModel.username success:^(NSDictionary *info) {
        NSLog(@"---------------->>><<<<<>>><<<>>%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        if (resultCode == SUCCESS) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.titleLabel.text = [self.data objectAtIndex:indexPath.row];
//    NSArray *arr = [NSArray arrayWithObjects:@"好性感",@"完美身材", nil];
//    [cell.itemsView setItemsArr:arr];
//    cell.userImageView.image = [UIImage imageNamed:@"aaa"];
//    cell.itemsView.frame = CGRectMake(WIDTH/2 + WIDTH/2-12-cell.itemsView.itemsViewWidth, 12, cell.itemsView.itemsViewWidth, 24);
    
//    if (indexPath.row == self.data.count-1) {
//        cell.lineLabel.hidden = YES;
//    }
    return cell;
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
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}

#pragma mark LazyLoad

+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
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
