//
//  ItemList.h
//  Task Bracket
//
//  Created by Marc Cuva on 8/31/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface ItemList : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * red_color;
@property (nonatomic, retain) NSNumber * blue_color;
@property (nonatomic, retain) NSNumber * green_color;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface ItemList (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
