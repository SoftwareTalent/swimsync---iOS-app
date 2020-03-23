//
//  MYSGoalTimeCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSGoalTimeCell.h"

@implementation MYSGoalTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataToViewWithGoalTime:(MYSGoalTimeInfo*) goalTime {
    _txtDistance.text = [NSString stringWithFormat:@"%dm",(int)goalTime.distance];
    _txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:goalTime.time withMinimumFormat:YES];
    _txtStrokeName.text = [[MYSDataManager shared] getFullStrokeNameByType:(MYSStrokeTypes)goalTime.stroke];
}

@end
