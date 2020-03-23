//
//  MYSLapCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/11/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSLapCell.h"

@implementation MYSLapCell

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

- (void)loadDataForCellWithLap:(MYSLap *)lap allLaps:(NSArray *)laps{
    
    // Set number lap
    NSInteger index = [laps indexOfObject:lap];
    _lblLapNumber.text = [NSString stringWithFormat:@"%ld", (long)index];
    // Set split
    _lblLapSplit.text = [lap getSplitTimeString];
    
    // Calculate total time in current lap
    NSArray *previousLaps = [[MYSDataManager shared] getPreviousLapsWithLapId:lap.idValue];
    int64_t totalMiliseconds = 0;
    for (MYSLap *aLap in previousLaps) {
        totalMiliseconds += aLap.splitTimeValue;
    }
    _lblLapTotal.text = [MYSLap getSplitTimeStringFromMiliseconds:totalMiliseconds withMinimumFormat:NO];
}

@end
