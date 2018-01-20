//
//  tixianTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "shourucell.h"
#import "shouruModel.h"
@implementation shourucell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(shouruModel *)model {
    _model = model;
    self.nickName.text = [NSString stringWithFormat:@"%@",model.nickName];
    self.money.text = [NSString stringWithFormat:@"-%@M币 | 剩余0M币",model.amount];
}


@end
