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
#define OFFSET_FACTOR 3
#define NAV_BAR_HEIGHT 44

- (CGPoint)center{
    return CGPointMake(self.view.frame.size.width / 2, (self.view.bounds.size.height / 2 - CELL_HEIGHT) + NAV_BAR_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
        [self loadTasks];
        [self adjustQueueLayout];
    }];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setContentOffset:CGPointMake(0, -1 * (self.scrollView.frame.size.height / 2) - (CELL_HEIGHT / 2))];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size
                                                                             .width, 64)];
    
    [self.view addSubview:bar];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self adjustQueueLayout];
}

- (void)adjustQueueLayout{
    for(id view in self.scrollView.subviews){
        if([view isKindOfClass:[TaskView class]]){
            TaskView *tv = (TaskView *)view;
            if(CGRectIntersectsRect(tv.frame, self.scrollView.bounds)){
                CGFloat diff = abs((tv.center.y - self.scrollView.contentOffset.y) - [self center].y) / OFFSET_FACTOR;
                CGFloat fontSizeFactor = MAX(0, powf((self.view.frame.size.height - diff) / self.view.frame.size.height, 1.5));
                tv.fontSizeFactor = fontSizeFactor;
                tv.frame = CGRectMake(MAX(HORIZONTAL_PADDING, diff), tv.frame.origin.y, (self.view.frame.size.width - (HORIZONTAL_PADDING)) - MAX(diff, HORIZONTAL_PADDING), tv.frame.size.height);
                [tv setNeedsDisplay];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for(TaskView *view in scrollView.subviews){
        if(CGRectContainsPoint(view.frame, CGPointMake([self center].x, [self center].y - self.scrollView.contentOffset.y))){
            [UIView animateWithDuration:.5 animations:^{
                self.scrollView.contentOffset = CGPointMake(0, view.center.y - [self center].y);
            }];
        }
    }
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
    // Remove all subviews to prevent memory leak when adding new subviews
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int start = (self.scrollView.frame.size.height / 2) - (CELL_HEIGHT);
    for(Task *i in self.enqueuedTasks){
        TaskView *tv = [[TaskView alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, start, self.view.frame.size.width - (HORIZONTAL_PADDING), CELL_HEIGHT)];
        tv.color = i.lists.color;
        tv.title = i.title;
        tv.description_text = i.task_description;
        tv.hideAddQueueButton = YES;
        
        // Ideal height can't be calculated until the width of the frame is set
        if([tv idealHeight] != tv.frame.size.height){
            tv.frame = CGRectMake(tv.frame.origin.x, tv.frame.origin.y, tv.frame.size.width, [tv idealHeight]);
        }
        
        [self.scrollView addSubview:tv];
        start += tv.frame.size.height + VERTICAL_PADDING;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + (CELL_HEIGHT + VERTICAL_PADDING) * ([self.enqueuedTasks count] - 1));
}

@end
