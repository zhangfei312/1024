//
//  LuckyLabel.m
//  1024
//
//  Created by MAC on 14-3-29.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import "LuckyLabel.h"

@implementation LuckyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {

        NSLog(@"num:%i",self.numberTag);
        self.backgroundColor = [UIColor colorWithRed:0.765 green:0.786 blue:0.802 alpha:1.000];
        self.tintColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:30];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
