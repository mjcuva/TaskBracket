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
#import "TaskView.h"

@interface TaskListCollectionVC() <newTask, UIGestureRecognizerDelegate, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) NewTaskVC *presentedVC;

// Holds the view that was last removed, in case the user
// presses undo
@property (strong, nonatomic) TaskView *lastRemovedList;

// YES is undo was pressed
@property BOOL removeCanceled;

// Keeps track of the last swiped to prevent
// a swipe from occuring on the wrong task
@property (weak, nonatomic) TaskView *lastSwiped;

@property (strong, nonatomic) UndoView *undoButton;
@end

@implementation TaskListCollectionVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self reloadCollectionView];
    self.panGesture.delegate = self;
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

- (void)updateCell:(UICollectionViewCell *)cell usingObject:(id)object{
    if([cell isKindOfClass:[CollectionCell class]]){
        if([object isKindOfClass:[Task class]]){
            CollectionCell *colCell = (CollectionCell *)cell;
            TaskView *view = (TaskView *)colCell.view;
            Task *t = (Task *)object;
            colCell.view.text = t.description;
            view.title = t.title;
            [colCell.view setNeedsDisplay];
        }
    }
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
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    req.predicate = [NSPredicate predicateWithFormat:@"lists.title == %@", self.title];
    
    // Perform Fetch
    NSError *err;
    self.objectList = [self.context executeFetchRequest:req error:&err];
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
#pragma mark - Remove Item Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    return fabs(translation.x) > fabs(translation.y);
}

- (IBAction)swipeTask:(UIPanGestureRecognizer *)sender {

    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:[sender locationInView:[self view]]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
    CollectionCell *cc = (CollectionCell *)cell;
    
    if(sender.state == UIGestureRecognizerStateBegan && cc != nil)
        self.lastSwiped = (TaskView *)cc.view;
    
    NSLog(@"%ul", sender.state);
    
    if(sender.state == UIGestureRecognizerStateChanged && cc.view == self.lastSwiped){
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
                self.lastSwiped.frame = CGRectMake(10, 0, self.lastSwiped.frame.size.width, self.lastSwiped.frame.size.height);
                self.lastSwiped.alpha = 1;
            }];
        }
    }
}

// Finishes removing the cell swiped away
- (void) showCancelWithListView:(TaskView *)tv{
    
    UIView *superView = [tv superview];

    self.lastRemovedList = tv;
    [tv removeFromSuperview];
    

    
    self.undoButton = [[UndoView alloc] initWithFrame:CGRectMake(10, 0, tv.frame.size.width, tv.frame.size.height)];
    self.undoButton.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.undoButton.alpha = 1;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelRemove)];
    [self.undoButton addGestureRecognizer:tap];
    [self performSelector:@selector(finishRemoveWithObjects:) withObject:tv afterDelay:2];
    [superView addSubview:self.undoButton];
}

- (void)cancelRemove{
    self.removeCanceled = YES;
    [self.lastRemovedList setNeedsDisplay];
    UIView *superview = self.undoButton.superview;
    [self.undoButton removeFromSuperview];
    [superview addSubview:self.lastRemovedList];
    
    [UIView animateWithDuration:.5 animations:^{
        self.lastRemovedList.frame = CGRectMake(10, 0, self.lastRemovedList.frame.size.width, self.lastRemovedList.frame.size.height);
        self.lastRemovedList.alpha = 1;
    }];
}

- (void)finishRemoveWithObjects:(TaskView *)tv{
    
    [UIView animateWithDuration:1 animations:^{
        self.undoButton.alpha = 0;
    } completion:^(BOOL success){
        
        if(self.removeCanceled == NO){
            
            UIView *superview = self.undoButton.superview;
            if([superview isKindOfClass:[CollectionCell class]]){
                CollectionCell *cc = (CollectionCell *)superview;
                cc.view = nil;
            }
            
            // Remove task and update collectionView
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
            req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            req.predicate = [NSPredicate predicateWithFormat:@"title=%@", tv.title];
            
            Task *t = [[self.context executeFetchRequest:req error:NULL] lastObject];
            NSLog(@"Deleting %@", [t title]);
            [self.context deleteObject:t];
            
            [self reloadCollectionView];
            
        }else{
            NSLog(@"Deletion Canceled");
        }
    
    }];
}

- (void)reloadCollectionView{
    [super reloadCollectionView];
    if([self.flowLayout isKindOfClass:[DynamicFlowLayout class]]){
        [self.flowLayout performSelector:@selector(reset)];
    }
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


@end
