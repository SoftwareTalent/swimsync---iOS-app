//
//  MYSNewMeetViewController.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/24/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This controller is used for creating a new "Meet"
 */

#import <UIKit/UIKit.h>

@protocol MYSNewMeetViewControllerDelegate <NSObject>

- (void) addedNewMeet:(MYSMeet *)meet;

@end

@interface MYSNewMeetViewController : UIViewController

@property (nonatomic, assign) id <MYSNewMeetViewControllerDelegate> delegate;

@property (nonatomic, retain) MYSMeet *meet;

@property (nonatomic, assign) BOOL createPassedMeet;

@end
