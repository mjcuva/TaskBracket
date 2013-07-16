//
//  NewTaskVC.h
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol newTask <NSObject>

- (void)taskCreated;
- (void)taskCanceled;

@end

@interface NewTaskVC : UITableViewController
@property (strong, nonatomic) NSString *listTitle;
@property (strong, nonatomic) id<newTask> delagate;
@end
