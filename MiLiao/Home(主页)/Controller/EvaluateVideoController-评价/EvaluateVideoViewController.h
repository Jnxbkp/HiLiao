//
//  EvaluateVideoViewController.h
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EvaluateTagModel.h"

@interface TagButton: UIButton

@property (nonatomic, strong) EvaluateTagModel *evaluateTag;
@end

/**
 对当前的一对一视频女主播做出评价
 */
@interface EvaluateVideoViewController : UIViewController

///弹出结算成功的提示
- (void)showSueecss;

@end
