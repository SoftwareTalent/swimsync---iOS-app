//
//  MYSNewProfileViewController.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This view controller is used for creating a new swimmer
 */

#import <UIKit/UIKit.h>
#import "MYSSwimClubCell.h"
#import "MYSGoalTimeCell.h"
#import "MYSNewProfileCell.h"
#import "MYSProfileInfo.h"
#import "MYSProfile.h"
#import "MYSProfileImageCell.h"
#import "FDTakeController.h"

@interface MYSNewProfileViewController : UIViewController

@property (strong, nonatomic) MYSProfile* profile;

@property (assign, nonatomic) BOOL isEdit;

@end