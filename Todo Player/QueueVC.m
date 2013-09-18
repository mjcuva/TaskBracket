//
//  QueueVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 9/13/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "QueueVC.h"
#import "SharedManagedObjectContext.h"
#import "Task+Description.h"
#import "TaskView.h"
#import "ItemList+colors.h"

@interface QueueVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *enqueuedTasks;
@end

@implementation QueueVC

#define HORIZONTAL_PADDING 10
#define CELL_HEIGHT 100
#define VERTICAL_PADDING 10

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
        [self loadTasks];
    }];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(0, -1 * (self.scrollView.frame.size.height / 2) - (CELL_HEIGHT / 2))];
}

#warning All the Cool Kids Cache

- (void)loadTasks{
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    req.predicate = [NSPredicate predicateWithFormat:@"enqueued = %@", [NSNumber numberWithBool:YES]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSError *err;
    self.enqueuedTasks = [self.context executeFetchRequest:req error:&err];
    
    if(err){
        NSLog(@"HOLY SHIT BATMAN! ERROR IN THE QUEUE: %@", [err description]);
    }else{
        NSLog(@"%@", [self.enqueuedTasks description]);
        [self addSubviews];
    }
}


#warning SUCKS
- (void)addSubviews{
    int start = (self.scrollView.frame.size.height / 2) - (CELL_HEIGHT);
    NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
    for(Task *i in self.enqueuedTasks){
        TaskView *tv = [[TaskView alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, start, self.view.frame.size.width - (HORIZONTAL_PADDING * 2), CELL_HEIGHT)];
        tv.color = i.lists.color;
        tv.title = i.title;
        tv.description_text = i.task_description;
        tv.hideAddQueueButton = YES;
        [self.scrollView addSubview:tv];
        start += CELL_HEIGHT + VERTICAL_PADDING;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + (CELL_HEIGHT + VERTICAL_PADDING) * ([self.enqueuedTasks count] - 1));
//    NSLog([self.scrollView description]);
}

@end
