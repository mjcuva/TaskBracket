//
//  BaseView.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    [[UIColor redColor] setFill];
    UIRectFill(self.bounds);
}

@end
