//
//  NXRemindItemAddTableViewCell.h
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXRemindItemAddTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *titleInputAdd;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
