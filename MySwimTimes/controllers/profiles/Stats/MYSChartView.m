//
//  MYSChartView.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/10/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSChartView.h"

#import "MYSGraphView.h"

#import "MYSDotLineView.h"

#define AXIS_X_LABEL_SIZE 20
#define AXIS_Y_LABEL_SIZE 60

#define NUMBER_OF_DOT_Y  7

#define GAP_BOTTOM_OF_CHART  34
#define GAP_TOP_OF_CHART  34

#define INTERVAL_AXIS_X  30

#define TAG_X_LABEL   1000
#define TAG_Y_LABEL   1001

#define GRADATION_WIDTH  5

@interface MYSChartView()<MYSGraphViewDelegate>

@property (nonatomic, strong) UIScrollView *svChart;

@property (nonatomic, strong) UILabel *lblPBTime;
@property (nonatomic, strong) MYSDotLineView *viewPBTimeLine;

@property (nonatomic, strong) UILabel *lblGoalTime;
@property (nonatomic, strong) MYSDotLineView *viewGoalTimeLine;

@property (nonatomic, strong) UILabel *lblCustomTime;
@property (nonatomic, strong) MYSDotLineView *viewCustomTimeLine;

@property (nonatomic, strong) UILabel *lblAnotherPBTime;
@property (nonatomic, strong) MYSDotLineView *viewAnotherPBTimeLine;

@property (nonatomic, strong) MYSGraphView *graphView;

@end

@implementation MYSChartView

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
    
    UIScrollView *svChart = [[UIScrollView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE + 10, 0, width - AXIS_Y_LABEL_SIZE - 10, height)];
    svChart.backgroundColor = [UIColor clearColor];
    svChart.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:svChart];
    self.svChart = svChart;
    
    MYSGraphView * graphView = [[MYSGraphView alloc] init];
    graphView.delegate = self;
    graphView.backgroundColor = [UIColor clearColor];
    
    [self.svChart addSubview:graphView];
    self.graphView = graphView;
    
    UILabel *lblPBTime = [[UILabel alloc] initWithFrame:CGRectMake(AXIS_X_LABEL_SIZE + 10, 0, 100, 16)];
    lblPBTime.textColor = [UIColor grayColor];
    lblPBTime.backgroundColor = [UIColor clearColor];
    lblPBTime.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:lblPBTime];
    self.lblPBTime = lblPBTime;
    
    MYSDotLineView *viewPBTimeLine = [[MYSDotLineView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, width - AXIS_Y_LABEL_SIZE, 2)];
    viewPBTimeLine.backgroundColor = [UIColor clearColor];
    
    [self addSubview:viewPBTimeLine];
    self.viewPBTimeLine = viewPBTimeLine;
    
    
    UILabel *lblAnotherPBTime = [[UILabel alloc] initWithFrame:CGRectMake(AXIS_X_LABEL_SIZE + 10, 0, 100, 16)];
    lblAnotherPBTime.textColor = [UIColor grayColor];
    lblAnotherPBTime.backgroundColor = [UIColor clearColor];
    lblAnotherPBTime.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:lblAnotherPBTime];
    self.lblAnotherPBTime = lblAnotherPBTime;
    
    MYSDotLineView *viewAnotherPBTimeLine = [[MYSDotLineView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, width - AXIS_Y_LABEL_SIZE, 2)];
    viewAnotherPBTimeLine.backgroundColor = [UIColor clearColor];
    
    [self addSubview:viewAnotherPBTimeLine];
    self.viewAnotherPBTimeLine = viewAnotherPBTimeLine;

    UILabel *lblGoalTime = [[UILabel alloc] initWithFrame:CGRectMake(AXIS_X_LABEL_SIZE + 10, 0, 100, 16)];
    lblGoalTime.textColor = [UIColor grayColor];
    lblGoalTime.backgroundColor = [UIColor clearColor];
    lblGoalTime.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:lblGoalTime];
    self.lblGoalTime = lblGoalTime;
    
    MYSDotLineView *viewGoalTimeLine = [[MYSDotLineView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, width - AXIS_Y_LABEL_SIZE, 2)];
    viewGoalTimeLine.backgroundColor = [UIColor clearColor];
    
    [self addSubview:viewGoalTimeLine];
    self.viewGoalTimeLine = viewGoalTimeLine;
    
    UILabel *lblCustomTime = [[UILabel alloc] initWithFrame:CGRectMake(AXIS_X_LABEL_SIZE + 10, 0, 100, 16)];
    lblCustomTime.textColor = [UIColor grayColor];
    lblCustomTime.backgroundColor = [UIColor clearColor];
    lblCustomTime.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:lblCustomTime];
    self.lblCustomTime = lblCustomTime;
    
    MYSDotLineView *viewCustomTimeLine = [[MYSDotLineView alloc] initWithFrame:CGRectMake(AXIS_Y_LABEL_SIZE, 0, width - AXIS_Y_LABEL_SIZE, 2)];
    viewCustomTimeLine.backgroundColor = [UIColor clearColor];
    
    [self addSubview:viewCustomTimeLine];
    self.viewCustomTimeLine = viewCustomTimeLine;
    
    self.viewPBTimeLine.hidden = YES;
    self.viewGoalTimeLine.hidden = YES;
    self.viewCustomTimeLine.hidden = YES;
    
    [self bringSubviewToFront:self.svChart];
    
}

- (void) setYAxisLabelWithMin:(int64_t) minTime max:(int64_t) maxTime
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        if(subview.tag == TAG_Y_LABEL)
            [subview removeFromSuperview];
    }
    
    self.minTimeForYAxis = minTime;
    self.maxTimeForYAxis = maxTime;
    
//    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    int64_t timeInterval = (maxTime - minTime) / (NUMBER_OF_DOT_Y - 1);
    
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
        label.text = [MYSLap getSplitTimeStringFromMiliseconds:(minTime + timeInterval * n) withMinimumFormat:YES];

        [self addSubview:label];
        label = nil;
        
        UIView *line = [[UIView alloc] init];
        line.tag = TAG_Y_LABEL;
        line.frame = CGRectMake(AXIS_Y_LABEL_SIZE - GRADATION_WIDTH, height - (GAP_BOTTOM_OF_CHART + interval * n), GRADATION_WIDTH, 1);
        line.backgroundColor = [UIColor blackColor];
        
        [self addSubview:line];
        line = nil;
        
        if(n < (NUMBER_OF_DOT_Y - 1))
        {
            UIView *subline = [[UIView alloc] init];
            subline.tag = TAG_Y_LABEL;
            subline.frame = CGRectMake(AXIS_Y_LABEL_SIZE - GRADATION_WIDTH, height - (GAP_BOTTOM_OF_CHART + interval * n) - interval / 2, GRADATION_WIDTH, 1);
            subline.backgroundColor = [UIColor blackColor];
            
            [self addSubview:subline];
            subline = nil;
        }
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
    
//    float width = self.svChart.frame.size.width;
    float height = self.svChart.frame.size.height;
    
    for (int n = 0 ; n < numberOfTimes ; n ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AXIS_Y_LABEL_SIZE, 20)];
        label.tag = TAG_X_LABEL;
        label.center = CGPointMake(INTERVAL_AXIS_X * (n + 1), height - AXIS_X_LABEL_SIZE / 2);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d", n + 1];
        
        [self.svChart addSubview:label];
    }
    
    float chartWidth = INTERVAL_AXIS_X * (numberOfTimes + 1);
    
    self.graphView.frame = CGRectMake(0, GAP_TOP_OF_CHART, chartWidth, height - (GAP_BOTTOM_OF_CHART + GAP_TOP_OF_CHART));
    
    self.svChart.contentSize = CGSizeMake(chartWidth, CGRectGetHeight(self.svChart.frame));
}

- (void) setPBTime:(int64_t) time color:(UIColor *) color
{
    self.pbTime = time;
    self.pbColor = color;
    
    self.viewPBTimeLine.hidden = NO;
    //[self bringSubviewToFront:self.viewPBTimeLine];
    
    self.viewPBTimeLine.center = CGPointMake(self.viewPBTimeLine.center.x, [self getAxisYPositionWithTime:time]);

    [self.viewPBTimeLine setDotColor:color];
    
    self.lblPBTime.hidden =  NO;
    
    self.lblPBTime.text = [MYSLap getSplitTimeStringFromMiliseconds:time withMinimumFormat:YES];
    self.lblPBTime.center = CGPointMake(AXIS_Y_LABEL_SIZE + 4 + CGRectGetWidth(self.lblPBTime.frame) / 2, [self getAxisYPositionWithTime:time] - 10);
    self.lblPBTime.textColor = color;
}

- (void) hidePBTime
{
    self.lblPBTime.hidden = YES;
    self.viewPBTimeLine.hidden = YES;
}

- (void) setAnotherPBTime:(int64_t) time color:(UIColor *) color
{
    self.pbTime = time;
    self.pbColor = color;
    
    self.viewAnotherPBTimeLine.hidden = NO;
    //[self bringSubviewToFront:self.viewAnotherPBTimeLine];
    
    self.viewAnotherPBTimeLine.center = CGPointMake(self.viewAnotherPBTimeLine.center.x, [self getAxisYPositionWithTime:time]);
    
    [self.viewAnotherPBTimeLine setDotColor:color];
    
    self.lblAnotherPBTime.hidden =  NO;
    
    self.lblAnotherPBTime.text = [MYSLap getSplitTimeStringFromMiliseconds:time withMinimumFormat:YES];
    self.lblAnotherPBTime.center = CGPointMake(AXIS_Y_LABEL_SIZE + 4 + CGRectGetWidth(self.lblAnotherPBTime.frame) / 2, [self getAxisYPositionWithTime:time] - 10);
    self.lblAnotherPBTime.textColor = color;
}

- (void) hideAnotherPBTime
{
    self.viewAnotherPBTimeLine.hidden = YES;
    self.lblAnotherPBTime.hidden = YES;
}

- (void) setGoalTime:(int64_t) time color:(UIColor *) color
{
    self.goalTime = time;
    self.goalColor = color;
    
    self.viewGoalTimeLine.hidden = NO;
    //[self bringSubviewToFront:self.viewGoalTimeLine];
    
    self.viewGoalTimeLine.center = CGPointMake(self.viewGoalTimeLine.center.x, [self getAxisYPositionWithTime:time]);

    [self.viewGoalTimeLine setDotColor:color];
    
    self.lblGoalTime.hidden =  NO;
    
    self.lblGoalTime.text = [MYSLap getSplitTimeStringFromMiliseconds:time withMinimumFormat:YES];
    self.lblGoalTime.center = CGPointMake(AXIS_Y_LABEL_SIZE + 4 + CGRectGetWidth(self.lblGoalTime.frame) / 2, [self getAxisYPositionWithTime:time] + 10);
    self.lblGoalTime.textColor = color;
}

- (void) hideGoalTime
{
    self.viewGoalTimeLine.hidden = YES;
    self.lblGoalTime.hidden = YES;
}

- (void) setCustomTime:(int64_t) time color:(UIColor *) color
{
    self.customTime = time;
    self.customColor = color;
    
    self.viewCustomTimeLine.hidden = NO;
    //[self bringSubviewToFront:self.viewCustomTimeLine];
    
    self.viewCustomTimeLine.center = CGPointMake(self.viewCustomTimeLine.center.x, [self getAxisYPositionWithTime:time]);

    [self.viewCustomTimeLine setDotColor:color];
    
    self.lblCustomTime.hidden =  NO;
    
    self.lblCustomTime.text = [MYSLap getSplitTimeStringFromMiliseconds:time withMinimumFormat:YES];
    self.lblCustomTime.center = CGPointMake(AXIS_Y_LABEL_SIZE + 4 + CGRectGetWidth(self.lblCustomTime.frame) / 2, [self getAxisYPositionWithTime:time] + 10);
    self.lblCustomTime.textColor = color;
}

- (void) hideCustomTime
{
    self.viewCustomTimeLine.hidden = YES;
    
    self.lblCustomTime.hidden = YES;
}

- (float) getAxisYPositionWithTime:(int64_t)time
{
    float diff = self.maxTimeForYAxis - self.minTimeForYAxis;
    
    if(diff == 0) return 0;
    
    float scale = (float)(time - self.minTimeForYAxis) / diff;
    
    float position = self.frame.size.height - (GAP_BOTTOM_OF_CHART + scale * (self.frame.size.height - (GAP_BOTTOM_OF_CHART + GAP_TOP_OF_CHART)));
    
    return position;
}

- (void) setChartTimes:(NSMutableArray *)aryChartTimes
{
    [self.graphView graphData:aryChartTimes interval:INTERVAL_AXIS_X];
}

- (void) setAnotherSwimmerChartTimes:(NSMutableArray *)aryAnotherSwimmerChartTimes name:(NSString *)name
{
    [self.graphView anotherGraphData:aryAnotherSwimmerChartTimes interval:INTERVAL_AXIS_X name:name];
}

#pragma mark MYSGraphViewDelegate

- (void) selectTimeOnChart:(int) index isOwner:(BOOL)isOwner
{
    [self.delegate selectTimeOnChart:index isOwner:isOwner];
}

@end
