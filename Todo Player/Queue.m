//
//  Queue.m
//  Task Bracket
//
//  Created by Marc Cuva on 8/17/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "Queue.h"

@interface Queue()
@property (strong, nonatomic) NSMutableArray *q;
@end

@implementation Queue

- (NSMutableArray *)q{
    if(!_q){
        _q = [[NSMutableArray alloc] init];
    }
    return _q;
}

- (void)enqueue:(id)object{
    [self.q insertObject:object atIndex:0];
}

- (id)peek{
    return [self.q lastObject];
}

- (void)dequeue{
    [self.q removeLastObject];
}

- (BOOL)isEmpty{
    return [self.q count] == 0;
}

@end
