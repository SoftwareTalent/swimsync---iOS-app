//
//  MYSGoldTimeTableViewCell.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYSGoldTimeCellHeight 60
#define MYSGoldTimeCellHeightPad 70

@interface MYSGoldTimeTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *ivStroke;

@property (nonatomic, assign) IBOutlet UILabel *lblDistance;
@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (nonatomic, assign) IBOutlet UILabel *lblShortPBTime;
@property (nonatomic, assign) IBOutlet UILabel *lblShortGoldTime;

@property (nonatomic, assign) IBOutlet UILabel *lblLongPBTime;
@property (nonatomic, assign) IBOutlet UILabel *lblLongGoldTime;

- (void) setGoldTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke pbs:(BOOL)show;

@end
