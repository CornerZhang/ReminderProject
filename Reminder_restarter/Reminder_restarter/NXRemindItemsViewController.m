//
//  NXRemindItemsViewController.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindItemsViewController.h"

@interface NXRemindItemsViewController ()

@end

@implementation NXRemindItemsViewController
@synthesize titleString;
@synthesize number;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.pageName.text = titleString;
    self.pageNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.number];
}

@end
