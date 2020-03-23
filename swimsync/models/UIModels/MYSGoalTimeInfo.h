//
//  MYSGoalTimeInfo.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 Used for containing information of Goal time
 */

#import <Foundation/Foundation.h>

@interface MYSGoalTimeInfo : NSObject

@property (assign, nonatomic) CGFloat distance;
@property (assign, nonatomic) MYSStrokeTypes stroke;
@property (assign, nonatomic) NSInteger time;

+ (NSMutableArray*)getGoalTimeInfoFromSet:(NSSet*)goalTimeSet;
@end
