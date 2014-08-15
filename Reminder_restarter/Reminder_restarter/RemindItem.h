//
//  RemindItem.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-14.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page;

@interface RemindItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * beRise;
@property (nonatomic, retain) NSDate * 	dataTime;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * repeatMode;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * timeZone;
@property (nonatomic, retain) NSNumber * withDateTime;
@property (nonatomic, retain) NSString * soundName;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSNumber * taskCompleted;
@property (nonatomic, retain) Page *	ownerPage;

@end
