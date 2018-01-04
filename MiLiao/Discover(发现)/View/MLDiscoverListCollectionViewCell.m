//
//  MLDiscoverListCollectionViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLDiscoverListCollectionViewCell.h"

@implementation MLDiscoverListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creat];
    }
    return self;
}

- (void)creat {
    _mainImgageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (WIDTH-5)/2, (WIDTH-5)/2*1.2)];
    _mainImgageView.image = [UIImage imageNamed:@"aaa"];
    
    _belowView = [[UIView alloc]initWithFrame:CGRectMake(0, (WIDTH-5)/2*1.2-50, (WIDTH-5)/2, 50)];
    _belowView.backgroundColor = [UIColor blackColor];
    _belowView.alpha = 0.3;
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _belowView.frame.origin.y+5, _belowView.frame.size.width/2, 12.5)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _timeLabel.frame.origin.y+22.5, _belowView.frame.size.width-20, 12.5)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:12.0];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_belowView.frame.size.width-60, _timeLabel.frame.origin.y, 15, 15)];
    _iconImageView.image = [UIImage imageNamed:@"heart_blue"];
    
    _likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x+20, _iconImageView.frame.origin.y, 30, 15)];
    _likeNumLabel.font = [UIFont systemFontOfSize:14.0];
    _likeNumLabel.textColor = NavColor;
    
    
    [self.contentView addSubview:_mainImgageView];
    [self.contentView addSubview:_belowView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_likeNumLabel];
}
@end
