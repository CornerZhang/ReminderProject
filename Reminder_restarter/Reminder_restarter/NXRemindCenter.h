//
//  NXRemindCenter.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-14.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "Page.h"
#import "RemindItem.h"

typedef NS_ENUM(NSUInteger, NXRepeatMode) {
	RMRepeatMode_Once = 0,
    RMRepeatMode_Year,
    RMRepeatMode_Month,
    RMRepeatMode_Weekdays
};

typedef NS_ENUM(NSUInteger, NXWeekdays) {
	RMWeekday_1 = 1,
    RMWeekday_2 = 1<<1,
    RMWeekday_3 = 1<<2,
    RMWeekday_4 = 1<<3,
    RMWeekday_5 = 1<<4,
    RMWeekday_Sat = 1<<5,
    RMWeekday_Sun = 1<<6
};

@interface RemindItem (PostMessageExtension)
@property (strong, nonatomic) NSTimeZone*	presentZone;
@property (assign, nonatomic) NXWeekdays	weekdaysFlags;
@end

@interface NXRemindCenter : NSObject <NSFetchedResultsControllerDelegate>
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (NSURL *)		applicationDocumentsDirectory;
- (void)		importItemsFromDevice;

// data
- (NSUInteger)	numberOfFetchedObjects;
- (Page*)		findPageByIndex:(NSUInteger)index;
- (Page*)		createBlankPageWithPageNumber;
- (Page*)		createBlankPage;
- (Page*)		getPageAtIndex:(NSInteger)index;
- (Page*)		getPageAtIndexPath:(NSIndexPath *)indexPath;

- (RemindItem*)	findItemByName:(NSString*)name;
- (RemindItem*)	createBlankItem:(NSString*)name;

- (void)		saveContextWhenChanged;
- (void)		saveContext;

// post & cancel some item
- (void)		postItem:(RemindItem*)msg;
- (void)		canceItem:(RemindItem*)msg;
- (void)		cancelAllItems;

@end
