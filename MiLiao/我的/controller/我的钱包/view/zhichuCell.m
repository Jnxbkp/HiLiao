//
//  tixianTableViewCell.m
//  MiLiao
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "zhichuCell.h"
#import "zhichuModel.h"
@implementation zhichuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(zhichuModel *)model {
    _model = model;
//    self.message.text = [NSString stringWithFormat:@"%@",model.createDate];
//    [self.image sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    self.money.text = [NSString stringWithFormat:@"-%@M币",model.amount];
    self.nickName.text = [NSString stringWithFormat:@"视频通话 —%@",model.nickName];
    self.time.text = @"01-17 09:09 | 通话时长4分21秒";
}


@end
