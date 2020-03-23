//
//  MYSSwimClubCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSSwimClubCell.h"

@implementation MYSSwimClubCell

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
    _txtName.text = profile.nameSwimClub;
    _txtCity.text = profile.city;
    _txtCountry.text = profile.country;
}

- (IBAction)textEditChanged:(id)sender {
    UITextField* textField = (UITextField*)sender;
    if (textField == _txtName) {
        // Name text field
        if ([_delegate respondsToSelector:@selector(didEnteredNameSwimClub:)]) {
            [_delegate didEnteredNameSwimClub:textField.text];
        }
    } else if (textField == _txtCity) {
        // City text field
        if ([_delegate respondsToSelector:@selector(didEnteredCity:)]) {
            [_delegate didEnteredCity:textField.text];
        }
    } else if (textField == _txtCountry) {
        // Country text field
        if ([_delegate respondsToSelector:@selector(didEnteredCountry:)]) {
            [_delegate didEnteredCountry:textField.text];
        }
    }
}
@end
