//
//  MLHomeListTableViewCell.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLHomeListTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView      *mainImgageView;
@property (nonatomic ,strong)UIButton         *stateButton;
@property (nonatomic ,strong)UIView           *belowView;
@property (nonatomic ,strong)UILabel          *nameLabel;
@property (nonatomic ,strong)UILabel          *messageLabel;
@property (nonatomic ,strong)PriceView        *priceView;


@end
