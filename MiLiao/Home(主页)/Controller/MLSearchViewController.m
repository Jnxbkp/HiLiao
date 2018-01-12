//
//  MLSearchViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLSearchViewController.h"
#import "HLSearchTableViewCell.h"

#define searchTabTag        101
#define likeTabTag          102

@interface MLSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    UISearchBar     *_searchBar;
    UITableView     *_searchTableView;
     UITableView    *_likeTableView;
    NSMutableArray  *_sugMuArr;
    NSUserDefaults  *_userDefaults;
    NSMutableArray  *_likeMuArr;
    UIView  *_hisView;
    NSMutableArray *_hisMuArr;
}

@end

@implementation MLSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _sugMuArr = [NSMutableArray array];
    _likeMuArr = [NSMutableArray array];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _hisMuArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:@"historyArr"]];
    
    [self addHisView];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入";
    _searchBar.frame = CGRectMake(10, 22, WIDTH-94, 35);
    _searchBar.layer.cornerRadius = 14.0;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.tintColor = [UIColor blackColor];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(WIDTH-72, 22, 60, 35);
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 6.0;
    cancleButton.backgroundColor = NavColor;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:cancleButton];
    
    _likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_TopHeight, WIDTH  , HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    _likeTableView.tag = likeTabTag;
    _likeTableView.delegate = self;
    _likeTableView.dataSource = self;
    _likeTableView.rowHeight = 90;
    _likeTableView.backgroundColor = [UIColor whiteColor];
    _likeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_likeTableView];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_TopHeight, WIDTH  , HEIGHT-ML_TopHeight) style:UITableViewStylePlain];
    _searchTableView.tag = searchTabTag;
    _searchTableView.delegate = self;
    _searchTableView.hidden = YES;
    _searchTableView.dataSource = self;
    _searchTableView.rowHeight = 90;
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_searchTableView];
    
    
}
- (void)addHisView {
    
    
    
    if (_hisMuArr.count == 0) {
        
    } else {
        _hisView = [[UIView alloc]init];
        _hisView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 20)];
        titleLabel.text = @"历史记录";
        titleLabel.font = [UIFont systemFontOfSize:20.0 weight:0.6];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(WIDTH-72, 0, 60, 30);
        clearButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        clearButton.backgroundColor = [UIColor redColor];
        [clearButton addTarget:self action:@selector(clearButton:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        
        [_hisView addSubview:titleLabel];
        [_hisView addSubview:clearButton];
    }
    
}
//点击清空按钮
- (void)clearButton:(UIButton *)butt {
    [_userDefaults removeObjectForKey:@"historyArr"];
    _hisMuArr = [NSMutableArray array];
    _hisView.hidden = YES;
}
#pragma mark - tableview的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark  tablecell每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
    if (tableView.tag == likeTabTag) {
        return 5;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == likeTabTag) {
        return 10;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    if (tableView.tag == likeTabTag) {
        
    }
    return headView;
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
    if (tableView.tag == likeTabTag) {
        
    } else {
        
    }
    
}
- (void)cancleClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
   
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
