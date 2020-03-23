//
//  MYSOpenPBGoalTableViewCell.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/26/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYSOpenPBGoalTimeCellHeight 60
#define MYSOpenPBGoalTimeCellHeightPad 70

@interface MYSOpenPBGoalTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *lblDistance;

@property (nonatomic, assign) IBOutlet UILabel *lblPB;
@property (nonatomic, assign) IBOutlet UILabel *lblGoal;

- (void) setPBGoalTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke;

@end
