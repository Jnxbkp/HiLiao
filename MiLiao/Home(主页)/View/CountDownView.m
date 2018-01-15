//
//  CountDownView.m
//  MiLiao
//
//  Created by King on 2018/1/15.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "CountDownView.h"


@interface CountDownView ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) dispatch_source_t timer;
@end

static NSInteger CountDownTime = 5 * 60;


@implementation CountDownView
{
    ButtonClickBlock _clickBlock;
}
//充值点击
- (IBAction)payButtonClick:(id)sender {
    !_clickBlock?:_clickBlock();
    
    if ([self.delegate respondsToSelector:@selector(payAction)]) {
        [self.delegate payAction];
    }
    
}

///充值的回调
- (void)payAction:(ButtonClickBlock)click {
    _clickBlock = click;
}

+ (instancetype)CountDownView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.frame = CGRectMake(0, 0, 120, 40);
    self.label.text = [self showTime:CountDownTime];
//    self.hidden = YES;
}


//返回剩余时间数
- (NSString *)showTime:(NSInteger)time {
    NSInteger minu = time / 60;
    NSInteger second = time % 60;
    NSString *string = [NSString stringWithFormat:@"%ld:%02ld", minu, second];
    NSLog(@"剩余可通话时间:\n%@", string);
    return string;
}

///重置
- (void)reset {
    CountDownTime = 5 * 60;
    self.hidden = YES;
}

///开始倒计时
- (void)startCountDowun {
    
    self.hidden = NO;
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        CountDownTime--;
        if (CountDownTime <= 0) {
            //通话结束
            if ([self.delegate respondsToSelector:@selector(callEnd)]) {
                [self.delegate callEnd];
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = [self showTime:CountDownTime];
            });
            
        }
    });
    dispatch_resume(self.timer);
}

@end
