//
//  MYSChartView.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/10/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSChartViewDelegate <NSObject>

- (void) selectTimeOnChart:(int) index isOwner:(BOOL)isOwner;

@end

@interface MYSChartView : UIView
{
    
}

@property (nonatomic, assign) id <MYSChartViewDelegate> delegate;

@property (nonatomic, assign) int64_t minTimeForYAxis;
@property (nonatomic, assign) int64_t maxTimeForYAxis;

@property (nonatomic, assign) int numberOfTimes;

@property (nonatomic, assign) int64_t pbTime;
@property (nonatomic, strong) UIColor *pbColor;

@property (nonatomic, assign) int64_t goalTime;
@property (nonatomic, strong) UIColor *goalColor;

@property (nonatomic, assign) int64_t customTime;
@property (nonatomic, strong) UIColor *customColor;


- (void) _initChart;

- (void) setYAxisLabelWithMin:(int64_t) minTime max:(int64_t) maxTime;

- (void) setXAxisLabelWithMaxNumber:(int) numberOfTimes;

- (void) setPBTime:(int64_t) time color:(UIColor *) color;
- (void) hidePBTime;

- (void) setGoalTime:(int64_t) time color:(UIColor *) color;
- (void) hideGoalTime;

- (void) setCustomTime:(int64_t) time color:(UIColor *) color;
- (void) hideCustomTime;

- (void) setChartTimes:(NSMutableArray *)aryChartTimes;
- (void) setAnotherSwimmerChartTimes:(NSMutableArray *)aryAnotherSwimmerChartTimes name:(NSString *)name;

- (void) setAnotherPBTime:(int64_t) time color:(UIColor *) color;
- (void) hideAnotherPBTime;

@end
