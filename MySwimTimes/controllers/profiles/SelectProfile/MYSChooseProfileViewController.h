//
//  MYSChooseProfileViewController.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/17/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This view controller is used for choosing swimmers
 */

#import <UIKit/UIKit.h>

@protocol MYSChooseProfileViewControllerDelegate <NSObject>

@optional
- (void) chooseProfile:(MYSProfile *) profile;
@end

@interface MYSChooseProfileViewController : UIViewController


@property (nonatomic, assign) id<MYSChooseProfileViewControllerDelegate> delegate;

@end
