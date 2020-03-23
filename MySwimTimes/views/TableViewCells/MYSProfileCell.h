//
//  MYSProfileCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ProfileCellIdentifier  @"ProfileCellIdentifier"

@interface MYSProfileCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;

@property (strong, nonatomic) IBOutlet UILabel *txtName;
@property (strong, nonatomic) IBOutlet UILabel *txtSwimClub;
@property (strong, nonatomic) IBOutlet UILabel *txtAddress;
@property (strong, nonatomic) IBOutlet UILabel *txtYearOld;

/*
 This method is used to load profile data for cell
 */
- (void) loadDataForCellWithProfile:(MYSProfile*)profile;

@end
