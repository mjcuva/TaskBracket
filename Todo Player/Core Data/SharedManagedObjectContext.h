//
//  SharedManagedObjectContext.h
//  Task Bracket
//
//  Created by Marc Cuva on 7/15/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSManagedObjectContextCompletionHandler)(NSManagedObjectContext *);

@interface SharedManagedObjectContext : NSObject

+ (void)getSharedContextWithCompletionHandler:(NSManagedObjectContextCompletionHandler)completionHandler;

@end
