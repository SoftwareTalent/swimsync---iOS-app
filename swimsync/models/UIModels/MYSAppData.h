//
//  MYSAppData.h
//  swimsync
//
//  Created by Krishna Kant Kaira on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSAppData : NSObject

+ (MYSAppData*) sharedInstance;

@property (nonatomic, strong) MYSInstructorProfile *appInstructor;

@end
