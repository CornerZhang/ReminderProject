//
//  NXRemindItemsViewController.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-4.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXRemindItemsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *pageName;
@property (strong, nonatomic) IBOutlet UILabel *pageNumber;
@property (strong, nonatomic) NSString* titleString;
@property (assign, nonatomic) NSUInteger number;
@end
