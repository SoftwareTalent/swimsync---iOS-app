//
//  MYSGoalTimeInfo.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSGoalTimeInfo.h"
#import "MYSGoalTime.h"

@implementation MYSGoalTimeInfo

+ (NSMutableArray*)getGoalTimeInfoFromSet:(NSSet*)goalTimeSet {
    NSMutableArray* goalTimes = [[NSMutableArray alloc] init];
    
    for (MYSGoalTime *goalTime in goalTimeSet) {
        MYSGoalTimeInfo *goalTimeInfo = [[MYSGoalTimeInfo alloc] init];
        
        goalTimeInfo.distance = [goalTime.distance intValue];
        goalTimeInfo.stroke = [goalTime.stroke intValue];
        goalTimeInfo.time = [goalTime.time intValue];
        
        [goalTimes addObject:goalTimeInfo];
    }
    
    return goalTimes;
}

@end
