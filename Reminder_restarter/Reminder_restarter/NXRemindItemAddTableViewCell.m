//
//  NXRemindItemAddTableViewCell.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindItemAddTableViewCell.h"

@implementation NXRemindItemAddTableViewCell
@synthesize titleInputAdd;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleInputAdd.delegate = self;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
