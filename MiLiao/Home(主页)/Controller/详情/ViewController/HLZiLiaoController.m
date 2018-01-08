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
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSMutableArray arrayWithObjects:@"接听率",@"身高",@"体重",@"星座",@"城市", nil];
    
    _messageStr = @"pwiehadshadsgjladfj;ad";
    _itemArr = [NSMutableArray arrayWithObjects:@"身材好",@"身材好",@"体重",@"漂亮",@"漂亮", nil];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT-50-60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;

    
}
//tableview头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    CGSize messageSize = [NSStringSize detailString:_messageStr];
//    ItemsView *itemView = [[ItemsView alloc]init];
//    [itemView setItemsArr:_itemArr];
//
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",messageSize.height+itemView.itemsViewHeight+69+55*5] forKey:@"height"];
//    NSNotification *notification =[NSNotification notificationWithName:@"detailHeight" object:nil userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    return 133;
}

//tableview 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];

    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.4)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];

//    CGSize messageSize = [NSStringSize detailString:_messageStr];
//
//    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, WIDTH-40, messageSize.height)];
//    messageLabel.numberOfLines = 0;
//    messageLabel.font = [UIFont systemFontOfSize:15.0];
//
//    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:_messageStr];
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineSpacing = 4.0;
//    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, _messageStr.length)];
//    [attributeStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0, _messageStr.length)];
//    messageLabel.attributedText = attributeStr;
//
//    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, messageLabel.frame.origin.y+messageLabel.frame.size.height+15, WIDTH, 3)];
//    lineLabel1.backgroundColor = [UIColor lightGrayColor];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIDTH, 18)];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = @"印象标签";
    
    ItemsView *itemView = [[ItemsView alloc]init];
    [itemView setItemsArr:_itemArr];
    itemView.frame = CGRectMake(0, 43, WIDTH, 80);
 
//    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, itemView.frame.origin.y+itemView.frame.size.height+15, WIDTH, 3)];
//    lineLabel2.backgroundColor = [UIColor lightGrayColor];

    headView.frame = CGRectMake(0, 0, WIDTH, itemView.frame.origin.y+80+10+30);
    [headView addSubview:titleLabel];
    [headView addSubview:itemView];
//    [headView addSubview:lineLabel1];
//    [headView addSubview:itemView];
//    [headView addSubview:lineLabel2];
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        MLDetailTableViewCell *cell = nil;
        static NSString *cellID = @"cell.Identifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MLDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = [_data objectAtIndex:indexPath.row];
        cell.messageLabel.text = @"lalalal";
        cell.lineLabel.hidden = NO;
        if (indexPath.row == _data.count-1) {
            cell.lineLabel.hidden = YES;
     
        }
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
