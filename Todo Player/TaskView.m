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

#define TITLE_HORIZONTAL_OFFSET 20
#define TITLE_VERTICAL_OFFSET 20
#define DESCRIPTION_HORIZONTAL_OFFSET 30
#define DESCRIPTION_VERTICAL_OFFSET -15

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentLeft];
    
    UIFont *title_font = [UIFont systemFontOfSize:23];
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:title_font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // Center Text Vertically
    CGSize fontHeight = [self.title sizeWithAttributes:attr];
    CGFloat YOffSet = (rect.size.height - fontHeight.height) / 2;
    
    [self.title drawInRect:CGRectMake(TITLE_HORIZONTAL_OFFSET, YOffSet - TITLE_VERTICAL_OFFSET, rect.size.width - TITLE_HORIZONTAL_OFFSET, rect.size.height) withAttributes:attr];
    
    UIFont *description_font = [UIFont systemFontOfSize:16];
    NSDictionary *description_attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:description_font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    CGSize descriptionHeight = [self.description_text sizeWithAttributes:description_attr];
    CGFloat descriptionOffset = (rect.size.height - descriptionHeight.height) / 2;
    
    [self.description_text drawInRect:CGRectMake(DESCRIPTION_HORIZONTAL_OFFSET, descriptionOffset - DESCRIPTION_VERTICAL_OFFSET, rect.size.width - DESCRIPTION_HORIZONTAL_OFFSET, rect.size.height) withAttributes:description_attr];
    
}

@end
