//
//  MYSLapInfo.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/4/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSLapInfo.h"

@implementation MYSLapInfo

- (id)initWithLapTime:(NSTimeInterval)lapTime
{
    self = [super init];
    if (self) {
        _lapTime = lapTime;
    }
    return self;
}

+ (NSArray *)getLapsOfTime:(MYSTime *)time
{
    NSMutableArray *array = [NSMutableArray array];
    [time.laps enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        MYSLap *lap = obj;
        MYSLapInfo *lapInfo = [[MYSLapInfo alloc] initWithLapTime:lap.splitTimeValue];
        lapInfo.lapData = lap;
        lapInfo.lapNumber = (NSInteger)lap.lapNumberValue;
        [array addObject:lapInfo];
    }];
    
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(MYSLapInfo *obj1, MYSLapInfo *obj2) {
        return obj1.lapNumber > obj2.lapNumber;
    }];
    
    [array removeAllObjects];
    
    for (MYSLapInfo *lapInfo in sortedArray) {
        MYSLapInfo *preLap = [array lastObject];
        if (lapInfo == nil) {
            lapInfo.totalTimeToCurrentLap = lapInfo.lapTime;
        } else {
            lapInfo.totalTimeToCurrentLap = preLap.totalTimeToCurrentLap + lapInfo.lapTime;
        }
        [array addObject:lapInfo];
    }
    
    return array;
}

@end
