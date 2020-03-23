//
//  MYSTimeCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/6/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSTime.h"

#define TimeCellIdentifier  @"TimeCellIdentifier"

#define TimeCellHeight      66
#define TimeCellHeightPad      80

@interface MYSTimeCell : UITableViewCell

// Label swim distance
@property (weak, nonatomic) IBOutlet UILabel *lblMeetName;
// Label swim type
@property (weak, nonatomic) IBOutlet UILabel *lblMeetLocation;
// Label swim date
@property (weak, nonatomic) IBOutlet UILabel *lblMeetDate;
// Label swim time
@property (weak, nonatomic) IBOutlet UILabel *lblSwimTime;
// Label swim note
@property (weak, nonatomic) IBOutlet UILabel *lblSwimNote;

@property (weak, nonatomic) IBOutlet UILabel *lblStage;

@property (weak, nonatomic) IBOutlet UILabel *lblSplits;

#pragma mark - === Instance Method ===

/*
 This method is used to load times data for cell
 */
- (void) loadDataForCellWithTime:(MYSTime*)time;

@end
