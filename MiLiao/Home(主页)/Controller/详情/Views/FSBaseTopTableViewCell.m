//
//  FSBaseTopTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseTopTableViewCell.h"

#define buttonTag   2000
@interface FSBaseTopTableViewCell ()

@end
@implementation FSBaseTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addHeadView];
       
    }
    return self;
}
//上方视图
- (void)addHeadView {

    //    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _backButton.frame = CGRectMake(15, 27, 40, 30);
    //    [_backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    //    [_backButton addTarget:self action:@selector(backBarButtonSelect:) forControlEvents:UIControlEventTouchUpInside];

    _loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) isHorizontal:YES];
//    _loopView.imgResourceArr = @[@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg",
//                                @"http://img06.tooopen.com/images/20161123/tooopen_sy_187628854311.jpg",
//                                @"http://img07.tooopen.com/images/20170306/tooopen_sy_200775896618.jpg",
//                                @"http://img06.tooopen.com/images/20170224/tooopen_sy_199503612842.jpg",
//                                @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"];
    
    
    
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateButton.backgroundColor = [UIColor greenColor];
    [_stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_stateButton setTitle:@"在线" forState:UIControlStateNormal];
    _stateButton.frame = CGRectMake(WIDTH-52, 32, 40, 20);
    _stateButton.layer.cornerRadius = 9.0;
    _stateButton.titleLabel.font = [UIFont systemFontOfSize:12.0];

    

//    UIView *belowView = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH*0.76-60, WIDTH, 60)];
//    belowView.backgroundColor = [UIColor blackColor];
//    belowView.alpha = 0.3;

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, WIDTH-68, (WIDTH-24)/2, 20)];
    _nameLabel.textColor = ML_Color(255, 255, 255, 1);
    _nameLabel.text = @"认证名称";
    _nameLabel.font = [UIFont systemFontOfSize:20.0];

    _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton.backgroundColor = ML_Color(255, 255, 255, 0.7);
    [_focusButton setTitleColor:ML_Color(250, 114, 152, 1) forState:UIControlStateNormal];
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    _focusButton.frame = CGRectMake(WIDTH-76, _nameLabel.frame.origin.y, 64, 20);
    _focusButton.layer.cornerRadius = 9.0;
    [_focusButton addTarget:self action:@selector(selectFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    _focusButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _nameLabel.frame.origin.y+32, WIDTH-24, 1)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, lineLabel.frame.origin.y+13, WIDTH-24, 13)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"个人形象标签";
    _messageLabel.font = [UIFont systemFontOfSize:13.0];

    _numFocusLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-24)/2+22, _nameLabel.frame.origin.y+5, WIDTH-((WIDTH-24)/2+22)-88, 10)];
    _numFocusLabel.textColor = [UIColor whiteColor];
    _numFocusLabel.font = [UIFont systemFontOfSize:10.0];
    _numFocusLabel.textAlignment = NSTextAlignmentRight;
    _numFocusLabel.text = [NSString stringWithFormat:@"23984关注"];

    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDTH+150, WIDTH, 8)];
    downLabel.backgroundColor = Color242;
    
    
    [self addSubview:_loopView];
    [self addSubview:_stateButton];
    [self addSubview:_focusButton];
    [self addSubview:_nameLabel];
    [self addSubview:_messageLabel];
    [self addSubview:_numFocusLabel];
    [self addSubview:lineLabel];
    [self addSubview:downLabel];
   
    NSArray *arr = [NSArray arrayWithObjects:@"与我视频聊天需要支付:",@"与我亲密的:",@"微信号:", nil];
    for (int i = 0; i < arr.count ; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, WIDTH+18+50*i, 150, 14)];
        label.textColor = Color75;
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = arr[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, WIDTH+50*i, WIDTH, 50);
        button.tag = buttonTag+i;
        [button addTarget:self action:@selector(mindButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.origin.y+50, WIDTH, 0.3)];
        lineLabel.backgroundColor = Color242;
        if (i == 0) {
            _priceView = [[PriceView alloc]initWithFrame:CGRectMake(12+label.frame.size.width+10, label.frame.origin.y-0.5, WIDTH-(12+label.frame.size.width+10)-12, 15) withPrice:@" " kind:@""];
            [self addSubview:_priceView];
            [self addSubview:lineLabel];
            
        } else if (i == 1) {
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-25, button.frame.origin.y+16, 13, 18)];
            iconImageView.image = [UIImage imageNamed:@"BackArrow"];
            for (int i = 0; i < _headImageArr.count; i ++) {
                if (i <= 2) {
                    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70-(44*i), button.frame.origin.y+9, 32, 32)];
                    headImage.image = [UIImage imageNamed:@"aaa"];
                    headImage.layer.cornerRadius = 16;
                    [self addSubview:headImage];
                }
                
            }
            [self addSubview:iconImageView];
            [self addSubview:lineLabel];
        } else {
            _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, button.frame.origin.y+18, WIDTH/2-12, 14)];
            _weixinLabel.text = @"点击获取";
            _weixinLabel.textColor = NavColor;
            _weixinLabel.textAlignment = NSTextAlignmentRight;
            _weixinLabel.font = [UIFont systemFontOfSize:14.0];
             [self addSubview:_weixinLabel];
        }
        [self addSubview:label];
        [self addSubview:button];
        
    }

}
- (void)selectFocusButton:(UIButton *)button {
    NSLog(@"selectFocus");
}
- (void)mindButtonSelect:(UIButton *)button {
    NSLog(@"select");
}
//- (void)backBarButtonSelect:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
