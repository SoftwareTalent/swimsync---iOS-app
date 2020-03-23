//
//  MYSEventInfo.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 Used for containing information of Event which is shown in UI
 */

#import <Foundation/Foundation.h>

@interface MYSEventInfo : NSObject
@property (nonatomic) int status;

@property (nonatomic) float eventDistance;

@property (nonatomic) MYSStrokeTypes eventStroke;

@property (nonatomic) float eventTime;

@property (nonatomic) int qualifyGender;

@property (nonatomic, strong) NSString *qualifyName;

@property (nonatomic, strong) MYSEvent *eventData;

- (id)initWithEventData:(MYSEvent *)eventData;

+ (NSArray *)getAllEventWithQualifyTime:(MYSQualifyTime *)qualifyTime;

+ (NSArray *)getAllEventWithMeet:(MYSMeet *)meet;

- (void)update;

- (void)delete;

@end
