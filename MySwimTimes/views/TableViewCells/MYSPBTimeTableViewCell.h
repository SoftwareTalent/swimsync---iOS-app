//
//  MYSPBTimeTableViewCell.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYSPBTimeCellHeight 60
#define MYSPBTimeCellHeightPad 70

@protocol MYSPBTimeTableViewCellDelegate <NSObject>

- (void) clickShortTime:(UIView *)view time:(MYSTime *)time;
- (void) clickLongTime:(UIView *)view time:(MYSTime *)time;

@end

@interface MYSPBTimeTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MYSPBTimeTableViewCellDelegate> delegate;

@property (nonatomic, assign) IBOutlet UIImageView *ivStroke;

@property (nonatomic, assign) IBOutlet UILabel *lblDistance;
@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (nonatomic, assign) IBOutlet UILabel *lblShortTime;
@property (nonatomic, assign) IBOutlet UILabel *lblShortTimeDate;
@property (nonatomic, assign) IBOutlet UILabel *lblShortGoldTime;

@property (nonatomic, assign) IBOutlet UILabel *lblLongTime;
@property (nonatomic, assign) IBOutlet UILabel *lblLongTimeDate;
@property (nonatomic, assign) IBOutlet UILabel *lblLongGoldTime;

- (void) setPBTimeInformationWithSwimmer:(MYSProfile *)swimmer distance:(int)distance stroke:(MYSStrokeTypes)stroke showGoal:(BOOL)showGoal;

@end
