//
//  TaskListCollectionVC.h
//  Task Bracket
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskView.h"
#import "TaskCollectionVC.h"

@interface TaskListCollectionVC : TaskCollectionVC <ButtonPressed>
@property (strong, nonatomic) UIColor *viewColor;
@end
