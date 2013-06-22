//
//  TaskCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "TaskCollectionVC.h"

@interface TaskCollectionVC () <UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@end

@implementation TaskCollectionVC

- (void)viewDidLoad{
    self.collectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numCollections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseID forIndexPath:indexPath];
    id list = [self listAtIndex:indexPath.item];
    [self updateCell:cell usingList:list];
    return cell;
}

#pragma mark - Abstract

- (NSUInteger)numCollections{
    return 0;
}

- (NSString *)reuseID{
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingList:(id)list{

}


- (id)listAtIndex:(NSUInteger)index{
    return nil;
}

@end
