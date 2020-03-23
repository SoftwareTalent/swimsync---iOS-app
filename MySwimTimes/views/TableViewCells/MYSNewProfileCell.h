//
//  MYSNewProfileCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NewProfileCellIdentifier  @"NewProfileCellIdentifier"

@protocol MYSNewProfileCellDelegate <NSObject>

@optional
- (void) didEnteredProfileName:(NSString *) name;
- (void) didChooseGender:(int) gender;
- (void) didEnteredBirthday:(NSString *) birthday;
- (void) pressedBirthdayButton:(UIButton*)button;
@end

@interface MYSNewProfileCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (strong, nonatomic) IBOutlet UIButton *btnBirthday;

- (IBAction)chooseGender:(id)sender;
- (IBAction)pressedBirthdayButton:(id)sender;
- (IBAction)textEditChanged:(id)sender;

@property (nonatomic) NSObject<MYSNewProfileCellDelegate> *delegate;

- (void)loadDataToViewWithProfile:(MYSProfileInfo*) profile;
@end
