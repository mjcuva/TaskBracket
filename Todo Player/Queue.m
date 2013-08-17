//
//  Queue.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/17/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "Queue.h"

@implementation Queue{
    NSMutableArray *q;
}

- (void)enqueue:(id)object{
    [q insertObject:object atIndex:0];
}

- (id)peek{
    return [q lastObject];
}

- (void)dequeue{
    [q removeLastObject];
}

@end
