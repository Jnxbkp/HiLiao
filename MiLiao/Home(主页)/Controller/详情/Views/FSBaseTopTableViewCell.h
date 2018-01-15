//
//  FSBaseTopTableViewCell.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLoopScrollView.h"

@interface FSBaseTopTableViewCell : UITableViewCell

@property (nonatomic ,strong)FSLoopScrollView   *loopView;
@property (nonatomic ,strong)UIButton         *stateButton;
@property (nonatomic ,strong)UIButton         *focusButton;
@property (nonatomic, strong)PriceView        *priceView;

@property (nonatomic ,strong)UILabel         *nameLabel;
@property (nonatomic ,strong)UILabel         *messageLabel;
@property (nonatomic ,strong)UILabel         *numFocusLabel;
@property (nonatomic ,strong)UILabel         *weixinLabel;
@property (nonatomic, strong)NSArray         *headImageArr;

@end
