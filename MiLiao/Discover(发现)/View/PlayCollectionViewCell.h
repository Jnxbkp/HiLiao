//
//  PlayCollectionViewCell.h
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PlayActionType) {
    ///上传图片
    PlayActionTypeUploadImage,
    ///喜欢
    PlayActionTypeLove,
    ///观看量
    PlayActionTypeLook,
    ///评论量
    PlayActionTypeComment,
    ///分享
    PlayActionTypeShare
};

typedef void(^ButtonClickBlock)(PlayActionType actionType);

@interface PlayCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *playURLString;

///准备视频
- (void)prepare;

//停止播放
- (void)stopPlay;

///点击视频播放界面的按钮回调
- (void)playAction:(ButtonClickBlock)action;


@end
