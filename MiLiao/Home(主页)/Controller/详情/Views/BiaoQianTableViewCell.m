//
//  BiaoQianTableViewCell.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/7.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "BiaoQianTableViewCell.h"

@implementation BiaoQianTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creat];
    }
    return self;
}
- (void)creat {
    
    _line1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 3)];
    _line1Label.backgroundColor = [UIColor lightGrayColor];
    
    _itemView = [[ItemsView alloc]init];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _itemView.frame.origin.y+_itemView.frame.size.height+15, WIDTH, 3)];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_line1Label];
    [self.contentView addSubview:_itemView];
    [self.contentView addSubview:_lineLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
