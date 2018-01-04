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
    CGFloat w = 20;
    CGFloat h = 0;
    
    for (int i = 0; i < itemArr.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = itemButtonTag+i;
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize buttonSize = [NSStringSize getNSStringHeight:itemArr[i] Font:14.0];
        itemButton.backgroundColor = [UIColor redColor];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [itemButton setTitle:itemArr[i] forState:UIControlStateNormal];
        itemButton.layer.cornerRadius = 12.5;
        
        itemButton.frame = CGRectMake(w, h, buttonSize.width+30 , 30);
        if(w + buttonSize.width + 40 > WIDTH){
            w = 20;
            h = h + itemButton.frame.size.height + 20;
            itemButton.frame = CGRectMake(w, h, buttonSize.width+30, 30);
        }
        
        w = itemButton.frame.size.width + itemButton.frame.origin.x+30;
        
        if (i == itemArr.count-1) {
            self.itemsViewHeight = itemButton.frame.origin.y+30;
        }
        [self addSubview:itemButton];
    }
}
- (void)itemButtonClick:(UIButton *)itemButton {
    
}
@end
