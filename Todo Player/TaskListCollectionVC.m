//
//  TaskListCollectionVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskListCollectionVC.h"
#import "NewTaskVC.h"
#import "CollectionCell.h"
#import "Task+Description.h"
#import "UndoView.h"
#import "DynamicFlowLayout.h"
#import "Queue.h"

@interface TaskListCollectionVC() <newTask, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) NewTaskVC *presentedVC;
@property (strong, nonatomic) NSMutableArray *undoRemoves;

@property (strong, nonatomic) Queue *lists;

@property (strong, nonatomic) NSMutableArray *swipedTasks;

@property (strong, nonatomic) NSMutableArray *viewList;

@property (strong, nonatomic) UIImage *taskBackground;
@end

@implementation TaskListCollectionVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self reloadCollectionView];
    self.panGesture.delegate = self;
}

- (NSMutableArray *)undoRemoves{
    if(!_undoRemoves){
        _undoRemoves = [[NSMutableArray alloc] init];
    }
    
    return _undoRemoves;
}

- (void)loadViewList{
    [self.viewList removeAllObjects];
    for(Task *t in self.objectList){
        TaskView *view = (TaskView *)[self cellView];
        view.text = t.description;
        view.title = t.title;
        if(!self.taskBackground){
            view.color = self.viewColor;
            self.taskBackground = view.image;
        }else{
            view.color = self.viewColor;
            view.image = self.taskBackground;
        }
        view.description_text = t.task_description;
        view.delegate = self;
        view.enqueued = [t.enqueued boolValue];
        if(view.frame.size.height != [view idealHeight]){
            view.frame = CGRectMake([self viewX], 0, [self viewWidth], [view idealHeight]);
        }
        
        [self.viewList addObject:view];
    }

}

- (Queue *)lists{
    if(!_lists)
        _lists = [[Queue alloc] init];
    return _lists;
}

- (NSMutableArray *)swipedTasks{
    if(!_swipedTasks) {
        _swipedTasks = [[NSMutableArray alloc] init];
    }
    return _swipedTasks;
}

# pragma mark - newTask protocol

- (void)taskCreated{
   [self reloadCollectionView];
    [self.presentedVC dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskCanceled{
    [self.presentedVC dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskEdited:(Task *)task{
    [self reloadCollectionView];
    [self.presentedVC dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TaskCollectionSublcass methods

- (NSUInteger)numCollections{
    return [self.objectList count];
}

- (id)objectAtIndex:(NSUInteger)index{
    return self.objectList[index];
}

- (NSString *)reuseID{
    return @"TaskListCell";
}

- (NSString *)entityName{
    return @"Task";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *dvc = (UINavigationController *)segue.destinationViewController;
        NSLog(@"%@", [dvc.viewControllers description]);
        self.presentedVC = (NewTaskVC *)[dvc.viewControllers objectAtIndex:0];
        self.presentedVC.listTitle = self.title;
        self.presentedVC.delagate = self;
        
        if([sender isKindOfClass:[Task class]]){
            self.presentedVC.startingTask = sender;
        }
    }
}

- (void)createObjectList{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"list_location" ascending:YES]];
    req.predicate = [NSPredicate predicateWithFormat:@"lists.title == %@", self.title];
    
    // Perform Fetch
    NSError *err;
    self.objectList = [[self.context executeFetchRequest:req error:&err] mutableCopy];
    if(err){
        NSLog(@"Error Fetching List %@: %@", self.title, [err description]);
    }else{
        NSLog(@"Fetched List %@", self.title);
    }
}

#define COLLECTION_VIEW_CELL_PADDING 0
#define COLLECTION_VIEW_CELL_HEIGHT 100
#define COLLECTION_VIEW_OFFSET 10

- (void)setCollectionViewCellSize{
    CGFloat width = self.view.frame.size.width - COLLECTION_VIEW_CELL_PADDING;
    CGFloat height = COLLECTION_VIEW_CELL_HEIGHT;
    self.flowLayout.itemSize = CGSizeMake(width, height);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_VIEW_OFFSET, 0, COLLECTION_VIEW_OFFSET, 0);
}

- (NSUInteger)viewWidth{
    return self.flowLayout.itemSize.width - 20;
}

- (NSUInteger)viewX{
    return 10;
}

- (BaseView *)cellView{
    return [[TaskView alloc] initWithFrame:CGRectMake([self viewX], 0, [self viewWidth], self.flowLayout.itemSize.height)];
}

- (BOOL)canMoveItems{
    return YES;
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    Task *task = self.objectList[fromIndexPath.item];
    Task *task2 = self.objectList[toIndexPath.item];
    task.list_location = @(toIndexPath.item);
    task2.list_location = @(fromIndexPath.item);
    self.objectList[fromIndexPath.item] = task2;
    self.objectList[toIndexPath.item] = task;
    
//    [self reloadCollectionView];
}

#pragma mark - Remove Item Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    return fabs(translation.x) > fabs(translation.y);
}

- (IBAction)swipeTask:(UIPanGestureRecognizer *)sender {

    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:[sender locationInView:[self view]]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
    CollectionCell *cc = (CollectionCell *)cell;
    TaskView *swiped = (TaskView *)cc.view;
    
    if(sender.state == UIGestureRecognizerStateChanged && swiped != nil){
        
        if(![self.swipedTasks containsObject:swiped]){
            // Add new object that was swipedw
            [self.swipedTasks addObject:swiped];
        }
        
        cc.view.frame = CGRectMake(cc.view.frame.origin.x + [sender translationInView:[self view]].x, cc.view.frame.origin.y, cc.view.frame.size.width, cc.view.frame.size.height);
        cc.view.alpha = 1 - (abs(cc.view.frame.origin.x) / cc.view.frame.size.width);
        [sender setTranslation:CGPointZero inView:[self view]];
    }else if(sender.state == UIGestureRecognizerStateEnded){
        if(cc.view.frame.origin.x < cc.view.frame.size.width / 3 * -1){
            [UIView animateWithDuration:.75 animations:^{
                cc.view.alpha = 0;
                cc.view.frame = CGRectMake(cc.view.frame.size.width * -1, cc.view.frame.origin.y , cc.view.frame.size.width, cc.view.frame.size.height);
            }completion:^(BOOL success){
                if(success){
                    [self showCancelWithListView:(TaskView *)cc.view];
                }
            }];
        }else if(cc.view.frame.origin.x > cc.view.frame.size.width / 3){
            [UIView animateWithDuration:.75 animations:^{
                cc.view.alpha = 0;
                cc.view.frame = CGRectMake(cc.view.frame.size.width, cc.view.frame.origin.y, cc.view.frame.size.width, cc.view.frame.size.height);
            } completion:^(BOOL success){
                if(success){
                    [self showCancelWithListView:(TaskView *)cc.view];
                }
            }];
        }else{
            // Gesture failed
            [UIView animateWithDuration:.75 animations:^{
                for(TaskView *item in self.swipedTasks){
                    item.frame = CGRectMake(10, 0, item.frame.size.width, item.frame.size.height);
                    item.alpha = 1;
                }
            } completion:^(BOOL success){
                [self.swipedTasks removeAllObjects];
            }];
        }
    }
}

// Finishes removing the cell swiped away
- (void) showCancelWithListView:(TaskView *)tv{
    
    UIView *superView = [tv superview];

    [tv setHidden:YES];
    
    UndoView *undoButton = [[UndoView alloc] initWithFrame:CGRectMake(10, 0, tv.frame.size.width, tv.frame.size.height)];
    undoButton.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        undoButton.alpha = 1;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelRemove:)];
    [undoButton addGestureRecognizer:tap];
    [self performSelector:@selector(finishRemove) withObject:nil afterDelay:2];
    [self.lists enqueue:tv];
    [superView addSubview:undoButton];
}

- (void)cancelRemove:(UITapGestureRecognizer *)sender{
    
    TaskView *undoneView;
    
    NSArray *views = [[[sender view] superview] subviews];
    for(id view in views){
        if([view isKindOfClass:[TaskView class]]){
            [self.undoRemoves addObject:view];
            undoneView = view;
        }
    }
    
    [undoneView setHidden:NO];
    
    [UIView animateWithDuration:.5 animations:^{
        undoneView.frame = CGRectMake(10, 0, undoneView.frame.size.width, undoneView.frame.size.height);
        undoneView.alpha = 1;
    }];
    
    [[sender view] removeFromSuperview];
}

- (void)finishRemove{
    
    TaskView *tv = [self.lists peek];
    [self.lists dequeue];
    
    [UIView animateWithDuration:1 animations:^{
        NSArray *views = [[tv superview] subviews];
        for(id view in views){
            if([view isKindOfClass:[UndoView class]]){
                UndoView *uv = (UndoView *)view;
                uv.alpha = 0;
            }
        }
    } completion:^(BOOL success){
        if(![self.undoRemoves containsObject:tv]){
            
            UIView *superview = tv.superview;
            if([superview isKindOfClass:[CollectionCell class]]){
                CollectionCell *cc = (CollectionCell *)superview;
                cc.view = nil;
            }
            
            // Remove task and update collectionView
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
            req.predicate = [NSPredicate predicateWithFormat:@"title=%@", tv.title];
            
            Task *t = [[self.context executeFetchRequest:req error:NULL] lastObject];
            
            // Guarantees that the number won't be in the queue
            t.enqueued = [NSNumber numberWithBool:NO];
            
            NSLog(@"Deleting %@", [t title]);
            [self.context deleteObject:t];
            
            NSFetchRequest *allItems = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
            allItems.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"list_location" ascending:YES]];
            
            NSArray *tasks = [self.context executeFetchRequest:allItems error:NULL];
            
            int count = 0;
            for(Task *t in tasks){
                if([t.list_location integerValue] != count){
                    t.list_location = [NSNumber numberWithInt:count];
                }
                count++;
            }
            
            if([self.lists isEmpty])
                [self reloadCollectionView];
            
        }else{
            NSLog(@"Deletion Canceled");
        }
    
    }];
}

#pragma mark - Edit Task

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = (CollectionCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    TaskView *view = (TaskView *)cell.view;
    req.predicate = [NSPredicate predicateWithFormat:@"title == %@ && lists.title = %@", view.title, self.title];
    Task *task = [[self.context executeFetchRequest:req error:NULL] lastObject];
    assert(task != nil);
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"EditTask" sender:task];
}

#pragma mark - Queue

- (void)buttonPressed:(NSDictionary *)viewDetails{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
//    req.predicate = [NSPredicate predicateWithFormat:@"title == %@ && task_description == %@", [viewDetails objectForKey:@"title"], [viewDetails objectForKey:@"description"]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queue_location" ascending:YES]];

    NSArray *tasks = [self.context executeFetchRequest:req error:nil];
    
    for(Task *t in tasks){
        if([t.title isEqualToString:[viewDetails objectForKey:@"title"]] && [t.task_description isEqualToString:[viewDetails objectForKey:@"description"]]){
            Task *last = [tasks lastObject];
            if([[viewDetails valueForKey:@"enqueued"] isEqualToString:@"YES"]){
                t.enqueued = [NSNumber numberWithBool:YES];
                t.queue_location = @([last.queue_location integerValue] + 1);
            }else{
                t.enqueued = [NSNumber numberWithBool:NO];
                t.queue_location = @(0);
            }
            NSLog(@"Location: %@", [t.queue_location description]);
            break;
        }
    }
}


@end
