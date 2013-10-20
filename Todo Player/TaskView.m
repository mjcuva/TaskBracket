//
//  Taskview.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "Taskview.h"
#import "NSString+stringHeight.h"

@interface TaskView()

@property (strong, nonatomic) UIButton *addToQueueButton;

@end

@implementation TaskView 

- (CGFloat)fontSizeFactor{
    if (!_fontSizeFactor) {
        _fontSizeFactor = 1;
    }
    return _fontSizeFactor;
}

#define TITLE_HORIZONTAL_OFFSET 20
#define TITLE_VERTICAL_OFFSET 20
#define DESCRIPTION_HORIZONTAL_OFFSET 30
#define DESCRIPTION_VERTICAL_OFFSET -10
#define RIGHT_EDGE_INSET 60

#define TITLE_FONT_SIZE 23
#define DESCRIPTION_FONT_SIZE 16

#define MIN_CELL_HEIGHT 100
#define MAX_CELL_WIDTH 

- (CGFloat)idealHeight{
    CGFloat height = 0;
    // Padding
    height += TITLE_VERTICAL_OFFSET;

    // Title Size
#warning Duplicated Code
    
    UIFont *title_font = [UIFont systemFontOfSize:TITLE_FONT_SIZE * self.fontSizeFactor];
    
    // Max Width for Textbox
    CGFloat max_width = self.frame.size.width - TITLE_HORIZONTAL_OFFSET - RIGHT_EDGE_INSET;
    
    // Center Text Vertically
    height += [self.title boundingRectWithSize:CGSizeMake(max_width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:title_font} context:nil].size.height;
    
    // Padding
    
    // Description Size
#warning Duplicated Code
    UIFont *description_font = [UIFont systemFontOfSize:DESCRIPTION_FONT_SIZE * self.fontSizeFactor];
    
    height += [self.description_text sizeForStringWithFont:description_font andSize:CGSizeMake(max_width, 500)].height;
    
    // Padding
    height += 10;
    
    // Min Height 
    if(height < MIN_CELL_HEIGHT){
        height = MIN_CELL_HEIGHT;
    }
    
    return height;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // Title
    
    // Center Text Horizontally
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [p setAlignment:NSTextAlignmentLeft];
    p.lineBreakMode = NSLineBreakByWordWrapping;    
    
    UIFont *title_font = [UIFont systemFontOfSize:TITLE_FONT_SIZE * self.fontSizeFactor];
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:title_font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // Center Text Vertically
    CGFloat max_width = rect.size.width - TITLE_HORIZONTAL_OFFSET - RIGHT_EDGE_INSET;
    CGFloat titleHeight = [self.title boundingRectWithSize:CGSizeMake(max_width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:title_font} context:nil].size.height;
    CGFloat titleOffSet = ((rect.size.height - titleHeight) / 2) - TITLE_VERTICAL_OFFSET;
    
    [self.title drawInRect:CGRectMake(TITLE_HORIZONTAL_OFFSET, titleOffSet, rect.size.width - TITLE_HORIZONTAL_OFFSET - RIGHT_EDGE_INSET, titleHeight) withAttributes:attr];
    
    // Description
    UIFont *description_font = [UIFont systemFontOfSize:DESCRIPTION_FONT_SIZE * self.fontSizeFactor];
    NSDictionary *description_attr = @{NSParagraphStyleAttributeName:p, NSFontAttributeName:description_font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    CGSize descriptionHeight = [self.description_text sizeWithAttributes:description_attr];
//    CGFloat descriptionOffset = (rect.size.height - descriptionHeight.height) / 2;
    CGFloat descriptionOffset = titleHeight + titleOffSet;
    
    // TODO: Update cell size to adjust for more text
    [self.description_text drawInRect:CGRectMake(DESCRIPTION_HORIZONTAL_OFFSET, descriptionOffset - DESCRIPTION_VERTICAL_OFFSET, rect.size.width - DESCRIPTION_HORIZONTAL_OFFSET - RIGHT_EDGE_INSET, rect.size.height - descriptionOffset - DESCRIPTION_VERTICAL_OFFSET - descriptionHeight.height) withAttributes:description_attr];
    
    // Add Button
    if(!self.addToQueueButton && !self.hideAddQueueButton){
        self.addToQueueButton = [[UIButton alloc] init];
        [self.addToQueueButton setTitle:@"+" forState:UIControlStateNormal];
        self.addToQueueButton.frame = CGRectMake(rect.size.width - RIGHT_EDGE_INSET, 0, rect.size.width - (rect.size.width - RIGHT_EDGE_INSET), rect.size.height);
        self.addToQueueButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [self.addToQueueButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addToQueueButton];
    }
    
    if (self.enqueued) {
        self.addToQueueButton.titleLabel.textColor = [UIColor redColor]; 
    }else{
        self.addToQueueButton.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)buttonPressed:(UIButton *)button{
    
    NSString *enqueuedValue = !self.enqueued ? @"YES" : @"NO";
    
    [self.delegate buttonPressed:@{@"title":self.title, @"description":self.description_text, @"enqueued":enqueuedValue}];
    self.enqueued = !self.enqueued;
    [self setNeedsDisplay];
}

@end
