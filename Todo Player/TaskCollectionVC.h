//
//  TaskCollectionVC.h
//  Task Bracket
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//
//  Abstract base class for a collection view containing a list of tasks

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface TaskCollectionVC : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;

- (void)reloadCollectionView;

// Abstract
- (NSUInteger)numCollections;
- (NSString *)reuseID;
- (void)updateCell:(UICollectionViewCell *)cell;
- (id)objectAtIndex:(NSUInteger)index;
- (NSString *)entityName;
- (void)createObjectList;
- (BaseView *)cellView;

- (void)setCollectionViewCellSize;

// Override for custom view width
- (NSUInteger)viewWidth;
// Override for custom origin
- (NSUInteger)viewX;

@property (strong, nonatomic) NSArray *objectList;

/**
 Array of views to be used by superclass in index order
 */
@property (strong, nonatomic) NSMutableArray *viewList;

- (void)loadViewList;

@end
