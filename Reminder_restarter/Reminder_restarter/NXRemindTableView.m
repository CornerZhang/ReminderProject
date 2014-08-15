//
//  NXRemindTableView.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-15.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXRemindTableView.h"

@interface NXRemindTableView ()
@property (assign, nonatomic) NSUInteger tailCount;
@end

@implementation NXRemindTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _tailCount = 1;
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1+_tailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newCell = nil;
    
    if (indexPath.row != (0+_tailCount)) {
        newCell = [tableView dequeueReusableCellWithIdentifier:@"RemindItemCell" forIndexPath:indexPath];
    }else{
        newCell = [tableView dequeueReusableCellWithIdentifier:@"RemindItemCell_add" forIndexPath:indexPath];
        newCell.textLabel.textColor = tableView.tintColor;
    }
    
    return newCell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 在编辑模式中加入插入选项
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing) {
        
        if (indexPath.row == (0+_tailCount)) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
        
    }
    
    return UITableViewCellEditingStyleNone;
    
}

@end
