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

- (id)listAtIndex:(NSUInteger)index{
    return self.taskLists[index];
}

- (NSString *)entityName{
    return @"ItemList";
}

- (void)createListWithTitle:(NSString *)title{
    ItemList *list = [NSEntityDescription insertNewObjectForEntityForName:@"ItemList" inManagedObjectContext:self.context];
    list.title = title;
}

@end
