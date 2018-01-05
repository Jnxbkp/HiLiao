//
//  edttViewController.m
//  MiLiao
//
//  Created by apple on 2018/1/4.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "edttViewController.h"
#import "OSSImageUploader.h"

#define iconImageWH 60
NSString * const AccessKey = @"－－－－－－－－－";
NSString * const SecretKey = @"－－－－－－－－－";
NSString * const securityToken = @"－－－－－－－－－";
static NSString *kTempFolder = @"temp";

@interface edttViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
{
    OSSClient * client;
}
@property (nonatomic, weak)UITableView * tableView;
@property(nonatomic,strong)UIButton *LogoutButton;

//用户头像
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)NSData *imageData;

//@property(nonatomic,strong)NSString *AccessKey;
//@property(nonatomic,strong)NSString *SecretKey;
//@property(nonatomic,strong)NSString *securityToken;

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
    if (indexPath.row == 0) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍  照"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，您的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
                return;
            }
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
            [controller setAllowsEditing:YES];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *controller = [[UIImagePickerController alloc]init];
            [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [controller setAllowsEditing:YES];
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *avatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(avatar)) {
        //返回为png图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        self.imageData = UIImagePNGRepresentation(imagenew);
    }else {
        //返回为JPEG图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        self.imageData = UIImageJPEGRepresentation(imagenew, 0.1);
    }
    
// 参数设置
    NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
   id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"AccessKeyId" secretKeyId:@"AccessKeySecret" securityToken:@"SecurityToken"];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"xbkp-nihao";
    NSString *imageName = [kTempFolder stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
    put.objectKey = imageName;
    put.uploadingData = self.imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:@"xbkp-nihao"
                                        withObjectKey:imageName];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            
            NSLog(@"upload object success!");
            
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
//    [self uploadImage:avatar];
}
- (void)uploadImage:(UIImage*)image {
    
}
/**
 *  压缩图片尺寸
 *
 *  @param image   图片
 *  @param newSize 大小
 *
 *  @return 真实图片
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
