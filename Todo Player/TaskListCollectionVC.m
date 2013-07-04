//
//  TaskListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskListCollectionVC.h"
#import "NewTaskVC.h"

@interface TaskListCollectionVC()<NewTaskModal>
@property (strong, nonatomic) NewTaskVC *presentedVC;
@end

@implementation TaskListCollectionVC 

- (void)modalViewWasCanceled{
    [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
}
- (void)modalViewWasCompleted{
    [self.presentedVC dismissViewControllerAnimated:YES completion:^{
        // TODO: Reload View
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"NewTask"]){
        if([segue.destinationViewController isKindOfClass:[NewTaskVC class]]){
            self.presentedVC = (NewTaskVC *)segue.destinationViewController;
            self.presentedVC.delegate = self;
        }
    }
}


@end
