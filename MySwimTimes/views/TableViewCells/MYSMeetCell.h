//
//  MYSMeetCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSMeet.h"

#define MeetCellIdentifier  @"MeetCellIdentifier"

@interface MYSMeetCell : UITableViewCell

// Label title meet
@property (weak, nonatomic) IBOutlet UILabel *lblTitleMeet;
// Label location meet
@property (weak, nonatomic) IBOutlet UILabel *lblLocationMeet;
// Label date meet
@property (weak, nonatomic) IBOutlet UILabel *lblDateMeet;

@property (nonatomic, assign) IBOutlet UILabel *lblComingUp;

#pragma mark - === Instance Method ===

/*
 This method is used to load meets data for cell
 */
- (void) loadDataForCellWithMeet:(MYSMeet*)meet;

@end
