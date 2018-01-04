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
    _mainImgageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.76)];
    _mainImgageView.image = [UIImage imageNamed:@"aaa"];
    
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateButton.backgroundColor = [UIColor greenColor];
    [_stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _stateButton.frame = CGRectMake(WIDTH-50, 20, 40, 20);
    _stateButton.layer.cornerRadius = 8.0;
    _stateButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    _belowView = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH*0.76-60, WIDTH, 60)];
    _belowView.backgroundColor = [UIColor blackColor];
    _belowView.alpha = 0.3;
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, WIDTH*0.76-50, WIDTH, 20)];
    _nameLabel.textColor = NavColor;
    _nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, _nameLabel.frame.origin.y+25, (WIDTH-50)*2/3, 15)];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    
    _priceView = [[PriceView alloc]initWithFrame:CGRectMake((WIDTH-25)*2/3, _messageLabel.frame.origin.y, WIDTH/3, 15) withPrice:@"20"];

    
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
