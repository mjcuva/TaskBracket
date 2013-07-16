//
//  Task+Description.m
//  Todo Player
//
//  Created by Marc Cuva on 7/16/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "Task+Description.h"

@implementation Task (Description)

- (NSString *)description{
    return [NSString stringWithFormat:@"%@\n%@\nDuration: %@", self.title, self.task_description, self.duration];
}

@end
