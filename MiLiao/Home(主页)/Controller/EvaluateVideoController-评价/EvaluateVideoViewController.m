//
//  EvaluateVideoViewController.m
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "EvaluateVideoViewController.h"
#import "TagLabel.h"
#import "EvaluateTagModel.h"
#import "UserInfoNet.h"


@interface EvaluateVideoViewController ()

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (nonatomic, strong) NSArray *tagModelArray;
@property (nonatomic, strong) NSArray<TagLabel *> *tagLabelArray;
@end

@implementation EvaluateVideoViewController

- (void)setTagModelArray:(NSArray *)tagModelArray {
    _tagModelArray = tagModelArray;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (EvaluateTagModel *tag in tagModelArray) {
        TagLabel *label = [[TagLabel alloc] init];
        label.evaluateTag = tag;
        [mutableArray addObject:label];
        [self.tagView addSubview:label];
    }
    self.tagLabelArray = [mutableArray copy];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat margin = 10.0;
    NSInteger j = 0;
    CGFloat x = margin;
    for (NSInteger i = 0; i < self.tagLabelArray.count; i++) {
        TagLabel *label = self.tagLabelArray[i];
        [label sizeToFit];
        CGFloat width = label.width +15;
        if (i >= 1) {
            TagLabel *prelabel = self.tagLabelArray[i-1];
            x = CGRectGetMaxX(prelabel.frame) + margin;
            if (x + CGRectGetMaxX(label.frame) + margin > self.tagView.width) {
                x = margin;
                j++;
            }
        }
        CGFloat y = margin * (j+1) + j*30;
        
        label.frame = CGRectMake(x, y, width, 30);
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UserInfoNet getEvaluate:^(RequestState success, NSArray *modelArray, NSInteger code, NSString *msg) {
        if (success) {
            self.tagModelArray = modelArray;
        }
    }];
    // Do any additional setup after loading the view from its nib.
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
