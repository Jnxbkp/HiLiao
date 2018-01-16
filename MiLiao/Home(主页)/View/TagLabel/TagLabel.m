//
//  TagLabel.m
//  MiLiao
//
//  Created by King on 2018/1/16.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "TagLabel.h"

#import "EvaluateTagModel.h"
@implementation TagLabel

- (void)setEvaluateTag:(EvaluateTagModel *)evaluateTag {
    _evaluateTag = evaluateTag;
    self.text = evaluateTag.tagName;
    self.textColor = [UIColor orangeColor];
    self.backgroundColor = [UIColor lightGrayColor];
//    long color = strtoul([evaluateTag.tagColor UTF8String],0,16);
//    self.backgroundColor = RGBColor(color);
    [self sizeToFit];
}

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
