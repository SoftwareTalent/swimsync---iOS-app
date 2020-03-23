//
//  MYSLapCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/11/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSLap.h"

#define LapCellIdentifier  @"LapCellIdentifier"

@interface MYSLapCell : UITableViewCell

// Label lap number
@property (weak, nonatomic) IBOutlet UILabel *lblLapNumber;
// Label lap split
@property (weak, nonatomic) IBOutlet UILabel *lblLapSplit;
// Label lap total
@property (weak, nonatomic) IBOutlet UILabel *lblLapTotal;

#pragma mark - === Instance Method ===

/**
 This method is used to load laps data for cell
 
 @param lap lap data for this index
 
 @param laps list of laps in stopwatch
 */
- (void) loadDataForCellWithLap:(MYSLap*)lap allLaps:(NSArray *) laps;

@end
