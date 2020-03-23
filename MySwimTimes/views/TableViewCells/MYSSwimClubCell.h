//
//  MYSSwimClubCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSProfileInfo.h"

#define SwimClubCellIdentifier  @"SwimClubCellIdentifier"

@protocol MYSSwimClubCellDelegate <NSObject>

@optional
- (void) didEnteredNameSwimClub:(NSString *) name;
- (void) didEnteredCity:(NSString *) city;
- (void) didEnteredCountry:(NSString *) country;
@end

@interface MYSSwimClubCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;


- (IBAction)textEditChanged:(id)sender;

@property (nonatomic) NSObject<MYSSwimClubCellDelegate> *delegate;

- (void)loadDataToViewWithProfile:(MYSProfileInfo*) profile;

@end
