//
//  edttViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "edttViewController.h"
#define iconImageWH 60

@interface edttViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UITableView * tableView;
@property(nonatomic,strong)UIButton *LogoutButton;

//用户头像
@property(nonatomic,strong)UIImageView *iconImage;
@end

@implementation edttViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"编辑资料"];
    [self setCustomView];
    //初始化尾部视图
    [self setupFootView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
//初始化尾部视图
-(void)setupFootView
{
    UIView *footView=[UIView new];
    footView.frame=CGRectMake(0, 0, WIDTH, 130);
//    footView.backgroundColor = [UIColor grayColor];
    self.LogoutButton=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, WIDTH-100, 40)];
    self.LogoutButton.backgroundColor=[UIColor redColor];
    self.LogoutButton.layer.masksToBounds=YES;
    self.LogoutButton.layer.cornerRadius=5.0;
    [self.LogoutButton addTarget:self action:@selector(LogoutButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.LogoutButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [footView addSubview:self.LogoutButton];
    self.tableView.tableFooterView=footView;

}

- (void)setCustomView{
    UITableView * tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellID=@"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier: cellID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.text=@"头像";
            self.iconImage=[[UIImageView alloc] init];
            // store_img
//            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[YZCurrentUserModel sharedYZCurrentUserModel].store_img] placeholderImage:[UIImage imageNamed:@"my_head_icon"] options:SDWebImageRefreshCached];
            [cell.contentView addSubview:self.iconImage];
            self.iconImage.sd_layout
            .centerYIs(85 / 2)
            .rightSpaceToView(cell.contentView, 10)
            .widthIs(iconImageWH)
            .heightIs(iconImageWH);
        }
        return cell;
    }else{
        static NSString *cellID=@"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier: cellID];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        //第一个分区
       cell.textLabel.text=@"昵称";
//       cell.detailTextLabel.text=[YZCurrentUserModel sharedYZCurrentUserModel].store_name;
        
        return cell;
    }
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 85;
        
    }
    
    return 47;
    
}
@end
