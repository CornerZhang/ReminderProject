//
//  Page.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-14.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RemindItem;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pageNumber;
@property (nonatomic, retain) NSSet *remindList;
@end

@interface Page (CoreDataGeneratedAccessors)

- (void)addRemindListObject:(RemindItem *)value;
- (void)removeRemindListObject:(RemindItem *)value;
- (void)addRemindList:(NSSet *)values;
- (void)removeRemindList:(NSSet *)values;

@end
