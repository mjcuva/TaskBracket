//
//  NewTaskVC.h
//  Task Bracket
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task+Description.h"

@protocol newTask <NSObject>

- (void)taskCreated;
- (void)taskCanceled;

@end

@interface NewTaskVC : UITableViewController
@property (strong, nonatomic) NSString *listTitle;
@property (strong, nonatomic) id<newTask> delagate;
@property (strong, nonatomic) Task *startingTask;
@end
