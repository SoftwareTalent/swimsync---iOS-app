//
//  MYSBestTimeCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSBestTime.h"

#define BestTimeCellIdentifier  @"BestTimeCellIdentifier"
#define BestTimeCellHeight  50

@interface MYSBestTimeCell : UITableViewCell

// Image swim type
@property (weak, nonatomic) IBOutlet UIImageView *imgSwimType;
// Label swim distance
@property (weak, nonatomic) IBOutlet UILabel *lblSwimDistance;
// Label swim type
@property (weak, nonatomic) IBOutlet UILabel *lblSwimType;
// Label swim time short course
@property (weak, nonatomic) IBOutlet UILabel *lblSwimTimeShortCourse;
// Label swim time long course
@property (weak, nonatomic) IBOutlet UILabel *lblSwimTimeLongCourse;
// Label swim date short course
@property (weak, nonatomic) IBOutlet UILabel *lblSwimDateShortCourse;
// Label swim date long course
@property (weak, nonatomic) IBOutlet UILabel *lblSwimDateLongCourse;

#pragma mark - === Instance Method ===

/*
 This method is used to load best times data for cell
 */
- (void) loadDataForCellWithBestTime:(MYSBestTime*)bestTime;

@end
