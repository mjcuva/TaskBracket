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
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentCenter];
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p};
    
    // Center Text Vertically
    CGFloat YOffSet = (rect.size.height - 12) / 2;

    [self.title drawInRect:CGRectMake(0, YOffSet, rect.size.width, rect.size.height) withAttributes:attr];
}

@end
