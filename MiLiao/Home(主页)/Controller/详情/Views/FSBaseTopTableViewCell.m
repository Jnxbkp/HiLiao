//
//  FSBaseTopTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseTopTableViewCell.h"
#import "FSLoopScrollView.h"

@interface FSBaseTopTableViewCell ()

@end
@implementation FSBaseTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        FSLoopScrollView *loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.76) isHorizontal:YES];
        loopView.imgResourceArr = @[@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg",
                                    @"http://img06.tooopen.com/images/20161123/tooopen_sy_187628854311.jpg",
                                    @"http://img07.tooopen.com/images/20170306/tooopen_sy_200775896618.jpg",
                                    @"http://img06.tooopen.com/images/20170224/tooopen_sy_199503612842.jpg",
                                    @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"];
        
        
        [self addSubview:loopView];
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
   

    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateButton.backgroundColor = [UIColor greenColor];
    [_stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_stateButton setTitle:@"在线" forState:UIControlStateNormal];
    _stateButton.frame = CGRectMake(WIDTH-50, 20, 40, 20);
    _stateButton.layer.cornerRadius = 8.0;
    _stateButton.titleLabel.font = [UIFont systemFontOfSize:12.0];

    _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton.backgroundColor = NavColor;
    [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    _focusButton.frame = CGRectMake(WIDTH-100, WIDTH*0.76-75, 80, 30);
    _focusButton.layer.cornerRadius = 8.0;
    _focusButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    UIView *belowView = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH*0.76-60, WIDTH, 60)];
    belowView.backgroundColor = [UIColor blackColor];
    belowView.alpha = 0.3;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, WIDTH*0.76-50, WIDTH, 20)];
    nameLabel.textColor = NavColor;
    nameLabel.text = @"奥迪女鞋";
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, nameLabel.frame.origin.y+25, (WIDTH-50)*2/3, 15)];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = @"阿拉丁开放男直接发离得近";
    messageLabel.font = [UIFont systemFontOfSize:14.0];
    
    UILabel *numPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*2, nameLabel.frame.origin.y+25, WIDTH/3, 15)];
    numPeopleLabel.textColor = [UIColor whiteColor];
    numPeopleLabel.font = [UIFont systemFontOfSize:14.0];
    numPeopleLabel.text = [NSString stringWithFormat:@"23984粉丝"];
    
    UILabel *zhifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, WIDTH*0.76+15, (WIDTH-50)*2/3, 15)];
    zhifuLabel.text = @"与我视频聊天需要支付:";
    zhifuLabel.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, zhifuLabel.frame.origin.y+30, WIDTH, 5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    _priceView = [[PriceView alloc]initWithFrame:CGRectMake(WIDTH/2, zhifuLabel.frame.origin.y, WIDTH/2-20, 15) withPrice:@"23"];
    _priceView.priceLabel.textColor = NavColor;
    
    [self addSubview:_stateButton];
    [self addSubview:belowView];
    [self addSubview:nameLabel];
    [self addSubview:messageLabel];
    [self addSubview:numPeopleLabel];
    [self addSubview:zhifuLabel];
    [self addSubview:lineLabel];
    [self addSubview:_focusButton];
    [self addSubview:_priceView];
//    [self addSubview:_backButton];
    
}
//- (void)backBarButtonSelect:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
