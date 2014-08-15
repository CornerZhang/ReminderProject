//
//  NXRemindTableView.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindTableView.h"

@implementation NXRemindTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newCell = [tableView dequeueReusableCellWithIdentifier:@"RemindItemCell" forIndexPath:indexPath];
    
    return newCell;
}

@end
