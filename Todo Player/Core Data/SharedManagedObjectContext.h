//
//  SharedManagedObjectContext.h
//  Todo Player
//
//  Created by Marc Cuva on 7/15/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completionHandler)(NSManagedObjectContext *);

@interface SharedManagedObjectContext : NSObject

+ (void)getSharedContextWithCompletionHandler:(completionHandler)block;

@end
