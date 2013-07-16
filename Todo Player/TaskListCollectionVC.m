//
//  TaskListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskListCollectionVC.h"
#import "NewTaskVC.h"

@interface TaskListCollectionVC()
@end

@implementation TaskListCollectionVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *dvc = (UINavigationController *)segue.destinationViewController;
        [[dvc.navigationController.viewControllers objectAtIndex:0] performSelector:@selector(setListTitle:) withObject:self.title];
    }
}

@end
