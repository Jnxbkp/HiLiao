//
//  MLHomeListTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import "MLHomeListTableViewCell.h"

@implementation MLHomeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _mainImgageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, WIDTH-24, WIDTH-24)];
    _mainImgageView.image = [UIImage imageNamed:@"aaa"];
    
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateButton.backgroundColor = ML_Color(24, 162, 29, 1);
    [_stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _stateButton.frame = CGRectMake(WIDTH-64, 12, 40, 20);
    _stateButton.layer.cornerRadius = 9.0;
    _stateButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    _belowView = [[UIView alloc]initWithFrame:CGRectMake(12, WIDTH-66-24, WIDTH-24, 66)];
    _belowView.backgroundColor = ML_Color(0, 0, 0, 0.5);
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, _belowView.frame.origin.y+12, WIDTH-48, 16)];
    _nameLabel.textColor = NavColor;
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, _nameLabel.frame.origin.y+28, WIDTH-154-34, 15)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
   
    
    
    _priceView = [[PriceView alloc]initWithFrame:CGRectMake(WIDTH-154, _messageLabel.frame.origin.y, 130, 15) withPrice:@"0"];
   
    
    [self.contentView addSubview:_mainImgageView];
    [self.contentView addSubview:_stateButton];
    [self.contentView addSubview:_belowView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_priceView];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
