//
//  HLUploadVideoViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/9.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLUploadVideoViewController.h"
#import <VODUpload/VODUploadSVideoClient.h>
#import <sys/utsname.h>

@interface HLUploadVideoViewController ()<VODUploadSVideoClientDelegate> {
    NSUserDefaults      *_userDefaults;
}

@property (nonatomic, strong) VODUploadSVideoClient *client;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation HLUploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 56, 180, 40)];
    _label.textColor = [UIColor blackColor];
    [self.view addSubview:_label];
    
    
    UIButton *upload = [UIButton buttonWithType:UIButtonTypeSystem];
    upload.frame = CGRectMake(100, 100, 44, 44);
    [upload setTitle:@"上传" forState:UIControlStateNormal];
    [upload addTarget:self action:@selector(uploadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upload];
    
    UIButton *pause = [UIButton buttonWithType:UIButtonTypeSystem];
    pause.frame = CGRectMake(100, 150, 44, 44);
    [pause setTitle:@"暂停" forState:UIControlStateNormal];
    [pause addTarget:self action:@selector(pauseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause];
    
    UIButton *resume = [UIButton buttonWithType:UIButtonTypeSystem];
    resume.frame = CGRectMake(100, 200, 44, 44);
    [resume setTitle:@"继续" forState:UIControlStateNormal];
    [resume addTarget:self action:@selector(resumeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resume];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.frame = CGRectMake(100, 250, 44, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self;
    
    [self addBackButton];
}
//返回按钮
- (void)addBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(15, 27, 40, 30);
    [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}
- (void)uploadClicked {
    
    [PublicManager NetGetgetOSSVideoToken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
         NSLog(@"-----%@",info);
        if (resultCode == SUCCESS) {
//            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"compileVideo" ofType:@"mp4"];
            
            NSLog(@"--------%@--%@",_videoPath,videoPath);
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
            NSString *keyId = [[info objectForKey:@"data"] objectForKey:@"AccessKeyId"];
            NSString *AccessKeySecret = [[info objectForKey:@"data"] objectForKey:@"AccessKeySecret"];
            NSString *SecurityToken = [[info objectForKey:@"data"] objectForKey:@"SecurityToken"];
            VodSVideoInfo *info = [VodSVideoInfo new];
            info.title = @"hello test video zhang";
            
            [_client uploadWithVideoPath:_videoPath imagePath:audioPath svideoInfo:info accessKeyId:keyId accessKeySecret:AccessKeySecret accessToken:SecurityToken];
        } else {
            
        }
       
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
//    [self requestSTSWithHandler:^(NSString *keyId, NSString *keySecret, NSString *token, NSString *expireTime, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error.description);
//            return ;
//        }
    
//    }];
}
- (void)pauseClicked {
    [_client pause];
}
- (void)resumeClicked {
    [_client resume];
}
- (void)cancelClicked {
    [_client cancel];
}
- (void)closeClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - callback

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"failed:%@",message];
        NSLog(@"------error>>%@",message);
    });
}

-(void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl {
    NSLog(@"wz successvid:%@, imageurl:%@",vid, imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"success:%@",vid];
    });
}

-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"%d %%",(int)(uploadedSize * 100/totalSize)];
    });
}

-(void)uploadTokenExpired {
    NSLog(@"uploadTokenExpired");
}

-(void)uploadRetry {
    NSLog(@"uploadRetry");
}

-(void)uploadRetryResume {
    NSLog(@"uploadRetryResume");
}

#pragma mark - sts request

- (void)requestSTSWithHandler:(void (^)(NSString *keyId, NSString *keySecret, NSString *token,NSString *expireTime,  NSError * error))handler {
    // 测试用请求地址
    NSString *params = [NSString stringWithFormat:@"BusinessType=vodai&TerminalType=iphone&DeviceModel=%@&UUID=%@&AppVersion=1.0.0", [self getDeviceId], [self getDeviceModel]];
    NSString *testRequestUrl = [NSString stringWithFormat:@"http://106.15.81.230/voddemo/CreateSecurityToken?%@",params];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:testRequestUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            handler(nil,nil,nil,nil, error);
            return ;
        }
        if (data == nil) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            handler(nil,nil,nil,nil, error);
            return;
        }
        NSLog(@"---------------%@",jsonObj);
        NSDictionary *dict = [jsonObj objectForKey:@"SecurityTokenInfo"];
        NSString *keyId = [dict valueForKey:@"AccessKeyId"];
        NSString *keySecret = [dict valueForKey:@"AccessKeySecret"];
        NSString *token = [dict valueForKey:@"SecurityToken"];
        NSString *expireTime = [dict valueForKey:@"Expiration"];
        if (!keyId || !keySecret || !token || !expireTime) {
            NSError *emptyError = [[NSError alloc] initWithDomain:@"Empty Data" code:-10000 userInfo:nil];
            handler(nil,nil,nil,nil, emptyError);
            return ;
        }
        handler(keyId, keySecret, token, expireTime, error);
    }];
    [task resume];
}

- (NSString *)getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString*)getDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}
//返回
- (void)backBarButtonSelect:(UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:nil];
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
