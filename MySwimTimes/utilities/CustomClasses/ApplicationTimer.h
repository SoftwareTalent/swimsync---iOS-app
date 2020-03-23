//
//  ApplicationTimer.h
//  SGCarDepre
//
//  Created by Krishna Kant Kaira on 24/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface ApplicationTimer : UIApplication {
    NSTimer *myidleTimer;
}

-(void)resetApplicationTimerWithState:(BOOL)canTimedOut;

@end