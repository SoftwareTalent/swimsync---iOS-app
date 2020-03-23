//
//  MYSLapChartView.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/17/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSLapChartView : UIView

@property (nonatomic, assign) int64_t maxTimeForYAxis;

@property (nonatomic, assign) int numberOfTimes;

- (void) setTime:(MYSTime *)time;

@end
