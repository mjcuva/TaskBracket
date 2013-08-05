//
//  SharedManagedObjectContext.m
//  Task Bracket
//
//  Created by Marc Cuva on 7/15/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "SharedManagedObjectContext.h"
#import <CoreData/CoreData.h>

@implementation SharedManagedObjectContext

+ (void)getSharedContextWithCompletionHandler:(NSManagedObjectContextCompletionHandler)completionHandler{
    
    static NSManagedObjectContext *context;
    
    if(!context){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Task Data"];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if(success){
                    context = document.managedObjectContext;
                    completionHandler(context);
                }
            }];
        }else if(document.documentState == UIDocumentStateClosed){
            NSLog(@"Opening Document");
            [document openWithCompletionHandler:^(BOOL success){
                if(success){
                    context = document.managedObjectContext;
                    completionHandler(context);
                }
            }];
        }else{
            context = document.managedObjectContext;
            completionHandler(context);
        }
    }else{
        completionHandler(context);
    }
}

+ (void)save{
    [self getSharedContextWithCompletionHandler:^(NSManagedObjectContext *context){
        NSLog(@"Saved Context");
        [context save:NULL];
    }];
}

@end
