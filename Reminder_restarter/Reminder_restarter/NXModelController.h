//
//  NXModelController.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXRemindItemsViewController;

@interface NXModelController : NSObject <UIPageViewControllerDataSource>

- (NXRemindItemsViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(NXRemindItemsViewController *)viewController;

@end
