//
//  MYSGoalTimeCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSGoalTimeInfo.h"

#define MYSGoalTimeCellIdentifier  @"MYSGoalTimeCellIdentifier"

@interface MYSGoalTimeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *txtDistance;
@property (strong, nonatomic) IBOutlet UILabel *txtStrokeName;
@property (strong, nonatomic) IBOutlet UILabel *txtTime;

- (void)loadDataToViewWithGoalTime:(MYSGoalTimeInfo*) goalTime;

@end
