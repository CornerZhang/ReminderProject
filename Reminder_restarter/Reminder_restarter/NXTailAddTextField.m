//
//  NXTailAddTextField.m
//  Reminder_restarter
//
//  Created by CornerZhang on 14-8-21.
//  Copyright (c) 2014年 NeXtreme.com. All rights reserved.
//

#import "NXTailAddTextField.h"

@implementation NXTailAddTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return YES;
}

@end
