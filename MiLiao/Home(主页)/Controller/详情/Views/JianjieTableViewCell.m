//
//  JianjieTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/7.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "JianjieTableViewCell.h"

@implementation JianjieTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 3)];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, WIDTH-40, 20)];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_messageLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
