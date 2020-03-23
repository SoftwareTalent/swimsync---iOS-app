//
//  MYSBestTime.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/1/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This class is used for storing best time info.
 */

#import <Foundation/Foundation.h>
#import "MYSTime.h"

@interface MYSDistanceGroup : NSObject
@property (nonatomic) int distance;
@property (nonatomic, strong) NSMutableArray *items;

- (void)addTime:(MYSTime *)time;

@end


@interface MYSBestTime : NSObject

@property (strong, nonatomic) MYSTime* shortCourseTime;
@property (strong, nonatomic) MYSTime* longCourseTime;

- (void)insertTime:(MYSTime*)time;
- (BOOL)isSameStroke:(MYSTime*)time;
- (MYSStrokeTypes)getStrokeType;
- (int)getDistance;

@end


@interface MYSStrokeGroup : NSObject

@property (nonatomic) MYSStrokeTypes stroke;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) MYSBestTime *bestTime;

- (void)addTime:(MYSTime *)time;
@end