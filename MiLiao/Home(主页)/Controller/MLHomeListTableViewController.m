//
//  MLHomeListTableViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeListTableViewController.h"
#import "MLHomeListTableViewCell.h"
#import "FSBaseViewController.h"


@interface MLHomeListTableViewController ()

@property (nonatomic, strong) NSMutableArray *newsList;

@end

@implementation MLHomeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.scrollsToTop = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, VTTABBAR_HEIGHT, 0);
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    self.tableView.rowHeight = WIDTH*0.76;
    
    [self fetchNewsData];
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    VTPRINT_METHOD
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tableView.scrollsToTop = YES;
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.scrollsToTop = NO;
    VTPRINT_METHOD
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    VTPRINT_METHOD
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLHomeListTableViewCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MLHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.stateButton setTitle:@"在线" forState:UIControlStateNormal];
    cell.nameLabel.text = @"小么么";
    cell.messageLabel.text = @"阿炳儿科蛮舒服。";
    [cell.priceView setPrice:@"20"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSBaseViewController *detailViewController = [[FSBaseViewController alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.tableView setContentOffset:CGPointZero];
}

#pragma mark - functional methods
- (void)fetchNewsData {
    
    _newsList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 5; index++) {
        [_newsList addObject:[NSString stringWithFormat:@"新闻%ld", (long)index]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
