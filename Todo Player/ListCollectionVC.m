//
//  ListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListCollectionVC.h"
#import "ItemList.h"

@interface ListCollectionVC ()
@property (strong, nonatomic) NSArray *taskLists;
@end

@implementation ListCollectionVC

- (void)setContext:(NSManagedObjectContext *)context{
    [super setContext:context];
    if(context){
        
        // Setup Request
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ItemList"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all
        
        // Perform Fetch
        NSError *err;
        self.taskLists = [context executeFetchRequest:request error:&err];
        
        if(err)
            NSLog(@"%@", [err description]);
        
        // Reload CollectionView
        [self reloadCollectionView];
    }
}

- (NSUInteger)numCollections{
    return [self.taskLists count];
}

- (NSString *)reuseID{
    return @"listCell";
}

- (void)updateCell:(UICollectionViewCell *)cell usingList:(id)list{
    // TODO: Add cell
}

- (id)listAtIndex:(NSUInteger)index{
    // TODO: Add database
    return nil;
}

@end
