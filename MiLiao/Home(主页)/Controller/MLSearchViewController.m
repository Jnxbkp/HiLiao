//
//  MLSearchViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLSearchViewController.h"
#import "HLSearchTableViewCell.h"

@interface MLSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    UISearchBar     *_searchBar;
    UITableView     *_searchTableView;
    UITableView     *_tableView;
    NSMutableArray  *_sugMuArr;
}

@end

@implementation MLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _sugMuArr = [NSMutableArray array];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入你想搜索的名字";
    _searchBar.frame = CGRectMake(0, 22, WIDTH-60, 35);
    _searchBar.layer.cornerRadius = 14.0;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.tintColor = [UIColor blackColor];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(WIDTH-50, 22, 40, 35);
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:cancleButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH  , HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
#pragma mark - tableview的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark  tablecell每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
//    return _sugMuArr.count;
    return 10;
}

#pragma mark 添加tabelcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    HLSearchTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HLSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.headImageView.image = [UIImage imageNamed:@"aaa"];
    cell.nameLabel.text = @"大范围";
    cell.messageLabel.text = @"拉单是拉萨快递发";
    
    return cell;
}
#pragma mark 点击tablecell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)cancleClick:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:^{
        
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
