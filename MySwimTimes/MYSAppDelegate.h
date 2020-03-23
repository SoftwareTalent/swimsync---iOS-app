//
//  MYSAppDelegate.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/3/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)applicationShouldTimedout:(BOOL)shouldTimeout;
@end
