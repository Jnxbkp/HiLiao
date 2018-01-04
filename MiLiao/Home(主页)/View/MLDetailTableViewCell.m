//
//  MLDetailTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/2.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLDetailTableViewCell.h"

@implementation MLDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, WIDTH/3, 15)];
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 20, WIDTH/2-20, 15)];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.font = [UIFont systemFontOfSize:15.0];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 54.6, WIDTH, 0.4)];
    _lineLabel.backgroundColor = [UIColor blackColor];
    
    _itemsView = [[ItemsView alloc]initWithFrame:CGRectMake(WIDTH/2-30, 12, WIDTH/2, 25)];
    _itemsView.hidden = YES;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_messageLabel];
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_itemsView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
