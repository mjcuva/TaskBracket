//
//  SharedManagedObjectContext.m
//  Todo Player
//
//  Created by Marc Cuva on 7/15/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import "SharedManagedObjectContext.h"

@implementation SharedManagedObjectContext

+ (void)getSharedContextWithCompletionHandler:(completionHandler)block{
    static NSManagedObjectContext *context;
    if(!context){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Task Data"];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if(success){
                    context = document.managedObjectContext;
                    block(context);
                }
            }];
        }else if(document.documentState == UIDocumentStateClosed){
            [document openWithCompletionHandler:^(BOOL success){
                if(success){
                    context = document.managedObjectContext;
                    block(context);
                }
            }];
        }else{
            context = document.managedObjectContext;
            block(context);
        }
    }else{
        block(context);
    }
}

@end
