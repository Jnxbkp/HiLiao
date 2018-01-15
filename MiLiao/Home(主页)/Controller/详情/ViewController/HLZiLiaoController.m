//
//  xiangViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLZiLiaoController.h"
#import "MLDetailTableViewCell.h"



@interface HLZiLiaoController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, assign) BOOL fingerIsTouch;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, strong) NSString          *messageStr;
@property (nonatomic, strong) NSMutableArray    *itemArr;
@property (nonatomic, strong) NSMutableArray    *itemArr1;
@end

@implementation HLZiLiaoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---%@",self.title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //get love num
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWomanData:) name:@"getWomanInformation" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市", nil];
    
    _messageStr = @"pwiehadshadsgjladfj;ad";
    _itemArr = [NSMutableArray arrayWithObjects:@"完美身材",@"身好", nil];
    _itemArr1 = [NSMutableArray arrayWithObjects:@"完美身材",@"漂亮",@"身材好", nil];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.scrollsToTop = NO;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.data.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 82;
    } else {
        return 38;
    }
    
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 48;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}
//tableview 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, WIDTH-24, 14)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = Color75;
    if (section == 0) {
        titleLabel.text = @"印象标签";
    } else {
        titleLabel.text = @"个人资料";
    }
    
    [headView addSubview:titleLabel];
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = nil;
        static NSString *cellID = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        for(id subView in cell.contentView.subviews){
            if(subView){
                [subView removeFromSuperview];
            }
        }
        
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 6, 60, 12)];
        myLabel.text = @"自评形象";
        myLabel.textColor = ML_Color(127, 127, 127, 1);
        myLabel.font = [UIFont systemFontOfSize:13.0];
        
        UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 42, 60, 12)];
        userLabel.text = @"用户形象";
        userLabel.textColor = ML_Color(127, 127, 127, 1);
        userLabel.font = [UIFont systemFontOfSize:13.0];
        
        ItemsView *itemView = [[ItemsView alloc]init];
        [itemView setItemsArr:_itemArr];
        itemView.frame = CGRectMake(WIDTH-itemView.itemsViewWidth-12, 0, itemView.itemsViewWidth, 24);
        
        ItemsView *itemView1 = [[ItemsView alloc]init];
        [itemView1 setItemsArr:_itemArr1];
        itemView1.frame = CGRectMake(WIDTH-itemView1.itemsViewWidth-12, 36, itemView1.itemsViewWidth, 24);
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 74, WIDTH, 8)];
        lineLabel.backgroundColor = Color242;
        
        [cell.contentView addSubview:myLabel];
        [cell.contentView addSubview:userLabel];
        [cell.contentView addSubview:itemView];
        [cell.contentView addSubview:itemView1];
        [cell.contentView addSubview:lineLabel];
        
        return cell;
        
    } else {
        MLDetailTableViewCell *cell = nil;
        static NSString *cellID = @"cell.Identifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MLDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [_data objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.messageLabel.text = @"98%";
        } else if (indexPath.row == 1) {
            cell.messageLabel.text = _womanModel.height;
        } else if (indexPath.row == 2) {
            cell.messageLabel.text = _womanModel.weight;
        } else if (indexPath.row == 3) {
            cell.messageLabel.text = _womanModel.constellation;
        } else {
            cell.messageLabel.text = _womanModel.city;
        }
        
        return cell;
    }
    
}
#pragma mark - 通知得到主播数据
- (void)notificationWomanData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    _womanModel = [dic objectForKey:@"womanModel"];
    [self.tableView reloadData];
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
    NSLog(@"1111111");
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

- (NSMutableArray *)data
{
    if (!_data) {
        self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市", nil];
        //        for (int i = 0; i<10; i++) {
        //            [self.data addObject:RandomData];
        //        }
    }
    return _data;
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
