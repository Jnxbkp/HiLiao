//
//  HLSearchTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "HLSearchTableViewCell.h"

@implementation HLSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 35.0;
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, WIDTH-90, 20)];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+30, _nameLabel.frame.size.width, 15)];
    _messageLabel.textColor = [UIColor lightGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 89.7, WIDTH, 0.3)];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_headImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_lineLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
