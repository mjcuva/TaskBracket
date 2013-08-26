//
//  Taskview.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "Taskview.h"

@implementation TaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define HORIZONTAL_OFFSET 20

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentLeft];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // Center Text Vertically
    CGSize fontHeight = [self.title sizeWithAttributes:attr];
    CGFloat YOffSet = (rect.size.height - fontHeight.height) / 2;
    
    [self.title drawInRect:CGRectMake(HORIZONTAL_OFFSET, YOffSet, rect.size.width - HORIZONTAL_OFFSET, rect.size.height) withAttributes:attr];
}

@end
