//
//  MYSLapChartView.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/17/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSLapChartView.h"

#import "MYSStickView.h"

@interface MYSLapChartView()

@property (nonatomic, strong) UIScrollView *svChart;

@property (nonatomic, strong) MYSStickView *stickView;

@end

@implementation MYSLapChartView

#define AXIS_X_LABEL_SIZE 20
#define AXIS_Y_LABEL_SIZE 60

#define NUMBER_OF_DOT_Y  7

#define GAP_BOTTOM_OF_CHART  20
#define GAP_TOP_OF_CHART  34

#define INTERVAL_AXIS_X  20

#define TAG_X_LABEL   1000
#define TAG_Y_LABEL   1001

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) _initChart
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    UIView *lineAxisX = [[UIView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, height - AXIS_X_LABEL_SIZE, width - AXIS_Y_LABEL_SIZE, 3)];
    lineAxisX.backgroundColor = [UIColor blackColor];
    
    [self addSubview:lineAxisX];
    lineAxisX = nil;
    
    //    float widthLabelX = (width - AXIS_Y_LABEL_SIZE) / self.aryXLabels.count;
    //    if(!self.hideBottomLabels)
    //    {
    //        for (int n = 0 ; n < self.aryXLabels.count ; n ++) {
    //            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(widthLabelX * n , height - AXIS_X_LABEL_SIZE, widthLabelX, AXIS_X_LABEL_SIZE)];
    //            label.backgroundColor = [UIColor clearColor];
    //            label.textColor = [UIColor blackColor];
    //            label.font = [UIFont fontWithName:@"Edmondsans-Regular" size:9.0f];
    //            label.textAlignment = NSTextAlignmentCenter;
    //            label.text = [self.aryXLabels objectAtIndex:n];
    //
    //            [self addSubview:label];
    //        }
    //    }
    
    
    UIView *lineAxisY = [[UIView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, 3, height - AXIS_X_LABEL_SIZE)];
    lineAxisY.backgroundColor = [UIColor blackColor];
    
    [self addSubview:lineAxisY];
    lineAxisY = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AXIS_Y_LABEL_SIZE, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"TIME";
    
    [self addSubview:label];
    label = nil;
    
    UIScrollView *svChart = [[UIScrollView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, width - AXIS_Y_LABEL_SIZE, height)];
    svChart.backgroundColor = [UIColor clearColor];
    svChart.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:svChart];
    self.svChart = svChart;
    
    MYSStickView * stickView = [[MYSStickView alloc] init];
    stickView.backgroundColor = [UIColor clearColor];
    
    [self.svChart addSubview:stickView];
    self.stickView = stickView;
    
}

- (void) setYAxisLabelWithMax:(int64_t) maxTime
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        if(subview.tag == TAG_Y_LABEL)
            [subview removeFromSuperview];
    }
    
    self.maxTimeForYAxis = maxTime;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    int64_t timeInterval = maxTime / (NUMBER_OF_DOT_Y - 1);
    
    float interval = (height - (GAP_BOTTOM_OF_CHART + GAP_TOP_OF_CHART)) / (NUMBER_OF_DOT_Y - 1);
    
    for (int n = 0 ; n < NUMBER_OF_DOT_Y ; n ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AXIS_Y_LABEL_SIZE, 20)];
        label.tag = TAG_Y_LABEL;
        label.center = CGPointMake(AXIS_Y_LABEL_SIZE / 2, height - (GAP_BOTTOM_OF_CHART + interval * n));
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [MYSLap getSplitTimeStringFromMiliseconds:( timeInterval * n) withMinimumFormat:YES];
        
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, height - (GAP_BOTTOM_OF_CHART + interval * n), width - AXIS_Y_LABEL_SIZE, 1)];
        line.backgroundColor = [UIColor grayColor];
        
        [self addSubview:line];
        line = nil;
    }
}

- (void) setXAxisLabelWithMaxNumber:(int) numberOfTimes
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        if(subview.tag == TAG_X_LABEL)
            [subview removeFromSuperview];
    }
    
    self.numberOfTimes = numberOfTimes;
    
    float width = self.svChart.frame.size.width;
    float height = self.svChart.frame.size.height;
    
    float interval = width / (self.numberOfTimes + 1);
    
    interval = MAX(interval, INTERVAL_AXIS_X);
    
    for (int n = 0 ; n < numberOfTimes ; n ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AXIS_Y_LABEL_SIZE, 20)];
        label.tag = TAG_X_LABEL;
        label.center = CGPointMake(interval * (n + 1), height - AXIS_X_LABEL_SIZE / 2);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d", n + 1];
        
        [self.svChart addSubview:label];
    }
    
    float chartWidth = interval * (numberOfTimes + 1);
    
    self.stickView.frame = CGRectMake(0, GAP_TOP_OF_CHART, chartWidth, height - (GAP_BOTTOM_OF_CHART + GAP_TOP_OF_CHART));
    
    self.svChart.contentSize = CGSizeMake(chartWidth, CGRectGetHeight(self.svChart.frame));
}

- (void) setTime:(MYSTime *)time
{
    [self _initChart];
    
    NSMutableArray *laps = (NSMutableArray *)[time.laps allObjects];
    
    laps = (NSMutableArray *)[laps sortedArrayUsingComparator:^NSComparisonResult(MYSLap * obj1, MYSLap * obj2) {
        return [obj1.lapNumber compare:obj2.lapNumber];
    }];
    
    int64_t max = 0;
    for (MYSLap *lap in laps)
    {
        if(lap.splitTimeValue > max)
        {
            max = lap.splitTimeValue;
        }
    }
    
    int64_t temp = max / 6000;
    max = 6 * (temp + 1) * 1000;
    
    [self setYAxisLabelWithMax:max];
    
    [self setXAxisLabelWithMaxNumber:(int)laps.count];
    
    ////////////////////////////////////////////////
    
    if(self.maxTimeForYAxis == 0) return;
    
    NSMutableArray *aryRealChartDatas = [[NSMutableArray alloc] init];

    for (MYSLap *lap in laps)
    {
        int64_t value = lap.splitTimeValue;
        
        float pro = (double)value / (double)self.maxTimeForYAxis ;
        
        [aryRealChartDatas addObject:[NSNumber numberWithFloat:pro]];
    }
    
    float width = self.svChart.frame.size.width;
    float interval = width / (self.numberOfTimes + 1);
    interval = MAX(interval, INTERVAL_AXIS_X);
    
    [self.stickView graphData:aryRealChartDatas interval:interval];
}

@end
