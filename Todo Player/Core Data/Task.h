//
//  Task.h
//  Task Bracket
//
//  Created by Marc Cuva on 11/3/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemList;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * enqueued;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * list_location;
@property (nonatomic, retain) NSNumber * queue_location;
@property (nonatomic, retain) ItemList *lists;

@end
