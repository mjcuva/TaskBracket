//
//  QueueVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 9/13/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "QueueVC.h"
#import "SharedManagedObjectContext.h"
#import "Task.h"

@interface QueueVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation QueueVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
        [self loadTasks];
    }];
    
}


- (void)loadTasks{
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    req.predicate = [NSPredicate predicateWithFormat:@"enqueued = %@", [NSNumber numberWithBool:YES]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSError *err;
    NSArray *enqueuedTasks = [self.context executeFetchRequest:req error:&err];
    
    if(err){
        NSLog(@"%@", [err description]);
    }else{
        NSLog(@"%@", [enqueuedTasks description]);
    }
}

@end
