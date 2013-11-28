//
//  QueueDisplayView.m
//  Task Bracket
//
//  Created by Marc Cuva on 11/28/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "QueueDisplayView.h"

@implementation QueueDisplayView

#define NAV_BAR_HEIGHT 44
#define TOP_BAR_HEIGHT 140

- (void)sharedInit{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size
                                                                             .width, TOP_BAR_HEIGHT)];
    
    [self addSubview:bar];
    
    NSString *currentTask = @"Current Task: ";
    UIFont *font = [UIFont systemFontOfSize:20];
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGFloat labelVOffset = 30.0;
    
    UILabel *currentTaskLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) - ([currentTask sizeWithAttributes:attr].width / 2), (TOP_BAR_HEIGHT / 2) - labelVOffset, [currentTask sizeWithAttributes:attr].width, [currentTask sizeWithAttributes:attr].height)];
    currentTaskLabel.text = currentTask;
#warning Tint color?
    currentTaskLabel.textColor = [UIColor redColor];
    
    [self addSubview:currentTaskLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self sharedInit];
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
