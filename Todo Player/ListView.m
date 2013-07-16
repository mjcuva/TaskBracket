//
//  ListView.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    [[UIColor redColor] setFill];
    UIRectFill(self.bounds);
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = self.title;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    [self addSubview:label];
}

@end
