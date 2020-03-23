//
//  MYSGoldTimeTableViewCell.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSGoldTimeTableViewCell.h"

@implementation MYSGoldTimeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setGoldTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke pbs:(BOOL)show
{
    self.lblLongPBTime.hidden = !show;
    self.lblShortPBTime.hidden = !show;
    
    NSString *strokeImageName = @"";
    NSString *strokeName = @"";
    if(stroke == 0)
    {
        strokeImageName = @"icon-FLY-tap";
        strokeName = @"Butterfly";
        
    }
    else if(stroke == 1)
    {
        strokeImageName = @"icon-BK-tap";
        strokeName = @"Backstroke";
    }
    else if(stroke == 2)
    {
        strokeImageName = @"icon-BR-tap";
        strokeName = @"Breaststroke";
    }
    else if(stroke == 3)
    {
        strokeImageName = @"icon-FR-tap";
        strokeName = @"Freestyle";
    }
    else if(stroke == 4)
    {
        strokeImageName = @"icon-IM-tap";
        strokeName = @"Individual medley";
    }
    
    self.ivStroke.image = [UIImage imageNamed:strokeImageName];
    self.lblStrokeName.text = strokeName;
    
    self.lblDistance.text = [NSString stringWithFormat:@"%d", distance];
    
    MYSGoalTime *shortGoldTime = [[MYSDataManager shared] getGoalTimeOfProfile:swimmer withCourse:MYSCourseType_Short stroke:stroke distance:distance];
    if(shortGoldTime == nil)
    {
        self.lblShortGoldTime.text = @"-";
    }
    else
    {
        self.lblShortGoldTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[shortGoldTime.time integerValue] withMinimumFormat:YES];
    }
    
    MYSGoalTime *longGoldTime = [[MYSDataManager shared] getGoalTimeOfProfile:swimmer withCourse:MYSCourseType_Long stroke:stroke distance:distance];
    if(longGoldTime == nil)
    {
        self.lblLongGoldTime.text = @"-";
    }
    else
    {
        self.lblLongGoldTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[longGoldTime.time integerValue] withMinimumFormat:YES];
    }
    
    MYSTime *pbShortTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:MYSCourseType_Short distance:distance stroke:stroke];
    
    if(pbShortTime != nil)
    {
        self.lblShortPBTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[pbShortTime.time integerValue] withMinimumFormat:YES];
        
        if([pbShortTime.time longLongValue] <= [shortGoldTime.time longLongValue])
        {
            self.lblShortPBTime.textColor = [UIColor colorWithRed:0.0f green:181.0f / 255.0f blue:1.0f / 255.0f alpha:1.0f];
        }
        else
        {
            self.lblShortPBTime.textColor = [UIColor redColor];
        }
    }
    else
    {
        self.lblShortPBTime.text = @"";
    }
    
    MYSTime *pbLongTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:MYSCourseType_Long distance:distance stroke:stroke];
    
    if(pbLongTime != nil)
    {
        self.lblLongPBTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[pbLongTime.time integerValue] withMinimumFormat:YES];
        
        if([pbLongTime.time longLongValue] <= [longGoldTime.time longLongValue])
        {
            self.lblLongPBTime.textColor = [UIColor colorWithRed:0.0f green:181.0f / 255.0f blue:1.0f / 255.0f alpha:1.0f];
        }
        else
        {
            self.lblLongPBTime.textColor = [UIColor redColor];
        }
    }
    else
    {
        self.lblLongPBTime.text = @"";
    }
}

@end
