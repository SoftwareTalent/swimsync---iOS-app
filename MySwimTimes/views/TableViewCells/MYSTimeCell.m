//
//  MYSTimeCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/6/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSTimeCell.h"
#import "MYSDataManager.h"

@implementation MYSTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - === Implement Instance Methods ===

- (void)loadDataForCellWithTime:(MYSTime *)time {

    MYSMeet *meet = time.meet;
    
    self.lblMeetName.text = meet.title;
    
    self.lblMeetLocation.text = [NSString stringWithFormat:@"%@, %@", meet.location, meet.city];
    
    self.lblMeetDate.text = [MethodHelper convertMeetDate:meet.startDate endDate:meet.endDate];
    
    self.lblSwimTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[time.time integerValue] withMinimumFormat:YES];

    if ([time.status integerValue] == MYSTimeStatusLatestPersionalBest) {
        self.lblSwimNote.hidden = NO;
    } else {
        self.lblSwimNote.hidden = YES;
    }
    
    MYSStageType stage = [time.stage integerValue];
    NSString *stageString = @"";
    if(stage == MYSStageType_Heat) stageString = @"Heat";
    else if(stage == MYSStageType_Semi_Final) stageString = @"Semi-Final";
    else if(stage == MYSStageType_Final) stageString = @"Final";
    
    self.lblStage.text = stageString;
    
    self.lblSplits.hidden = ![self hasLapTimes:time];
}

- (BOOL) hasLapTimes:(MYSTime *) time
{
    NSMutableArray *laps = (NSMutableArray *)[time.laps allObjects];
    
    for (MYSLap *lap in laps)
    {
        if(lap.splitTimeValue > 0)
            return YES;
    }
    
    return NO;
}

@end
