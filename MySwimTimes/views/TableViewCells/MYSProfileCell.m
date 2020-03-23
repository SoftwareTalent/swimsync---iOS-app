//
//  MYSProfileCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSProfileCell.h"

@implementation MYSProfileCell
{

}

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
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadDataForCellWithProfile:(MYSProfile*)profile
{
//    NSLog(@"%@ %@ %@",profile.name,profile.nameSwimClub,[MethodHelper convertFullMonth:profile.birthday]);
    
    self.imgProfile.image = [UIImage imageWithData:profile.image];
    
    self.txtName.text = profile.name;
    self.txtSwimClub.text = profile.nameSwimClub;
    self.txtAddress.text = [NSString stringWithFormat:@"%@, %@", profile.city, profile.country];
    self.txtYearOld.text = [NSString stringWithFormat:@"%.0f years",[MethodHelper countYearOld2:profile.birthday]];
}

@end
