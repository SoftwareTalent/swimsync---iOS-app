//
//  MYSBestTime.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/1/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSBestTime.h"

@implementation MYSDistanceGroup

- (id)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)addTime:(MYSTime *)time {
    BOOL needAdd = YES;
    for (MYSStrokeGroup *sg in _items) {
        if (sg.stroke == [time.stroke integerValue]) {
            [sg addTime:time];
            needAdd = NO;
            break;
        }
    }
    if (needAdd) {
        MYSStrokeGroup *sg = [[MYSStrokeGroup alloc] init];
        sg.stroke = [time.stroke integerValue];
        [sg addTime:time];
        [_items addObject:sg];
    }
}

@end

@implementation MYSStrokeGroup

- (id)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
        _bestTime = [[MYSBestTime alloc] init];
    }
    return self;
}

- (void)addTime:(MYSTime *)time {
    if ([time.course integerValue] == MYSCourseType_Short) {
        _bestTime.shortCourseTime = time;
    } else {
        _bestTime.longCourseTime = time;
    }
}

@end

@implementation MYSBestTime

- (void)insertTime:(MYSTime*)time {
    if ([time.course integerValue] == MYSCourseType_Short) {
        if (self.shortCourseTime == nil || [self.shortCourseTime.time longLongValue] > [time.time longLongValue]) {
            self.shortCourseTime = time;
        }
    } else {
        if (self.longCourseTime == nil || [self.longCourseTime.time longLongValue] > [time.time longLongValue]) {
            self.longCourseTime = time;
        }
    }
}

- (BOOL)isSameStroke:(MYSTime*)time {
    if (self.shortCourseTime != nil) {
        if ([self.shortCourseTime.course integerValue] == [time.course integerValue]) {
            return true;
        } else {
            return false;
        }
    } else {
        if ([self.longCourseTime.course integerValue] == [time.course integerValue]) {
            return true;
        } else {
            return false;
        }
    }
}

- (MYSStrokeTypes)getStrokeType {
    if (self.shortCourseTime != nil) {
        return [self.shortCourseTime.stroke integerValue];
    } else {
        return [self.longCourseTime.stroke integerValue];
    }
}

- (int)getDistance {
    if (self.shortCourseTime != nil) {
        return (int)[self.shortCourseTime.distance integerValue];
    } else {
        return (int)[self.longCourseTime.distance integerValue];
    }
}

@end
