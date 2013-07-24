//
//  UndoView.m
//  Task Bracket
//
//  Created by Marc Cuva on 7/24/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "UndoView.h"

@implementation UndoView

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
    
    [[UIColor grayColor] setFill];
    UIRectFill(self.bounds);
    
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentCenter];
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p};
    
    // Center Text Vertically
    CGSize fontHeight = [@"Undo" sizeWithAttributes:nil];
    CGFloat YOffSet = (rect.size.height - fontHeight.height) / 2;
    
    [@"Undo" drawInRect:CGRectMake(0, YOffSet, rect.size.width, rect.size.height) withAttributes:attr];
}

@end
