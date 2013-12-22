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
    [self setCollectionViewCellSize];
    [self createObjectList];
    [self loadViewList];
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
        if(collectionCell.view != [self.viewList objectAtIndex:indexPath.item]){
            if(cell.subviews != nil){
                NSArray *views = cell.subviews;
                for(UIView *view in views){
                    [view removeFromSuperview];
                }
            }
            BaseView *view = [self.viewList objectAtIndex:indexPath.item];
            [collectionCell addSubview:view];
            collectionCell.view = view;
        }
        if(LOG_ITEM_NUMBER)
            NSLog(@"Item Number: %ul", indexPath.item);
        [self updateCell:collectionCell];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    BaseView *view = [[self viewList] objectAtIndex:indexPath.item];
    CGFloat height = MAX(self.flowLayout.itemSize.height, [view idealHeight]);
    return CGSizeMake(self.flowLayout.itemSize.width, height);
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

- (void)updateCell:(UICollectionViewCell *)cell{

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

- (void)loadViewList{
    
}

- (NSMutableArray *)viewList{
    if(!_viewList){
        _viewList = [[NSMutableArray alloc] init];
    }
    return _viewList;
}

- (BOOL)canMoveItems{
    return NO;
}

- (void)moveItemFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    
}

#pragma mark - LXReorderableCollectionView Delegate

- (BOOL) collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self canMoveItems];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath{
    [self moveItemFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadCollectionView];
}

@end
    