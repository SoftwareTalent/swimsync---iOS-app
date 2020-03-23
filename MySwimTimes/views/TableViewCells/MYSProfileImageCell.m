//
//  MYSProfileImageCell.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/15/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSProfileImageCell.h"

@implementation MYSProfileImageCell

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

- (IBAction)chooseImage:(id)sender {
    [self.delegate pressedChooImageButton];
}
@end
