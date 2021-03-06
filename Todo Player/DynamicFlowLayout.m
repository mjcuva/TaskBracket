//
//  DynamicFlowLayout.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/1/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "DynamicFlowLayout.h"

@implementation DynamicFlowLayout{
    UIDynamicAnimator *_dynamicAnimator;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    if(!_dynamicAnimator){
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for(UICollectionViewLayoutAttributes *item in items){
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = .5;
            spring.frequency = 1;
            
            [_dynamicAnimator addBehavior:spring];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *superItems = [super layoutAttributesForElementsInRect:rect];
    NSArray *newItems = [_dynamicAnimator itemsInRect:rect];
 
    if(self.panGestureRecognizer.state == UIGestureRecognizerStateFailed){
        return newItems;
    }else if(self.panGestureRecognizer.state == UIGestureRecognizerStatePossible){
        for(UICollectionViewLayoutAttributes *layout in newItems){
            [self applyLayoutAttributes:layout];
        }
        return newItems;
    }else{
        _dynamicAnimator = nil;
        return superItems;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *superLayout = [super layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *newLayout = [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
    if(self.panGestureRecognizer.state == UIGestureRecognizerStateFailed){
        return newLayout;
    }else if(self.panGestureRecognizer.state == UIGestureRecognizerStatePossible){
        [self applyLayoutAttributes:newLayout];
        return newLayout;
    }else{
        _dynamicAnimator = nil;
        return superLayout;
    }
}

#define RESISTANCE_FACTOR 800 // Higher resists less

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    for(UIAttachmentBehavior *spring in _dynamicAnimator.behaviors){
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabsf(anchorPoint.y - touchLocation.y);
        CGFloat scrollResistance = distanceFromTouch / RESISTANCE_FACTOR;
        
        UICollectionViewLayoutAttributes *attr = [spring.items firstObject];
        CGPoint center = attr.center;
        
        if(delta > 0){
            center.y += MIN(delta * scrollResistance, delta);
        }else{
            center.y += MAX(delta * scrollResistance, delta);
        }
        
        attr.center = center;
        
        [_dynamicAnimator updateItemUsingCurrentState:attr];
    }
    
    
    return NO;
}

// Resets the dynamic animator and reprepares the layout
- (void)reset{
    _dynamicAnimator = nil;
    [self prepareLayout];
}

@end
