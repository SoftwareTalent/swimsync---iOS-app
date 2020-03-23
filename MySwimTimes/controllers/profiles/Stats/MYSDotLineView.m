//
//  MYSDotLineView.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/11/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSDotLineView.h"

@interface MYSDotLineView()

@property (nonatomic, strong) UIColor *color;

@end

@implementation MYSDotLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setDotColor:(UIColor *)color
{
    self.color = color;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect parentViewBounds = self.bounds;
//    CGFloat width = parentViewBounds.size.width;
    CGFloat height = parentViewBounds.size.height;
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // define line width
    CGContextSetLineWidth(ctx, 5);
    
    float pos = 0;
    while (pos < self.frame.size.width)
    {
        // define stroke color
        //CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        
        float realx1 = pos;
        float realy1 = height * 0.5;
        
        float realx2 = pos + 4;
        float realy2 = height * 0.5;
        
        CGContextMoveToPoint(ctx, realx1, realy1);
        CGContextAddLineToPoint(ctx, realx2, realy2);
        
        CGContextStrokePath(ctx);
        
        CGContextClosePath(ctx);
        
        pos += 6;
    }
}


@end
