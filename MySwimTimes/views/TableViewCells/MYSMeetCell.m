//
//  MYSMeetCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSMeetCell.h"

@implementation MYSMeetCell

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

#pragma mark - === Instance Method ===

- (void) loadDataForCellWithMeet:(MYSMeet*)meet{
    if (meet != nil) {
        // Set data for title label
        _lblTitleMeet.text = meet.title;
        // Set data for location label
        _lblLocationMeet.text = [NSString stringWithFormat:@"%@, %@", meet.location, meet.city];
        
        self.lblDateMeet.text = [MethodHelper convertMeetDate:meet.startDate endDate:meet.endDate];
        
        self.lblComingUp.hidden = ([meet.startDate compare:[NSDate date]] == NSOrderedAscending);

    }else{
        _lblTitleMeet.text = @"";
        _lblLocationMeet.text = @"";
        _lblDateMeet.text = @"";
    }
}


@end
