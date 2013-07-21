//
//  ListView.m
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListView.h"

@interface ListView()
@property (weak, nonatomic) UILabel *textLabel;
@end

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
    CGSize fontHeight = [self.title sizeWithAttributes:nil];
    CGFloat YOffSet = (rect.size.height - fontHeight.height) / 2;
    
    [self.title drawInRect:CGRectMake(0, YOffSet, rect.size.width, rect.size.height) withAttributes:attr];
}

@end
