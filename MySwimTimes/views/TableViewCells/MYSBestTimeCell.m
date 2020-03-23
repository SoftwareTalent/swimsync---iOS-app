//
//  MYSBestTimeCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSBestTimeCell.h"

@implementation MYSBestTimeCell

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

- (void) loadDataForCellWithBestTime:(MYSBestTime*)bestTime {
    
    self.imgSwimType.image = [[MYSDataManager shared] getStrokeIconByType:[bestTime getStrokeType]];
    self.lblSwimType.text = [[MYSDataManager shared] getFullStrokeNameByType:[bestTime getStrokeType]];
    self.lblSwimDistance.text = [NSString stringWithFormat:@"%dm", (int)[bestTime getDistance]];
    
    if (bestTime.shortCourseTime != nil) {
        self.lblSwimTimeShortCourse.text = [MYSLap getSplitTimeStringFromMiliseconds:[bestTime.shortCourseTime.time longLongValue] withMinimumFormat:YES];
        self.lblSwimDateShortCourse.text = [MethodHelper convertDate:bestTime.shortCourseTime.date];
    } else {
        self.lblSwimTimeShortCourse.text = @"";
        self.lblSwimDateShortCourse.text = @"";
    }
    
    if (bestTime.longCourseTime != nil) {
        self.lblSwimTimeLongCourse.text = [MYSLap getSplitTimeStringFromMiliseconds:[bestTime.longCourseTime.time longLongValue] withMinimumFormat:YES];
        self.lblSwimDateLongCourse.text = [MethodHelper convertDate:bestTime.longCourseTime.date];
    } else {
        self.lblSwimTimeLongCourse.text = @"";
        self.lblSwimDateLongCourse.text = @"";
    }
}

@end
