//
//  MYSLapInfo.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/4/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 Used for containing information about a Lap
 */

#import <Foundation/Foundation.h>
#import "MYSLap.h"
#import "MYSTime.h"

@interface MYSLapInfo : NSObject

@property (nonatomic) NSInteger lapNumber;

@property (nonatomic) NSTimeInterval lapTime;

@property (nonatomic) NSTimeInterval totalTimeToCurrentLap;

@property (nonatomic, strong) MYSLap *lapData;

- (id)initWithLapTime:(NSTimeInterval)lapTime;

+ (NSArray *)getLapsOfTime:(MYSTime *)time;

@end
