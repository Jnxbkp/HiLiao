//
//  ItemsView.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/2.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "ItemsView.h"
#import "NSStringSize.h"

#define itemButtonTag       1000
@implementation ItemsView

- (instancetype)initWithFrame:(CGRect)frame itemArr:(NSArray *)itemArr {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setItemsArr:(NSArray *)itemArr {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemArr = itemArr;
    CGFloat w = 12;
    CGFloat h = 0;
    
    for (int i = 0; i < itemArr.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = itemButtonTag+i;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize buttonSize = [NSStringSize getNSStringHeight:itemArr[i] Font:11.0];
        itemButton.backgroundColor = [self itemColor:itemArr[i]];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [itemButton setTitle:itemArr[i] forState:UIControlStateNormal];
        itemButton.layer.cornerRadius = 12;
        
        itemButton.frame = CGRectMake(w, h, buttonSize.width+20 , 24);
        if(w + buttonSize.width + 24 > WIDTH){
            w = 12;
            h = h + itemButton.frame.size.height + 12;
            itemButton.frame = CGRectMake(w, h, buttonSize.width+20, 24);
        }
        
        w = itemButton.frame.size.width + itemButton.frame.origin.x+12;
        
        if (i == itemArr.count-1) {
            self.itemsViewHeight = itemButton.frame.origin.y+24;
            self.itemsViewWidth = itemButton.frame.origin.x+itemButton.frame.size.width;
        }
        [self addSubview:itemButton];
    }
}
- (UIColor *)itemColor:(NSString *)str {
    UIColor *color = [[UIColor alloc]init];
    if ([str isEqualToString:@"完美身材"]) {
        color = ML_Color(255, 106, 159, 1);
    } else {
        color = ML_Color(247, 147, 101, 1);
    }
    return color;
}
- (void)itemButtonClick:(UIButton *)itemButton {
    
}
@end
