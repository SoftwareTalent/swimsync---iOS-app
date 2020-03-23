//
//  MYSTextField.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/24/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSTextField.h"

@implementation MYSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor grayColor] setFill];
    
    CGSize size = [self.text sizeWithFont:self.font forWidth:1024 lineBreakMode:NSLineBreakByWordWrapping];
    
    //[[self placeholder] drawInRect:rect withAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName : self.font}];
    [self.placeholder drawInRect:CGRectMake(rect.origin.x, (rect.size.height - size.height) / 2, rect.size.width, size.height) withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
}

@end
