//
//  ListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListCollectionVC.h"
#import "ItemList+Description.h"
#import "CollectionCell.h"

@interface ListCollectionVC ()
@end

#define COLLECTION_VIEW_CELL_PADDING 20
#define COLLECTION_VIEW_NAVBAR_OFFSET 44
#define COLLECTION_VIEW_STATUSBAR_OFFSET 20
#define COLLECTION_VIEW_OFFSET 10

@implementation ListCollectionVC

- (NSUInteger)numCollections{
    NSLog(@"%@", [self.taskLists description]);
    return [self.taskLists count];
}

- (NSString *)reuseID{
    return @"listCell";
}

- (void)updateCell:(UICollectionViewCell *)cell usingList:(id)list{
    if([cell isKindOfClass:[CollectionCell class]]){
        if([list isKindOfClass:[ItemList class]]){
            CollectionCell *colCell = (CollectionCell *)cell;
            ItemList *iList = (ItemList *)list;
            colCell.lcv.title = iList.title;
            [colCell.lcv setNeedsDisplay];
        }
    }
}

- (void)setCollectionViewCellSize{
    CGFloat size = self.view.frame.size.width / 2 - COLLECTION_VIEW_CELL_PADDING;
    self.flowLayout.itemSize = CGSizeMake(size, size);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_VIEW_NAVBAR_OFFSET + COLLECTION_VIEW_OFFSET + COLLECTION_VIEW_STATUSBAR_OFFSET, COLLECTION_VIEW_OFFSET, 44, COLLECTION_VIEW_OFFSET);
}

- (id)listAtIndex:(NSUInteger)index{
    return self.taskLists[index];
}

- (NSString *)entityName{
    return @"ItemList";
}

- (id)createListWithTitle:(NSString *)title{
    ItemList *list = [NSEntityDescription insertNewObjectForEntityForName:@"ItemList" inManagedObjectContext:self.context];
    list.title = title;
    return list;
}

- (void) createTaskList{
    // Setup Request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = nil; // all
    
    // Perform Fetch
    NSError *err;
    self.taskLists = [self.context executeFetchRequest:request error:&err];
    
    if(err)
        NSLog(@"%@", [err description]);
    else
        NSLog(@"New Task List Created");
}

@end
