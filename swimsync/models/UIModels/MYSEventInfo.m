//
//  MYSEventInfo.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSEventInfo.h"

@implementation MYSEventInfo

- (id)init
{
    self = [super init];
    if (self) {
        _status = 0;
    }
    return self;
}

- (id)initWithEventData:(MYSEvent *)eventData
{
    self = [super init];
    if (self) {
        _status = 0;
        _eventData = eventData;
        _eventDistance = eventData.distanceValue;
        _eventTime = eventData.timeValue;
        _eventStroke = eventData.strokeValue;
        _qualifyGender = eventData.qualifytime.genderValue;
        _qualifyName = eventData.qualifytime.name;
        
    }
    return self;
}

+ (NSArray *)getAllEventWithQualifyTime:(MYSQualifyTime *)qualifyTime
{
    NSMutableArray *events = [NSMutableArray array];
    for (MYSEvent *event in qualifyTime.events) {
        MYSEventInfo *eventInfo = [[MYSEventInfo alloc] initWithEventData:event];
        [events addObject:eventInfo];
    }
    return events;
}

+ (NSArray *)getAllEventWithMeet:(MYSMeet *)meet
{
    NSMutableArray *finalEvents = [NSMutableArray array];
    for (MYSQualifyTime *qualify in meet.qualifytimes) {
        NSArray *events = [MYSEventInfo getAllEventWithQualifyTime:qualify];
        [finalEvents addObjectsFromArray:events];
    }
    return finalEvents;
}

- (void)update
{
    if (_eventData != nil) {
        MYSQualifyTime *qualifyTime = [[MYSDataManager shared] getQualifyTimeWithGender:_qualifyGender name:_qualifyName ofMeet:_eventData.qualifytime.meet];
        if (qualifyTime == nil) {
            qualifyTime = [[MYSDataManager shared] insertQualifyingTimeWithGender:_qualifyGender name:_qualifyName andMeet:_eventData.qualifytime.meet];
        }
        
        if (_eventData.qualifytime != qualifyTime) {
            MYSQualifyTime *oldQualifyTime = _eventData.qualifytime;
            [_eventData.qualifytime.eventsSet removeObject:_eventData];
            _eventData.qualifytime = qualifyTime;
            [qualifyTime.eventsSet addObject:_eventData];
            
            // Remove old qualifying time if needed
            if ([oldQualifyTime.events count] == 0) {
                [oldQualifyTime.meet removeQualifytimesObject:oldQualifyTime];
                [oldQualifyTime MR_deleteEntity];
            }
            
        } else {
            
        }
        _eventData.timeValue = _eventTime;
        _eventData.distanceValue = _eventDistance;
        _eventData.strokeValue = _eventStroke;
        
        [[MYSDataManager shared] save];
    }
    
}

- (void)delete
{
    if (_eventData != nil) {
        MYSQualifyTime *oldQualifyTime = _eventData.qualifytime;
        [oldQualifyTime.eventsSet removeObject:_eventData];
        [_eventData MR_deleteEntity];
        
        if ([oldQualifyTime.events count] == 0) {
            [oldQualifyTime.meet removeQualifytimesObject:oldQualifyTime];
            [oldQualifyTime MR_deleteEntity];
        }
        
        [[MYSDataManager shared] save];
    }
}
@end
