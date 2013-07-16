//
//  TaskListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 7/4/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskListCollectionVC.h"
#import "NewTaskVC.h"
#import "CollectionCell.h"
#import "Task+Description.h"

@interface TaskListCollectionVC()
@end

@implementation TaskListCollectionVC

- (NSUInteger)numCollections{
    return [self.taskLists count];
}

- (id)listAtIndex:(NSUInteger)index{
    return self.taskLists[index];
}

- (NSString *)reuseID{
    return @"TaskListCell";
}

- (void)updateCell:(UICollectionViewCell *)cell usingList:(id)list{
    if([cell isKindOfClass:[CollectionCell class]]){
        if([list isKindOfClass:[Task class]]){
            CollectionCell *colCell = (CollectionCell *)cell;
            Task *t = (Task *)list;
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
        [[dvc.navigationController.viewControllers objectAtIndex:0] performSelector:@selector(setListTitle:) withObject:self.title];
    }
}

- (void)createTaskList{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    req.predicate = [NSPredicate predicateWithFormat:@"lists.title == %@", self.title];
    
    // Perform Fetch
    NSError *err;
    self.taskLists = [self.context executeFetchRequest:req error:&err];
    NSLog(@"%@", [[self.taskLists lastObject] description]);
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

@end
