//
//  TaskCollectionVC.m
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskCollectionVC.h"
#import "CollectionCell.h"
#import "ListView.h"
#import "SharedManagedObjectContext.h"
#import <CoreData/CoreData.h>

@interface TaskCollectionVC () <UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIAlertViewDelegate>

@end

@implementation TaskCollectionVC



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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numCollections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseID] forIndexPath:indexPath];
    if([cell isKindOfClass:[CollectionCell class]]){
        CollectionCell *collectionCell = (CollectionCell *)cell;
        if(!collectionCell.lcv){
            ListView *lv = [[ListView alloc] initWithFrame:CGRectMake([self viewX], 0, [self viewWidth], self.flowLayout.itemSize.height)];
            collectionCell.lcv = lv;
            [collectionCell addSubview:lv];
        }
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath:%@", [indexPath description]);
//    [self performSegueWithIdentifier:@"ShowList" sender:[self listAtIndex:indexPath.item]];
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

@end
    