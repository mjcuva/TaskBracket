//
//  Taskview.h
//  Task Bracket
//
//  Created by Marc Cuva on 8/6/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "BaseView.h"

@protocol ButtonPressed
- (void)buttonPressed:(NSDictionary *)viewDetails;
@end

@interface TaskView : BaseView <ButtonPressed>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description_text;

@property (strong, nonatomic) id<ButtonPressed> delegate;

@property (nonatomic) BOOL enqueued;

@property (nonatomic) BOOL hideAddQueueButton;

@property (nonatomic) CGFloat fontSizeFactor;

@end
