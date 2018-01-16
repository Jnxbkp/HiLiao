//
//  ItemsView.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/2.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsView : UIView

@property (nonatomic,strong)NSArray  *itemArr;
@property (nonatomic,assign) float   itemsViewHeight;
@property (nonatomic,assign) float   itemsViewWidth;

- (instancetype)initWithFrame:(CGRect)frame itemArr:(NSArray *)itemArr;

- (UIColor *)itemColor:(NSString *)str;

- (void)setItemsArr:(NSArray *)itemArr;

- (void)setItemsDicArr:(NSArray *)itemArr;
@end
