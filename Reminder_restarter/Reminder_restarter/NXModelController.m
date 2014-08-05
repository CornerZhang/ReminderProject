//
//  NXModelController.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXModelController.h"
#import "NXRemindItemsViewController.h"

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

@interface NXModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation NXModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
        
        _contentPageViews = [[NSMutableArray alloc] init];
        for (int i=0; i<[_pageData count]; ++i) {
            const NXPageRecord* pageRecord = [[NXPageRecord alloc] init];
            [_contentPageViews addObject:pageRecord];	// NSArray内不能放nil对象指针
        }
        NSLog(@"pages count %d", [_contentPageViews count]);

    }
    return self;
}

- (NXRemindItemsViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    NXPageRecord* pageRecord = [_contentPageViews objectAtIndex:index];
    if ( pageRecord.used == NO) {

        // Create a new view controller and pass suitable data.
        NXRemindItemsViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"NXRemindItemsViewController"];
        
        dataViewController.titleString = self.pageData[index];
        
        pageRecord.pageView = dataViewController;
        pageRecord.used = YES;
    }
    
    return pageRecord.pageView;
}

- (NSUInteger)indexOfViewController:(NXRemindItemsViewController *)viewController
{       
    BOOL (^condition)(NXPageRecord* , NSUInteger , BOOL *) = ^(NXPageRecord* obj, NSUInteger idx, BOOL *stop)
    {
        if (obj.pageView == viewController) {
            return YES;
        }
        return NO;
    };
    
    return [_contentPageViews indexOfObjectPassingTest:condition];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(NXRemindItemsViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(NXRemindItemsViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
