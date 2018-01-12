//
//  PlayCollectionViewCell.m
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PlayCollectionViewCell.h"

#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>

@interface PlayCollectionViewCell ()
@property (nonatomic, strong)AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong) UIView *playerView;

@end



@implementation PlayCollectionViewCell

#pragma mark - getter
-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    [self setContentView];
    // Initialization code
}

- (void)prepare {
//    [self.aliPlayer prepareWithURL:[NSURL URLWithString:self.playURLString]];
    
    //测试播放视频连接
    [self.aliPlayer prepareWithURL:[NSURL URLWithString:@"http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"]];
}


- (void)stopPlay {
    [self.aliPlayer stop];
}


- (void)setContentView{
    self.playerView = [[UIView alloc] init];
    self.playerView = self.aliPlayer.playerView;
    [self.contentView insertSubview:self.playerView atIndex:0];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];

    [self.aliPlayer setAutoPlay:YES];
    
    
}



@end
