//
//  ListCollectionVC.m
//  Todo Player
//
//  Created by Marc Cuva on 6/21/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "ListCollectionVC.h"

@interface ListCollectionVC ()

@end

@implementation ListCollectionVC

- (NSUInteger)numCollections{
    // TODO: Add database
    return 30;
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
