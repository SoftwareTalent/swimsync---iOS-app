//
//  MYSGraphView.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/11/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSGraphView.h"

@interface MYSGraphView()

@property (nonatomic, retain) NSMutableArray *aryGraphDatas;
@property (nonatomic, retain) NSMutableArray *aryAnotherGraphDatas;

@property (nonatomic, retain) NSString *anotherSwimmerName;

@property (nonatomic, assign) float interval;

@end

@implementation MYSGraphView

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
    
    self.aryAnotherGraphDatas = nil;
    
    [self setNeedsDisplay];
    
    [self addDotOfTime];
}

- (void) anotherGraphData:(NSMutableArray *)aryGraphDatas interval:(float)interval name:(NSString *)name
{
    self.anotherSwimmerName = [[NSString alloc] initWithString:name];
    self.aryAnotherGraphDatas = aryGraphDatas;
    
    [self setNeedsDisplay];
    
    [self addDotOfTime];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect parentViewBounds = self.bounds;
//    CGFloat width = parentViewBounds.size.width;
    CGFloat height = parentViewBounds.size.height;
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // define line width
    CGContextSetLineWidth(ctx, 2);
    
    if(self.aryGraphDatas.count > 1)
    {
        // define stroke color
        //CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
        
        for (int n = 1 ; n < self.aryGraphDatas.count ; n ++)
        {
            float y1 = [[self.aryGraphDatas objectAtIndex:(n - 1)] floatValue];
            float y2 = [[self.aryGraphDatas objectAtIndex:n] floatValue];
            
            float realx1 = self.interval * n;
            float realy1 = height * (1.0f - y1);
            
            float realx2 = self.interval * (n + 1);
            float realy2 = height * (1.0f - y2);
            
            CGContextMoveToPoint(ctx, realx1, realy1);
            CGContextAddLineToPoint(ctx, realx2, realy2);
            
            CGContextStrokePath(ctx);
        }
        
        CGContextClosePath(ctx);
    }
    else if(self.aryGraphDatas.count == 1)
    {
        CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
        
        float y = [[self.aryGraphDatas objectAtIndex:0]floatValue];
        
        float realx = self.interval;
        float realy = height * (1.0f - y);
        
        CGContextMoveToPoint(ctx, realx, realy);
        CGContextAddLineToPoint(ctx, realx + 1, realy + 1);
        
        CGContextStrokePath(ctx);
        CGContextClosePath(ctx);
    }
    
    if(self.aryAnotherGraphDatas.count > 1)
    {
        // define stroke color
        //CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
        
        for (int n = 1 ; n < self.aryAnotherGraphDatas.count ; n ++)
        {
            float y1 = [[self.aryAnotherGraphDatas objectAtIndex:(n - 1)] floatValue];
            float y2 = [[self.aryAnotherGraphDatas objectAtIndex:n] floatValue];
            
            float realx1 = self.interval * n;
            float realy1 = height * (1.0f - y1);
            
            float realx2 = self.interval * (n + 1);
            float realy2 = height * (1.0f - y2);
            
            CGContextMoveToPoint(ctx, realx1, realy1);
            CGContextAddLineToPoint(ctx, realx2, realy2);
            
            CGContextStrokePath(ctx);
        }
        
        CGContextClosePath(ctx);
    }
    else if(self.aryAnotherGraphDatas.count == 1)
    {
        CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
        
        float y = [[self.aryAnotherGraphDatas objectAtIndex:0]floatValue];
        
        float realx = self.interval;
        float realy = height * (1.0f - y);
        
        CGContextMoveToPoint(ctx, realx, realy);
        CGContextAddLineToPoint(ctx, realx + 1, realy + 1);
        
        CGContextStrokePath(ctx);
        CGContextClosePath(ctx);
    }
}

- (void) addDotOfTime
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    CGRect parentViewBounds = self.bounds;
//    CGFloat width = parentViewBounds.size.width;
    CGFloat height = parentViewBounds.size.height;
    
    for (int n = 0 ; n < self.aryGraphDatas.count ; n ++)
    {
        float y = [[self.aryGraphDatas objectAtIndex:n] floatValue];
        
        float realx = self.interval * (n + 1);
        float realy = height * (1.0f - y);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.tag = 1000 + n;
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = YES;
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        subview.userInteractionEnabled = NO;
        subview.backgroundColor = [UIColor blackColor];
        subview.layer.cornerRadius = CGRectGetWidth(subview.frame) / 2;
        subview.clipsToBounds = YES;
        subview.center = CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame) / 2);
        
        [view addSubview:subview];
        subview = nil;
        
        view.center = CGPointMake(realx, realy);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTime:)];
        [view addGestureRecognizer:tapGesture];
        tapGesture = nil;
        
        [self addSubview:view];
        view = nil;
    }
    
    for (int n = 0 ; n < self.aryAnotherGraphDatas.count ; n ++)
    {
        float y = [[self.aryAnotherGraphDatas objectAtIndex:n] floatValue];
        
        float realx = self.interval * (n + 1);
        float realy = height * (1.0f - y);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.tag = 2000 + n;
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = YES;
        
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        subview.userInteractionEnabled = NO;
        subview.backgroundColor = [UIColor blackColor];
        subview.layer.cornerRadius = CGRectGetWidth(subview.frame) / 2;
        subview.clipsToBounds = YES;
        subview.center = CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame) / 2);
        
        [view addSubview:subview];
        subview = nil;
        
        view.center = CGPointMake(realx, realy);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTime:)];
        [view addGestureRecognizer:tapGesture];
        tapGesture = nil;
        
        [self addSubview:view];
        view = nil;
    }
    
    if(self.aryAnotherGraphDatas.count > 0)
    {
        float y = [[self.aryAnotherGraphDatas objectAtIndex:0] floatValue];
        
        float realx = self.interval;
        float realy = height * (1.0f - y);
        
        [self addSwimmerName:self.anotherSwimmerName position:CGPointMake(realx, realy)];
    }
}

- (void) tapTime:(UITapGestureRecognizer *)gesture
{
    NSInteger tag = gesture.view.tag;
    
    if(tag >= 2000)
    {
        [self.delegate selectTimeOnChart:(int)(tag - 2000) isOwner:NO];
    }
    else if(tag >= 1000)
    {
        [self.delegate selectTimeOnChart:(int)(tag - 1000) isOwner:YES];
    }
}

- (void) addSwimmerName:(NSString *)name position:(CGPoint) position
{
    return ;
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(position.x + 20, position.y - 20, 140, 20)];
    lblName.textColor = [UIColor grayColor];
    lblName.text = name;
    
    [self addSubview:lblName];
    lblName = nil;
}

@end
