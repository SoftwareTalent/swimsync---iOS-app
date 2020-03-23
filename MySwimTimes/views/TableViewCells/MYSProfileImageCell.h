//
//  MYSProfileImageCell.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/15/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MYSProfileImageCellIdentifier @"MYSProfileImageCellIdentifier";

@protocol MYSProfileImageCellDelegate <NSObject>

@optional
- (void) pressedChooImageButton;
@end

@interface MYSProfileImageCell : UITableViewCell

@property (nonatomic) NSObject<MYSProfileImageCellDelegate> *delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
- (IBAction)chooseImage:(id)sender;
@end
