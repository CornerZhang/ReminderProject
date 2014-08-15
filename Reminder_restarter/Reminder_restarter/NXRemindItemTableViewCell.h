//
//  NXRemindItemTableViewCell.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXRemindItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *titleInput;
@property (strong, nonatomic) IBOutlet UILabel *zoneRepeatTime;

@end
