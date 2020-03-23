//
//  MYSSwimmerView.h
//  MySwimTimes
//
//  Created by SmarterApps on 8/11/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This view is used for showing swimmer info in Times, Graph view controller
 */

#import <UIKit/UIKit.h>
#import "MYSProfile.h"

typedef NS_ENUM(NSInteger, MYSSwimmerViewMode) {
    MYSSwimmerViewModeNormal = 0,
    MYSSwimmerViewModeEdit = 1,
};

@interface MYSSwimmerView : UIView

@property (nonatomic, strong) UIImageView *swimmmerImage;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbYearOld;
@property (nonatomic, strong) UILabel *lbClub;
@property (nonatomic, strong) UILabel *lbCountry;


- (void)showSwimmerInfo:(MYSProfile *)profile mode:(MYSSwimmerViewMode) viewMode;

@end
