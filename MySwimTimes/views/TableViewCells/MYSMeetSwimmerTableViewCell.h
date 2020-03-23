//
//  MYSMeetSwimmerTableViewCell.h
//  MySwimTimes
//
//  Created by hanjinghe on 9/27/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMeetSwimmerTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *ivProfile;

@property (nonatomic, assign) IBOutlet UILabel *lblUserName;
@property (nonatomic, assign) IBOutlet UILabel *lblClub;
@property (nonatomic, assign) IBOutlet UILabel *lblLocation;

@property (nonatomic, assign) IBOutlet UILabel *lblYear;

@property (nonatomic, assign) IBOutlet UIImageView *ivFoward;

@end
