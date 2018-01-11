//
//  AliyunCoverPickViewController.m
//  qusdk
//
//  Created by Worthy on 2017/11/7.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunCoverPickViewController.h"
#import "AliyunPublishTopView.h"
#import "AliyunCoverPickView.h"

#import <VODUpload/VODUploadSVideoClient.h>
#import <sys/utsname.h>

@interface AliyunCoverPickViewController () <AliyunPublishTopViewDelegate, AliyunCoverPickViewDelegate,UITextFieldDelegate,VODUploadSVideoClientDelegate> {
    UIView *_line;
    UILabel *_label;
    NSUserDefaults      *_userDefaults;
}
@property (nonatomic, strong) AliyunPublishTopView *topView;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) AliyunCoverPickView *pickView;
@property (nonatomic, strong) UITextField *titleView;

@property (nonatomic, strong) VODUploadSVideoClient *client;
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation AliyunCoverPickViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _userDefaults = [NSUserDefaults standardUserDefaults];
     [self addNotifications];
    [self setupSubviews];
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.pickView loadThumbnailData];
    });
}

- (void)setupSubviews {
    self.topView = [[AliyunPublishTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight+44)];
    self.topView.nameLabel.text = @"编辑封面";
//    [self.topView.cancelButton setImage:[AliyunImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.topView.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.topView.finishButton setImage:[AliyunImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.topView.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    self.topView.delegate = self;
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
    
    CGFloat pickWith = ScreenWidth - 56;
    CGFloat factor = _outputSize.height/_outputSize.width;
    CGFloat width = ScreenWidth;
    CGFloat heigt = ScreenWidth * factor;
    CGFloat maxheight = ScreenHeight-StatusBarHeight-69-SafeBottom -pickWith/8 - 30;
    
    if(heigt>maxheight){
        heigt = maxheight;
        width = heigt / factor;
    }
    CGFloat offset = (maxheight-heigt)/2;
   
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-(WIDTH*heigt)/HEIGHT)/2, StatusBarHeight+44+offset, (WIDTH*heigt)/HEIGHT, heigt)];
    [self.view addSubview:self.coverView];
    
    
    self.pickView = [[AliyunCoverPickView alloc] initWithFrame:CGRectMake(28, ScreenHeight-SafeBottom -pickWith/8 - 30, pickWith, pickWith/8)];
    self.pickView.delegate = self;
    self.pickView.videoPath = _videoPath;
    self.pickView.outputSize = _outputSize;
   
    [self.view addSubview:self.pickView];
    self.view.backgroundColor = [AliyunIConfig config].backgroundColor;
    
    self.titleView = [[UITextField alloc] initWithFrame:CGRectMake(20, StatusBarHeight+44+ScreenWidth, ScreenWidth-40, 54)];
    self.titleView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请添加视频描述..." attributes:@{NSForegroundColorAttributeName: rgba(188, 190, 197, 1)}];
    self.titleView.tintColor = [AliyunIConfig config].timelineTintColor;;
    self.titleView.textColor = [UIColor whiteColor];
    [self.titleView setFont:[UIFont systemFontOfSize:14]];
    self.titleView.returnKeyType = UIReturnKeyDone;
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [AliyunIConfig config].backgroundColor;
    [self.view addSubview:self.titleView];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(20, _titleView.frame.origin.y+_titleView.frame.size.height-2, ScreenWidth-40, 1)];
    _line.backgroundColor = rgba(90, 98, 120, 1);
    [self.view addSubview:_line];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, _line.frame.origin.y+3, ScreenWidth-40, 14)];
    _label.textColor = rgba(110, 118, 139, 1);
    _label.text = @"最多不超过20个字";
    _label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_label];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, WIDTH-40, 20)];
    _stateLabel.textColor = [UIColor blackColor];
//    _stateLabel.backgroundColor = [UIColor redColor];
    _stateLabel.font = [UIFont systemFontOfSize:14.0];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
//    _stateLabel.hidden = YES;
    [self.view addSubview:_stateLabel];
    
}
#pragma mark - notification

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWillShow:(NSNotification *)note {
   
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
//    if (offset<0) {
        [UIView animateWithDuration:duration animations:^{
            _titleView.frame = CGRectMake(20, HEIGHT-height-80, ScreenWidth, 54);
            _line.frame = CGRectMake(20, _titleView.frame.origin.y+_titleView.frame.size.height-2, ScreenWidth-40, 1);
            _label.frame = CGRectMake(20, _line.frame.origin.y+3, ScreenWidth-40, 14);
            
        }];
//    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        _titleView.frame = CGRectMake(20,StatusBarHeight+44+ScreenWidth, ScreenWidth-40, 54);
        _line.frame = CGRectMake(20, _titleView.frame.origin.y+_titleView.frame.size.height-2, ScreenWidth-40, 1);
        _label.frame = CGRectMake(20, _line.frame.origin.y+3, ScreenWidth-40, 14);
    }];
}
#pragma mark - top view delegate

-(void)cancelButtonClicked {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishButtonClicked {
    _stateLabel.hidden = NO;
    _finishHandler(_coverView.image);
    NSString *coverPath = [_taskPath stringByAppendingPathComponent:@"cover.png"];
    NSData *data = UIImagePNGRepresentation(_coverView.image);
    [data writeToFile:coverPath atomically:YES];
//    NSLog(@"---------------%@",_coverView.image);
    [PublicManager NetGetgetOSSVideoToken:[_userDefaults objectForKey:@"token"] success:^(NSDictionary *info) {
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        NSLog(@"-----%@",info);
        if (resultCode == SUCCESS) {
//                        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
//            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"compileVideo" ofType:@"mp4"];

//            NSLog(@"--------%@--%@",_videoPath,videoPath);
//            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
            NSString *keyId = [[info objectForKey:@"data"] objectForKey:@"AccessKeyId"];
            NSString *AccessKeySecret = [[info objectForKey:@"data"] objectForKey:@"AccessKeySecret"];
            NSString *SecurityToken = [[info objectForKey:@"data"] objectForKey:@"SecurityToken"];
            VodSVideoInfo *info = [VodSVideoInfo new];
            info.title = _titleView.text;
            
            [_client uploadWithVideoPath:_videoPath imagePath:coverPath svideoInfo:info accessKeyId:keyId accessKeySecret:AccessKeySecret accessToken:SecurityToken];
        } else {
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - callback

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"failed:%@",message];
        NSLog(@"------error>>%@",message);
    });
}

-(void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl {
    NSLog(@"wz successvid:%@, imageurl:%@",vid, imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"success:%@",vid];
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        _stateLabel.text = [NSString stringWithFormat:@"%d %%",(int)(uploadedSize * 100/totalSize)];
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

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - pick view delegate

-(void)pickViewDidUpdateImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        _coverView.image = image;
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_titleView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}
@end
