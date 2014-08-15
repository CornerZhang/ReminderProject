//
//  NXRemindItemTableViewCell.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindItemTableViewCell.h"

@implementation NXRemindItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

@end
