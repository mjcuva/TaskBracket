//
//  QueueDisplayView.m
//  Task Bracket
//
//  Created by Marc Cuva on 11/28/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "QueueDisplayView.h"

@interface QueueDisplayView()
@property (strong, nonatomic) UILabel *currentTaskLabel;
@end

@implementation QueueDisplayView

#define NAV_BAR_HEIGHT 44
#define TOP_BAR_HEIGHT 140

#define CURRENT_TASK_PREFIX @"Current Task: "
#define NO_TASKS_STRING @"Congratulations, you don't have anything to do!"

- (void)sharedInit{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size
                                                                             .width, TOP_BAR_HEIGHT)];
    
    [self addSubview:bar];
    
    self.currentTaskLabel = [[UILabel alloc] init];

    // Configures the label
    [self updateCurrentTask];
    
#warning Tint color?
    self.currentTaskLabel.textColor = [UIColor redColor];
    
    [self addSubview:self.currentTaskLabel];
    
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

- (void)setCurrentTask:(Task *)currentTask{
    _currentTask = currentTask;
    [self updateCurrentTask];
}

- (void)updateCurrentTask{
    NSString *currentTask;
    if(self.currentTask){
        currentTask = [CURRENT_TASK_PREFIX stringByAppendingString:self.currentTask.title];
    }else{
        currentTask = NO_TASKS_STRING;
    }
    UIFont *font = [UIFont systemFontOfSize:20];
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGFloat labelVOffset = 30.0;
    
    // TODO: Isn't centered properly
    self.currentTaskLabel.frame = CGRectMake((self.frame.size.width / 2) - ([currentTask sizeWithAttributes:attr].width / 2), (TOP_BAR_HEIGHT / 2) - labelVOffset, [currentTask sizeWithAttributes:attr].width, [currentTask sizeWithAttributes:attr].height);
    self.currentTaskLabel.text = currentTask;
}

@end
