//
//  MYSProfileInfo.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSProfileInfo.h"
#import "MethodHelper.h"
#import "MYSGoalTimeInfo.h"

@implementation MYSProfileInfo

+ (MYSProfileInfo*)profileInfoFromProfile:(MYSProfile *)profile {
    MYSProfileInfo *profileInfo = [[MYSProfileInfo alloc] init];
    
    profileInfo.image = [UIImage imageWithData:profile.image];
    profileInfo.name = profile.name;
    profileInfo.gender = [profile.gender intValue];
    profileInfo.birthday = [MethodHelper convertFullMonth:profile.birthday];
    profileInfo.nameSwimClub = profile.nameSwimClub;
    profileInfo.city = profile.city;
    profileInfo.country = profile.country;
    profileInfo.goalTimes = [MYSGoalTimeInfo getGoalTimeInfoFromSet:profile.goaltime];
    profileInfo.userId = [profile.userid longValue];
    
    return profileInfo;
}

@end
