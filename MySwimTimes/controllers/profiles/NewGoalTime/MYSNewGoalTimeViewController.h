//
//  MYSNewGoalTimeViewController.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This view controller is used for creating goal time
 */

#import <UIKit/UIKit.h>
#import "MYSProfileInfo.h"
#import "MYSGoalTimeInfo.h"

@interface MYSNewGoalTimeViewController : UIViewController

@property (nonatomic, retain) MYSProfile *swimmer;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) MYSStrokeTypes stroke;

@property (nonatomic, assign) BOOL isEditing;

@end
