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

- (Queue *)lists{
    if(!_lists)
        _lists = [[Queue alloc] init];
    return _lists;
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
            Task *t = (Task *)object;
            colCell.lcv.description = t.description;
            colCell.lcv.title = t.title;
            [colCell.lcv setNeedsDisplay];
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

#pragma mark - Remove Item Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    return fabs(translation.x) > fabs(translation.y);
}

- (IBAction)swipeTask:(UIPanGestureRecognizer *)sender {

    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:[sender locationInView:[self view]]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
    CollectionCell *cc = (CollectionCell *)cell;
    ListView *swiped = cc.lcv;
    
    if(sender.state == UIGestureRecognizerStateChanged && cc.lcv == swiped){
        cc.lcv.frame = CGRectMake(cc.lcv.frame.origin.x + [sender translationInView:[self view]].x, cc.lcv.frame.origin.y, cc.lcv.frame.size.width, cc.lcv.frame.size.height);
        cc.lcv.alpha = 1 - (abs(cc.lcv.frame.origin.x) / cc.lcv.frame.size.width);
        [sender setTranslation:CGPointZero inView:[self view]];
    }else if(sender.state == UIGestureRecognizerStateEnded){
        if(cc.lcv.frame.origin.x < cc.lcv.frame.size.width / 3 * -1){
            [UIView animateWithDuration:.75 animations:^{
                cc.lcv.alpha = 0;
                cc.lcv.frame = CGRectMake(cc.lcv.frame.size.width * -1, cc.lcv.frame.origin.y , cc.lcv.frame.size.width, cc.lcv.frame.size.height);
            }completion:^(BOOL success){
                if(success){
                    [self showCancelWithListView:cc.lcv];
                }
            }];
        }else if(cc.lcv.frame.origin.x > cc.lcv.frame.size.width / 3){
            [UIView animateWithDuration:.75 animations:^{
                cc.lcv.alpha = 0;
                cc.lcv.frame = CGRectMake(cc.lcv.frame.size.width, cc.lcv.frame.origin.y, cc.lcv.frame.size.width, cc.lcv.frame.size.height);
            } completion:^(BOOL success){
                if(success){
                    [self showCancelWithListView:cc.lcv];
                }
            }];
        }else{
            // Gesture failed
            [UIView animateWithDuration:.75 animations:^{
                swiped.frame = CGRectMake(10, 0, swiped.frame.size.width, swiped.frame.size.height);
                swiped.alpha = 1;
            }];
        }
    }
}

// Finishes removing the cell swiped away
- (void) showCancelWithListView:(ListView *)lv{
    
    UIView *superView = [lv superview];

    [lv setHidden:YES];
    
    UndoView *undoButton = [[UndoView alloc] initWithFrame:CGRectMake(10, 0, lv.frame.size.width, lv.frame.size.height)];
    undoButton.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        undoButton.alpha = 1;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelRemove:)];
    [undoButton addGestureRecognizer:tap];
    [self performSelector:@selector(finishRemove) withObject:nil afterDelay:2];
    [self.lists enqueue:lv];
    [superView addSubview:undoButton];
}

- (void)cancelRemove:(UITapGestureRecognizer *)sender{
    
    ListView *undoneView;
    
    NSArray *views = [[[sender view] superview] subviews];
    for(id view in views){
        if([view isKindOfClass:[ListView class]]){
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
    
    ListView *lv = [self.lists peek];
    [self.lists dequeue];
    
    [UIView animateWithDuration:1 animations:^{
        NSArray *views = [[lv superview] subviews];
        for(id view in views){
            if([view isKindOfClass:[UndoView class]]){
                UndoView *uv = (UndoView *)view;
                uv.alpha = 0;
            }
        }
    } completion:^(BOOL success){
        if(![self.undoRemoves containsObject:lv]){
            
            UIView *superview = lv.superview;
            if([superview isKindOfClass:[CollectionCell class]]){
                CollectionCell *cc = (CollectionCell *)superview;
                cc.lcv = nil;
            }
            
            // Remove task and update collectionView
            NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
            req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
            req.predicate = [NSPredicate predicateWithFormat:@"title=%@", lv.title];
            
            Task *t = [[self.context executeFetchRequest:req error:NULL] lastObject];
            NSLog(@"Deleting %@", [t title]);
            [self.context deleteObject:t];
            
            if([self.lists isEmpty])
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
    req.predicate = [NSPredicate predicateWithFormat:@"title == %@ && lists.title = %@", cell.lcv.title, self.title];
    Task *task = [[self.context executeFetchRequest:req error:NULL] lastObject];
    assert(task != nil);
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"EditTask" sender:task];
}


@end
