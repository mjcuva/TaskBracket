//
//  Queue.h
//  Task Bracket
//
//  Created by Marc Cuva on 8/17/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject

/**
 Adds object to the queue
 @param Object object to be added to the queue
 @return None
 */
- (void)enqueue:(id)object;

/**
 Returns the next object in the queue
 @param None
 @return Next object in the queue
*/
- (id)peek;

/**
 Removes the next object from the queue
 @param None
 @return None
 */
- (void)dequeue;

@end
