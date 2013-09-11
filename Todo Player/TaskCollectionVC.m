//
//  TaskCollectionVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskCollectionVC.h"
#import "CollectionCell.h"
#import "SharedManagedObjectContext.h"
#import <CoreData/CoreData.h>

@interface TaskCollectionVC () <UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIAlertViewDelegate>

@end

@implementation TaskCollectionVC

#define LOG_ITEM_NUMBER NO

- (void)viewDidLoad{
    self.collectionView.dataSource = self;
    [SharedManagedObjectContext getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        self.context = context;
    }];
    [self setCollectionViewCellSize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setCollectionViewCellSize];
    [self.collectionView reloadData];
}



- (void)reloadCollectionView{
    [self createObjectList];
    [self.collectionView reloadData];
    if([self.flowLayout respondsToSelector:@selector(reset)])
        [self.flowLayout performSelector:@selector(reset)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numCollections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseID] forIndexPath:indexPath];
    if([cell isKindOfClass:[CollectionCell class]]){
        CollectionCell *collectionCell = (CollectionCell *)cell;
        if(!collectionCell.view){
            BaseView *view = [self cellView];
            collectionCell.view = view;
            [collectionCell addSubview:view];
        }
        if(LOG_ITEM_NUMBER)
            NSLog(@"Item Number: %ul", indexPath.item);
        id list = [self objectAtIndex:indexPath.item];
        [self updateCell:collectionCell usingObject:list];
    }
    return cell;
}

- (void)setContext:(NSManagedObjectContext *)context{
    _context = context;
    if(context){ 
        [self reloadCollectionView];
    }
}


#pragma mark - Abstract

- (NSUInteger)numCollections{
    return 0;
}

- (NSString *)reuseID{
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingObject:(id)object{

}

- (id)objectAtIndex:(NSUInteger)index{
    return nil;
}

- (NSString *)entityName{
    return nil;
}

- (void)createObjectList{
    
}

- (void)setCollectionViewCellSize{
    
}

- (NSUInteger)viewWidth{
    return self.flowLayout.itemSize.width;
}

- (NSUInteger)viewX{
    return 0;
}

- (BaseView *)cellView{
    return nil;
}

@end
    