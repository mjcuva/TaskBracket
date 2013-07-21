//
//  Task.h
//  Task Bracket
//
//  Created by Marc Cuva on 6/23/13.
//  Copyright (c) 2013 Marc Cuva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSManagedObject *playlist;
@property (nonatomic, retain) NSManagedObject *lists;

@end
