//
//  MYSNewProfileCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSNewProfileCell.h"
#import "MYSProfileInfo.h"

@implementation MYSNewProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataToViewWithProfile:(MYSProfileInfo*) profile {
    _txtName.text = profile.name;
    [_segGender setSelectedSegmentIndex:profile.gender];
    if (profile.birthday == nil || [profile.birthday isEqualToString:@""]) {
        [_btnBirthday setTitle:@"Tap to enter day of birth" forState:UIControlStateNormal];
    } else {
        [_btnBirthday setTitle:profile.birthday forState:UIControlStateNormal];
    }
}

- (IBAction)chooseGender:(id)sender {
    
    [_delegate didChooseGender:(int)_segGender.selectedSegmentIndex];
}

- (IBAction)pressedBirthdayButton:(id)sender {
    [_txtName endEditing:YES];
    [_delegate pressedBirthdayButton:self.btnBirthday];
}

- (IBAction)textEditChanged:(id)sender {
    [_delegate didEnteredProfileName:_txtName.text];
}
@end
