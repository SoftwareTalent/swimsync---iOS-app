//
//  MYSMeetInfo.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 Used for containing infomation of Meet which is shown in UI
 */

#import <Foundation/Foundation.h>

@interface MYSMeetInfo : NSObject

@property (nonatomic, strong) NSDate * meetStartDate;

@property (nonatomic, strong) NSDate * meetEndDate;

@property (nonatomic, strong) NSString *meetTitle;

@property (nonatomic, strong) NSString *meetLocation;

@property (nonatomic, strong) NSString *meetCity;

@property (nonatomic) int64_t meetId;

@property (nonatomic) int16_t courseType;

@property (nonatomic, strong) MYSMeet *meetData;

- (id)initWithMeetData:(MYSMeet *)meetData;

- (void)update;

- (void)save;

@end
