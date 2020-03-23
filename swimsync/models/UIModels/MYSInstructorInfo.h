//
//  MYSInstructorInfo.h
//  swimsync
//
//  Created by Krishna Kant Kaira on 02/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSInstructorProfile.h"

@interface MYSInstructorInfo : NSObject

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int gender;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSString* nameSwimClub;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* country;
@property (assign, nonatomic) long userId;

+ (MYSInstructorInfo*)profileInfoFromInstuctorProfile:(MYSInstructorProfile *)instructor;

@end
