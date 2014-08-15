//
//  NXRemindCenter.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-14.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindCenter.h"
#import <EventKit/EventKit.h>

NSString* CalendarIdentifyKey = @"RemindNote_AppCalendar";

@implementation RemindItem (PostMessageExtension)
@dynamic presentZone;
@dynamic weekdaysFlags;

@end

@interface NXRemindCenter () {
    
}
@property (strong, nonatomic) NSFetchedResultsController* frc;
@property (strong, nonatomic) NSEntityDescription* entityDesc;

@property (strong, nonatomic) EKEventStore* eventStore;
@property (strong, nonatomic) EKCalendar*	calendar;
@end

static NXRemindCenter* only = nil;

@implementation NXRemindCenter
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype) sharedInstance {
    @synchronized(self) {
        if (only==nil) {
            only = [[NXRemindCenter alloc] init];
        }
    }
    return only;
}

- (id) init {
	self = [super init];
    
    //userDrivenDataModelChange = NO;
    [self initEventKit];
    
    /* Create the fetch request first */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    self.entityDesc = [self entityDescription];
    [fetchRequest setEntity:self.entityDesc];
	[fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *pageSort = [[NSSortDescriptor alloc] initWithKey:@"pageNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[pageSort];
    
    self.frc = [[NSFetchedResultsController alloc]
                initWithFetchRequest:fetchRequest
                managedObjectContext:[self managedObjectContext]
                sectionNameKeyPath:nil
                cacheName:@"Master"];
    
    self.frc.delegate = self;
    
    NSLog(@"RMStorageManager msg: %@",NSStringFromSelector(_cmd));
    
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // create 6 new pages & blank remindItem
        for (int i=0; i<6; ++i) {
            Page* newPage = [self createBlankPage];
            newPage.name = [NSString stringWithFormat:@"新页 %d", i+1];
            newPage.pageNumber = [NSNumber numberWithUnsignedInteger:i+1];
        }
        [self saveContextWhenChanged];
	}

	[self fetchResults];

    // init page data
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // create 6 new pages & blank remindItem
        for (int i=0; i<6; ++i) {
            Page* newPage = [self createBlankPage];
            newPage.name = [NSString stringWithFormat:@"新页 %d", i+1];
            newPage.pageNumber = [NSNumber numberWithUnsignedInteger:i+1];
        }
        [self saveContextWhenChanged];
	}

    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)		importItemsFromDevice {
    
}

- (void)initEventKit {
    // event store
    _eventStore = [[EKEventStore alloc] init];
    
    // request authorization
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {	// EKEntityTypeEvent: 事件; EKEntityTypeReminder: 提醒
        case EKAuthorizationStatusAuthorized:
            NSLog(@"EKAuthorizationStatusAuthorized");
            break;
            
        case EKAuthorizationStatusDenied:
            NSLog(@"EKAuthorizationStatusDenied");
            break;
            
        case EKAuthorizationStatusNotDetermined: {
            NSLog(@"EKAuthorizationStatusNotDetermined");
            [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError* error){
//                if (granted) {
//                    [self insertEventIntoStore:_eventStore];
//                }else{
//                    [self displayAccessDenied];
//                }
            }];
            break;
        }
        case EKAuthorizationStatusRestricted:
            NSLog(@"EKAuthorizationStatusRestricted");
            break;
    }
    
    // source
    EKSource* foundLocalSource = nil;
    for (EKSource* source in _eventStore.sources) {
        if (source.sourceType == EKSourceTypeLocal) {
            foundLocalSource = source;
            NSLog(@"local source title - %@", foundLocalSource.title);
        }
    }
    
    // calendar
    NSString* calenderIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:CalendarIdentifyKey];
    _calendar = [_eventStore calendarWithIdentifier:calenderIdentifier];
    if (_calendar==nil) {
        _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];
        _calendar.title = CalendarIdentifyKey;
        _calendar.source = foundLocalSource;

        if ( ![_eventStore saveCalendar:_calendar commit:YES error:nil] ) {
            NSLog(@"Failed to save %@", _calendar.title);
        }
        [[NSUserDefaults standardUserDefaults] setObject:_calendar.calendarIdentifier forKey:CalendarIdentifyKey];
    }
}

- (NSUInteger)	numberOfFetchedObjects {
    return [self.frc.fetchedObjects count];
}

- (Page*)		findPageByIndex:(NSUInteger)index {
    return nil;
    
}

- (Page*) createBlankPageWithPageNumber {
    Page* newPage = [self createBlankPage];
    
    NSManagedObject* lastItem = [self.frc.fetchedObjects lastObject];
    NSInteger lastOrder = [[lastItem valueForKey:@"pageNumber"] unsignedIntegerValue];
    newPage.pageNumber  = [NSNumber numberWithUnsignedInteger:lastOrder+1];
    
    return newPage;
}

- (Page*)		createBlankPage {
    Page* newPage = [NSEntityDescription insertNewObjectForEntityForName:[self.entityDesc name]
                                                  inManagedObjectContext:self.managedObjectContext];
	return newPage;
}

- (Page*)		getPageAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [self getPageAtIndexPath:indexPath];
}

- (Page*) getPageAtIndexPath:(NSIndexPath *)indexPath {
    return [self.frc.fetchedObjects objectAtIndex:indexPath.row];
}

- (RemindItem*)findItemByName:(NSString*)name {
    return nil;
}

- (RemindItem*)createBlankItem:(NSString*)name {
    return nil;
}

- (void)saveContextWhenChanged
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)saveContext {
    NSError *savingError = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if ([managedObjectContext save:&savingError]){
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch.");
    }
}

- (void)		postItem:(RemindItem*)msg {
    
}

- (void)		canceItem:(RemindItem*)msg {
    
}

- (void)		cancelAllItems {
    
}

#pragma mark - Core Data stack

- (void)fetchResults {
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError]){
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch.");
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PagedRemindItem" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PagedRemindItem.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(NSEntityDescription *) entityDescription
{
    return [NSEntityDescription entityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
}

@end
