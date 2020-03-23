//
//  MYSOpenPBGoalTableViewCell.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/26/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSOpenPBGoalTableViewCell.h"

@implementation MYSOpenPBGoalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPBGoalTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke
{
    self.lblDistance.text = [NSString stringWithFormat:@"%@", [MYSDataManager numberStringWithCommna:distance]];
    
    MYSTime *pbTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:MYSCourseType_Open distance:distance stroke:stroke];
    
    self.lblPB.text = [MYSLap getSplitTimeStringFromMiliseconds:[pbTime.time integerValue] withMinimumFormat:YES];
    
    MYSGoalTime *goalTime = [[MYSDataManager shared] getGoalTimeOfProfile:swimmer withCourse:MYSCourseType_Open stroke:stroke distance:distance];
    
    self.lblGoal.text = [MYSLap getSplitTimeStringFromMiliseconds:[goalTime.time integerValue] withMinimumFormat:YES];
}

@end
