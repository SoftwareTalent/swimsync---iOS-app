//
//  MYSMeetInfo.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSMeetInfo.h"

@implementation MYSMeetInfo

- (id)initWithMeetData:(MYSMeet *)meetData
{
    self = [super init];
    if (self) {
        _meetData = meetData;
        _meetEndDate = meetData.endDate;
        _meetLocation = meetData.location;
        _meetCity = meetData.city;
        _meetStartDate = meetData.startDate;
        _meetTitle = meetData.title;
        _courseType = [meetData.courseType integerValue];
        _meetId = [meetData.id integerValue];
    }
    return self;
}

- (void)update
{
    if (_meetData != nil) {
        _meetData.title = _meetTitle;
        _meetData.endDate = _meetEndDate;
        _meetData.location = _meetLocation;
        _meetData.city = _meetCity;
        _meetData.courseType = [NSNumber numberWithInt:_courseType];
        _meetData.id = [NSNumber numberWithLongLong:_meetId];
        _meetData.startDate = _meetStartDate;
        [[MYSDataManager shared] save];
    }
}

- (void)save
{
    if (_meetData != nil) {
        [self update];
    } else {
        MYSMeet *meet = [[MYSDataManager shared] insertMeetWithTitle:_meetTitle location:_meetLocation city:_meetCity  startDate:_meetStartDate andEndDate:_meetEndDate courseType:_courseType];
        _meetData = meet;
        
        [[MYSDataManager shared].allMeets addObject:meet];
    }
}

@end
