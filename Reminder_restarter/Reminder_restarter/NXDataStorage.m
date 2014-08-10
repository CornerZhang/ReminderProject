//
//  NXDataStorage.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-5.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXDataStorage.h"
#import "Page.h"

@interface NXDataStorage () <NSFetchedResultsControllerDelegate> {
    
}
@property (nonatomic, strong) NSFetchedResultsController* frc;
@property (nonatomic, strong) NSEntityDescription* entityDesc;

@end

static NXDataStorage* only = nil;

@implementation NXDataStorage
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype) sharedInstance {
    @synchronized(self) {
        if (only==nil) {
            only = [[NXDataStorage alloc] init];
        }
    }
    return only;
}

- (id) init {
	self = [super init];
    
    //userDrivenDataModelChange = NO;
    
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
    
    NSError *fetchingError = nil;
    if ([self.frc performFetch:&fetchingError]){
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch.");
    }
        
    NSLog(@"RMStorageManager msg: %@",NSStringFromSelector(_cmd));
    return self;
}

- (BOOL)isEmpty {
    if ([self.frc.fetchedObjects count] == 0) {
        return YES;
    }
    
    return NO;
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

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

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
