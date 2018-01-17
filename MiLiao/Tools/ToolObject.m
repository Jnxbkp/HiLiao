//
//  ToolObject.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/17.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "ToolObject.h"

@implementation ToolObject

+ (UIColor *)getColorStr:(NSString *)colorStr {
    UIColor *color;
    if ([colorStr isKindOfClass:[NSString class]]&&colorStr.length > 0) {
        if ([colorStr rangeOfString:@"#"].location == NSNotFound) {
            color = [UIColor colorWithHexString:colorStr];
        } else {
            color = [UIColor colorWithHexString:[colorStr  substringFromIndex:1]];
        }
    }
    return color;
}

@end
