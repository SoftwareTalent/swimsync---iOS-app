//
//  MYSPBTimeTableViewCell.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSPBTimeTableViewCell.h"

@interface MYSPBTimeTableViewCell()

@property (nonatomic, retain) MYSTime *shortTime;
@property (nonatomic, retain) MYSTime *longTime;

@end

@implementation MYSPBTimeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPBTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke showGoal:(BOOL)showGoal
{
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
    
    self.shortTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:MYSCourseType_Short distance:distance stroke:stroke];
    
    if(self.shortTime != nil)
    {
        NSString *startDate = @"";
        if (self.shortTime.meet.startDate != nil) {
            startDate = [MethodHelper convertFullMonth:self.shortTime.meet.startDate];
        }
        if ([startDate isEqualToString:@""])
        {
            self.lblShortTimeDate.text = [NSString stringWithFormat:@"-"];
        } else {
            self.lblShortTimeDate.text = [NSString stringWithFormat:@"%@",startDate];
        }
        
        self.lblShortTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[self.shortTime.time integerValue] withMinimumFormat:YES];
    }
    else
    {
        self.lblShortTime.text = @"";
        self.lblShortTimeDate.text = @"-";
    }
    
    self.longTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:MYSCourseType_Long distance:distance stroke:stroke];
    
    if(self.longTime != nil)
    {
        NSString *startDate = @"";
        if (self.longTime.meet.startDate != nil) {
            startDate = [MethodHelper convertFullMonth:self.longTime.meet.startDate];
        }
        if ([startDate isEqualToString:@""])
        {
            self.lblLongTimeDate.text = [NSString stringWithFormat:@"-"];
        } else {
            self.lblLongTimeDate.text = [NSString stringWithFormat:@"%@",startDate];
        }
        
        self.lblLongTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[self.longTime.time integerValue] withMinimumFormat:YES];
    }
    else
    {
        self.lblLongTime.text = @"";
        self.lblLongTimeDate.text = @"-";
    }
    
    self.lblShortGoldTime.hidden = !showGoal;
    self.lblLongGoldTime.hidden = !showGoal;
    
    MYSGoalTime *shortGoldTime = [[MYSDataManager shared] getGoalTimeOfProfile:swimmer withCourse:MYSCourseType_Short stroke:stroke distance:distance];
    if(shortGoldTime == nil)
    {
        self.lblShortGoldTime.text = @"";
    }
    else
    {
        self.lblShortGoldTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[shortGoldTime.time integerValue] withMinimumFormat:YES];
        
        if(self.shortTime != nil && [self.shortTime.time longLongValue] <= [shortGoldTime.time longLongValue])
        {
            self.lblShortGoldTime.textColor = [UIColor colorWithRed:0.0f green:181.0f / 255.0f blue:1.0f / 255.0f alpha:1.0f];
        }
        else
        {
            self.lblShortGoldTime.textColor = [UIColor redColor];
        }
    }
    
    MYSGoalTime *longGoldTime = [[MYSDataManager shared] getGoalTimeOfProfile:swimmer withCourse:MYSCourseType_Long stroke:stroke distance:distance];
    if(longGoldTime == nil)
    {
        self.lblLongGoldTime.text = @"";
    }
    else
    {
        self.lblLongGoldTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[longGoldTime.time integerValue] withMinimumFormat:YES];
        
        if(self.longTime != nil && [self.longTime.time longLongValue] <= [longGoldTime.time longLongValue])
        {
            self.lblLongGoldTime.textColor = [UIColor colorWithRed:0.0f green:181.0f / 255.0f blue:1.0f / 255.0f alpha:1.0f];
        }
        else
        {
            self.lblLongGoldTime.textColor = [UIColor redColor];
        }
    }
}

- (IBAction)onClickShortTime:(id)sender
{
    [self.delegate clickShortTime:self time:self.shortTime];
}

- (IBAction)onClickLongTime:(id)sender
{
    [self.delegate clickShortTime:self time:self.longTime];
}

@end
