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

@interface TaskListCollectionVC() <newTask>
@property (strong, nonatomic) NewTaskVC *presentedVC;
@end

@implementation TaskListCollectionVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self reloadCollectionView];
}

- (void)taskCreated{
   [self reloadCollectionView];
    [self.presentedVC dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskCanceled{
    [self.presentedVC dismissViewControllerAnimated:YES completion:NULL];
}

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
            colCell.lcv.title = t.description;
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
        NSLog(@"%@", [err description]);
    }else{
        NSLog(@"Fetched List %@", self.title);
    }
}

#define COLLECTION_VIEW_CELL_PADDING 10
#define COLLECTION_VIEW_CELL_HEIGHT 100

- (void)setCollectionViewCellSize{
    CGFloat width = self.view.frame.size.width - COLLECTION_VIEW_CELL_PADDING;
    CGFloat height = COLLECTION_VIEW_CELL_HEIGHT;
    self.flowLayout.itemSize = CGSizeMake(width, height);
//    self.flowLayout.sectionInset
}

- (IBAction)swipeTask:(UIPanGestureRecognizer *)sender {

    NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:[sender locationInView:[self view]]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
    CollectionCell *cc = (CollectionCell *)cell;
    
    if(sender.state == UIGestureRecognizerStateChanged){
        cc.lcv.frame = CGRectMake(cc.lcv.frame.origin.x + [sender translationInView:[self view]].x, cc.lcv.frame.origin.y, cc.lcv.frame.size.width, cc.lcv.frame.size.height);
        cc.lcv.alpha = 1 - (abs(cc.lcv.frame.origin.x) / cc.lcv.frame.size.width);
        [sender setTranslation:CGPointZero inView:[self view]];
    }else if(sender.state == UIGestureRecognizerStateEnded){
        if(cc.lcv.frame.origin.x < cc.lcv.frame.size.width / 3 * -1){
            // TODO: Remove object
            [UIView animateWithDuration:.75 animations:^{
                cc.lcv.alpha = 0;
                cc.lcv.frame = CGRectMake(cc.lcv.frame.size.width * -1, cc.lcv.frame.origin.y , cc.lcv.frame.size.width, cc.lcv.frame.size.height);
            }];
        }else if(cc.lcv.frame.origin.x > cc.lcv.frame.size.width / 3){
            [UIView animateWithDuration:.75 animations:^{
                cc.lcv.alpha = 0;
                cc.lcv.frame = CGRectMake(cc.lcv.frame.size.width, cc.lcv.frame.origin.y, cc.lcv.frame.size.width, cc.lcv.frame.size.height);
            }];
        }else{
            [UIView animateWithDuration:.75 animations:^{
                cc.lcv.frame = CGRectMake(0, 0, cc.lcv.frame.size.width, cc.lcv.frame.size.height);
                cc.lcv.alpha = 1;
            }];
        }
    }
}

@end
