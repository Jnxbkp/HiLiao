//
//  PriceView.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/1.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PriceView.h"

@implementation PriceView

- (instancetype)initWithFrame:(CGRect)frame withPrice:(NSString *)price {
    self = [super initWithFrame:frame];
    if (self) {
        self.price = price;
        NSString *str = [NSString stringWithFormat:@"%@ M币/分钟",price];
        CGSize labelSize = [NSStringSize getNSStringHeight:str Font:14.0];
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-labelSize.width, 0, labelSize.width, 15)];
        _priceLabel.text = str;
        _priceLabel.textColor = ML_Color(253, 152, 0, 1);
        _priceLabel.font = [UIFont systemFontOfSize:14.0];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x-25, 1, 18, 12)];
        _iconImageView.image = [UIImage imageNamed:@"icon_shipin"];
        
        [self addSubview:_priceLabel];
        [self addSubview:_iconImageView];
    }
    return self;
}
- (void)setPrice:(NSString *)price {
    NSString *str = [NSString stringWithFormat:@"%@ M币/分钟",price];
    CGSize labelSize = [NSStringSize getNSStringHeight:str Font:14.0];
    _priceLabel.frame = CGRectMake(self.frame.size.width-labelSize.width, 0, labelSize.width, 15);
    _priceLabel.text = str;
    _iconImageView.frame = CGRectMake(_priceLabel.frame.origin.x-25, 1, 18, 12);

}
@end
