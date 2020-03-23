//
//  MYSStickView.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/17/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSStickView.h"

@interface MYSStickView()

@property (nonatomic, retain) NSMutableArray *aryGraphDatas;

@property (nonatomic, assign) float interval;

@end

@implementation MYSStickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) graphData:(NSMutableArray *)aryGraphDatas interval:(float)interval
{
    self.aryGraphDatas = aryGraphDatas;
    self.interval = interval;
    
    CGRect parentViewBounds = self.bounds;
//    CGFloat width = parentViewBounds.size.width;
    CGFloat height = parentViewBounds.size.height;
    
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews)
    {
        [subview removeFromSuperview];
    }
    
    float stickWidth = interval * 0.5;

    for (int index = 0 ; index < aryGraphDatas.count ; index ++)
    {
        float y = [[self.aryGraphDatas objectAtIndex:index] floatValue];
        
        float realx = self.interval * (index + 1);
        float realy = height * y;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(realx - stickWidth / 2, height - realy, stickWidth, realy)];
        view.backgroundColor = [UIColor colorWithRed:109.0f / 255.0f green:180.0f / 255.0f  blue:240.0f / 255.0f alpha:0.8f];

        [self addSubview:view];
    }
}

@end
