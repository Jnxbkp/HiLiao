//
//  tixianTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "tixianTableViewCell.h"
#import "MingXiModel.h"
@implementation tixianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MingXiModel *)model {
    _model = model;
    self.money.text = [NSString stringWithFormat:@"-%@M币 | 剩余%@M币",model.amount,model.afterAmount];
}


@end
