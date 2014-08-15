//
//  NXPageViewController.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXPageViewController.h"
#import "NXModelController.h"
#import "NXRemindItemsViewController.h"
#import "NXRemindCenter.h"

#define DEBUG 1

@interface NXPageViewController () {
    
}
@property (readonly, strong, nonatomic) NXModelController *modelController;
@end

@implementation NXPageViewController
@synthesize pageLimited;
@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.

    pageLimited = 12;
    _modelController = [[NXModelController alloc] init];
    
    self.delegate = self;
    self.dataSource = self.modelController;

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {	// for iPad
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.view.frame = pageViewRect;
    
    // init first page view
    NXRemindCenter* storage = [NXRemindCenter sharedInstance];
    NXRemindItemsViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    Page* getFirstPage = [storage getPageAtIndex:0];
    startingViewController.titleString = getFirstPage.name;
    startingViewController.number = [getFirstPage.pageNumber unsignedIntegerValue];
    
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        [self curlFirstPageView];
//    }
}

- (void)curlFirstPageView {
    CATransition* curlAnimation = [CATransition animation];	// 继承自CAAnimation
    curlAnimation.delegate = self;
    curlAnimation.duration = 0.2f;
    curlAnimation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    curlAnimation.type = @"pageCurl";
    curlAnimation.endProgress = 0.25f;
    
	curlAnimation.fillMode = kCAFillModeForwards;
    curlAnimation.subtype = kCATransitionFromBottom;
    curlAnimation.removedOnCompletion = NO;
    
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [[self.view layer] addAnimation:curlAnimation forKey:@"PageCurlAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPageViewController delegate methods


- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
#if DEBUG
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
#endif

}


- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController *currentViewController = self.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end
