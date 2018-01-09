//
//  IdentificationVController.m
//  MiLiao
//
//  Created by apple on 2018/1/6.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "IdentificationVController.h"
#import "IQActionSheetPickerView.h"
#import "HXProvincialCitiesCountiesPickerview.h"

#import "HXAddressManager.h"
#import "introduceViewController.h"
#import "signViewController.h"
#import "TagViewController.h"
static NSString *kTempFolder = @"touxiang";

@interface IdentificationVController ()<IQActionSheetPickerViewDelegate,UIImagePickerControllerDelegate>
{
    OSSClient * client;
    NSUserDefaults *_userDefaults;
    NSMutableArray *posters;
    NSString *provincename;
    NSString *cityname;
}
@property(nonatomic,strong)NSData *imageData;

@property(nonatomic,strong)NSString *AccessKeyId;
@property(nonatomic,strong)NSString *AccessKeySecret;
@property(nonatomic,strong)NSString *SecurityToken;
//身高
@property (nonatomic, copy) NSString * strM;
@property (nonatomic, copy) NSString * strCM;
//体重
@property (nonatomic, copy) NSString * weighOne;
@property (nonatomic, copy) NSString * weighTwo;

////////
@property(nonatomic,strong)NSString *country;


@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UILabel *hetght;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *star;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *peopleJieshao;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;

@end

@implementation IdentificationVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //设置状态栏为黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //设置导航栏为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"FFFFFF"] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView=[YZNavigationTitleLabel titleLabelWithText:@"编辑认证资料"];
    _userDefaults = [NSUserDefaults standardUserDefaults];
   posters = [[NSMutableArray alloc]init];//图片集合

    [self loData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

   
}
- (void)loData
{
    NSString *token = [_userDefaults objectForKey:@"token"];
    [HLLoginManager NetGetgetOSSToken:token success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"----------------%@",info);
        
        if (resultCode == SUCCESS) {
            
            self.AccessKeyId = info[@"data"][@"AccessKeyId"];
            self.AccessKeySecret = info[@"data"][@"AccessKeySecret"];
            self.SecurityToken = info[@"data"][@"SecurityToken"];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
//提交认证申请
- (IBAction)commit:(id)sender {
    if ([self.country isEqualToString:@"国外"]) {
        [HLLoginManager NetPostupdateV:self.country province:provincename city:provincename constellation:self.star.text description:self.peopleJieshao.text height: self.hetght.text nickName:self.nickName.text personalSign:self.sign.text personalTags:@"1" posters:posters token:[_userDefaults objectForKey:@"token"] weight: self.weight.text success:^(NSDictionary *info) {
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HLLoginManager NetPostupdateV:self.country province:provincename city:cityname constellation:self.star.text description:self.peopleJieshao.text height: self.hetght.text nickName:self.nickName.text personalSign:self.sign.text personalTags:@"1" posters:posters token:[_userDefaults objectForKey:@"token"] weight: self.weight.text success:^(NSDictionary *info) {
            
        } failure:^(NSError *error) {
            
        }];
    }
   
    
}

//上传图片
- (IBAction)photo:(UIButton *)sender {
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
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.AccessKeyId secretKeyId:self.AccessKeySecret securityToken:self.SecurityToken];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"xbkp-nihao";
    NSString *fileName = [NSString stringWithFormat:@"touxiang/%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    put.objectKey = fileName;
    put.uploadingData = self.imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:@"xbkp-nihao"
                                        withObjectKey:fileName];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"%@",result);
            //把图片路径添加到数组
            [posters addObject:result];
            NSLog(@"%@",posters);
//            self.headerUrl = [NSString stringWithFormat:@"%@",result];
//            [_userDefaults setObject:self.headerUrl forKey:@"headUrl"];
//            NSLog(@"------>>>%@",self.headerUrl);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"qqq" object:nil userInfo:nil];
            //            for (NSDictionary * objectInfo in result.contents) {
            //                NSLog(@"list object: %@", objectInfo);
            //            }
            NSLog(@"upload object success!");
            
        }
        else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
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
/**
 *  返回当前时间
 *
 *  @return <#return value description#>
 */
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    NSLog(@"%@", timeNow);
    return timeNow;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//监听滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //手机号
        
    }
    if (indexPath.row == 2) {
        //身高
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        [picker setTag:2];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
//        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"1",@"2"],@[@"00", @"01", @"02", @"03", @"04",@"05", @"06", @"07", @"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99"],@[@"cm"]]];
        [picker show];
    }
      if (indexPath.row == 3) {
          //体重
          IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
          [picker setTag:3];
          picker.toolbarTintColor = [UIColor whiteColor];
          picker.titleColor = [UIColor whiteColor];
          //        picker.titleFont = [UIFont systemFontOfSize:16];
          picker.toolbarButtonColor = [UIColor blackColor];
          [picker setIsRangePickerView:YES];
          [picker setTitlesForComponents:@[@[@"0",@"1",@"2"],@[@"00", @"01", @"02", @"03", @"04",@"05", @"06", @"07", @"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99"],@[@"KG"]]];
          [picker show];
      }
    if (indexPath.row == 4) {
        //星座
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
        [picker setTag:4];
        picker.toolbarTintColor = [UIColor whiteColor];
        picker.titleColor = [UIColor whiteColor];
        //        picker.titleFont = [UIFont systemFontOfSize:16];
        picker.toolbarButtonColor = [UIColor blackColor];
        [picker setIsRangePickerView:YES];
        [picker setTitlesForComponents:@[@[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"]]];
        [picker show];
    }
    if (indexPath.row == 5) {
        NSString *address = @"北京";
        NSArray *array = [address componentsSeparatedByString:@" "];
        
        NSString *province = @"";//省
        NSString *city = @"";//市
        NSString *county = @"";//县
        if (array.count > 2) {
            province = array[0];
            city = array[1];
            county = array[2];
        } else if (array.count > 1) {
            province = array[0];
            city = array[1];
        } else if (array.count > 0) {
            province = array[0];
        }
        [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];

    }
    if (indexPath.row == 6) {
        introduceViewController *intro = [[introduceViewController alloc]init];
        intro.backBlock = ^(NSString *text) {
            self.peopleJieshao.text = text;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
        [self.navigationController pushViewController:intro animated:YES];
    }
    if (indexPath.row == 7) {
        //形象标签
        TagViewController *tag = [[TagViewController alloc]init];
        [self.navigationController pushViewController:tag animated:YES];
    }
    if (indexPath.row == 8) {
        signViewController *sign = [[signViewController alloc]init];
        sign.backBlock = ^(NSString *text) {
            self.sign.text = text;
        };
        [self.navigationController pushViewController:sign animated:YES];
    }
}
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            if ([provinceName isEqualToString:@"国外"]) {
                self.country = @"国外";
                provincename = cityName;
             
                self.city.text = [NSString stringWithFormat:@"%@%@",self.country,cityName];

            }else{
                self.country = @"中国";
                provincename = provinceName;
                cityname = cityName;
                self.city.text = [NSString stringWithFormat:@"%@%@%@",self.country,provinceName,cityName];

            }
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

#pragma mark - IQActionSheetPickerViewDelegate

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSLog(@"%@",titles);
    if (pickerView.tag == 2) {
        self.strM = [titles objectAtIndex:0];
        self.strCM = [titles objectAtIndex:1];

        self.hetght.text = [NSString stringWithFormat:@"%@%@cm", self.strM,self.strCM];
    }
    if (pickerView.tag == 3) {
        self.weighOne = [titles objectAtIndex:0];
        self.weighTwo = [titles objectAtIndex:1];
        self.weight.text = [NSString stringWithFormat:@"%@%@KG", self.weighOne,self.weighTwo];

    }
    if (pickerView.tag == 4) {
        self.star.text = [titles lastObject];

    }
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
@end
