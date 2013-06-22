//
//  TaskCollectionVC.h
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//
//  Abstract base class for a collection view containing a list of tasks

#import <UIKit/UIKit.h>

@interface TaskCollectionVC : UIViewController

// Abstract
- (NSUInteger)numCollections;
- (NSString *)reuseID;
- (void)updateCell:(UICollectionViewCell *)cell usingList:(id)list;
- (id)listAtIndex:(NSUInteger)index;

@end
