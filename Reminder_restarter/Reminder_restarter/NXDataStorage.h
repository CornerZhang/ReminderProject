//
//  NXDataStorage.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-5.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page;

@interface NXDataStorage : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype) sharedInstance;

- (BOOL)		isEmpty;

- (void)		saveContextWhenChanged;
- (void)		saveContext;
- (NSURL *)		applicationDocumentsDirectory;

- (Page*)		createBlankPageWithPageNumber;
- (Page*)		getPageAtIndex:(NSInteger)index;
- (Page*)		getPageAtIndexPath:(NSIndexPath *)indexPath;

@end
