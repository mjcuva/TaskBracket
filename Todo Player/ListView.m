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

#define CENTER_OFFSET 20

- (void)drawRect:(CGRect)rect
{
 
    [super drawRect:rect];
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentLeft];
    
    UIFont *font = [UIFont systemFontOfSize:22];
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // Center Text Vertically
    CGSize fontHeight = [self.description sizeWithAttributes:attr];
    CGFloat YOffSet = (rect.size.height - fontHeight.height) / 2;
    
    [self.text drawInRect:CGRectMake(CENTER_OFFSET, YOffSet, rect.size.width, rect.size.height) withAttributes:attr];
}

@end
