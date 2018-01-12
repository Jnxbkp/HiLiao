//
//  PlayCollectionViewCell.h
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *playURLString;

///准备视频
- (void)prepare;

//停止播放
- (void)stopPlay;
@end
