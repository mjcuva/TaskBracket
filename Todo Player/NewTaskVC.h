//
//  NewTaskVC.h
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <UIKit/UIKit.h>

// Needs to be implemented to dismiss modal vc
@protocol NewTaskModal <NSObject>

- (void)modalViewWasCanceled;
- (void)modalViewWasCompleted;

@end

@interface NewTaskVC : UIViewController
@property (assign, nonatomic) id <NewTaskModal> delegate;
@end
