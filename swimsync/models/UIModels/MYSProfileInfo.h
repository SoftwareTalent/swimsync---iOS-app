//
//  MYSProfileInfo.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 Used for containing information of Profile (swimmer)
 */

#import <Foundation/Foundation.h>
#import "MYSProfile.h"

@interface MYSProfileInfo : NSObject

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int gender;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSString* nameSwimClub;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* country;
@property (assign, nonatomic) long userId;

@property (strong, nonatomic) NSMutableArray* goalTimes;

+ (MYSProfileInfo*)profileInfoFromProfile:(MYSProfile *)profile;

@end
