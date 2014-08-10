//
//  NXModelController.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXModelController.h"
#import "NXRemindItemsViewController.h"
#import "NXDataStorage.h"
#import "Page.h"

@implementation NXPageRecord
@synthesize pageView;
@synthesize used;

- (instancetype)init {
    self = [super init];
    if (self) {
        pageView = nil;
        used = NO;
    }
    return self;
}

@end



/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface NXModelController() {
    NSUInteger pageNumberLimited;
    NXDataStorage* dataStorage;
}
@end

@implementation NXModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        pageNumberLimited = 5;	// [0,6)
        dataStorage = [NXDataStorage sharedInstance];
        
        _contentPageViews = [[NSMutableArray alloc] init];
        for (int i=0; i<=pageNumberLimited; ++i) {
            const NXPageRecord* pageRecord = [[NXPageRecord alloc] init];
            [_contentPageViews addObject:pageRecord];	// NSArray内不能放nil对象指针
        }
        NSLog(@"ready pages count %d", [_contentPageViews count]);

    }
    return self;
}

- (NXRemindItemsViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (index > pageNumberLimited) {
        return nil;
    }
    
    NXPageRecord* pageRecord = [_contentPageViews objectAtIndex:index];
    if ( pageRecord.used == NO) {
        // Create a new view controller
        NXRemindItemsViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"NXRemindItemsViewController"];
                
        pageRecord.pageView = dataViewController;
        pageRecord.used = YES;
    }
    
    return pageRecord.pageView;
}

- (NSUInteger)indexOfViewController:(NXRemindItemsViewController *)viewController
{       
    BOOL (^findCondition)(NXPageRecord* , NSUInteger , BOOL *) = ^(NXPageRecord* obj, NSUInteger idx, BOOL *stop)
    {
        if (obj.pageView == viewController) {
            return YES;
        }
        return NO;
    };
    
    return [_contentPageViews indexOfObjectPassingTest:findCondition];
}

- (BOOL)existContextPageIndex:(NSUInteger)index {
    NXPageRecord* record = [_contentPageViews objectAtIndex:index];
    return record.used;
}

- (NXPageRecord*)getPageRecordIndex:(NSUInteger)index {
    return [_contentPageViews objectAtIndex:index];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(NXRemindItemsViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    [dataStorage saveContextWhenChanged];
    index--;
    
    NXRemindItemsViewController* pageView =  [self viewControllerAtIndex:index storyboard:viewController.storyboard];

    return pageView;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(NXRemindItemsViewController *)viewController];
    if ((index >= pageNumberLimited) || index == NSNotFound) {
        return nil;
    }
    
    [dataStorage saveContextWhenChanged];
    index++;
    
    NXRemindItemsViewController *pageView = nil;
    NXPageRecord* record = [self getPageRecordIndex:index];
    if ( !record.used ) {
        // create a new page data
        Page* newPage = [dataStorage createBlankPage];
        newPage.name = [NSString stringWithFormat:@"新页 %d", index+1];
		newPage.pageNumber = [NSNumber numberWithUnsignedInteger:index+1];
        
        // create new page view
        pageView = [pageViewController.storyboard instantiateViewControllerWithIdentifier:@"NXRemindItemsViewController"];
        record.pageView = pageView;
        record.used = YES;
        
        pageView.titleString = newPage.name;
    }else{
        // get the page data to view
        pageView = [self viewControllerAtIndex:index storyboard:viewController.storyboard];
    }
    
    return pageView;
}

@end
