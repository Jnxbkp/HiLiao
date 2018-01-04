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
        NSString *str = [NSString stringWithFormat:@"  %@ M币/分钟",price];
        CGSize labelSize = [NSStringSize getNSStringHeight:str Font:13.0];
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-labelSize.width, 0, labelSize.width, 15)];
        _priceLabel.text = str;
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont systemFontOfSize:13.0];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x-15, 0, 15, 15)];
        _iconImageView.image = [UIImage imageNamed:@"heart_blue"];
        
        [self addSubview:_priceLabel];
        [self addSubview:_iconImageView];
    }
    return self;
}
- (void)setPrice:(NSString *)price {
    NSString *str = [NSString stringWithFormat:@"  %@ M币/分钟",price];
    CGSize labelSize = [NSStringSize getNSStringHeight:str Font:13.0];
    _priceLabel.frame = CGRectMake(self.frame.size.width-labelSize.width, 0, labelSize.width, 15);
   
    _iconImageView.frame = CGRectMake(_priceLabel.frame.origin.x-15, 0, 15, 15);

}
@end
