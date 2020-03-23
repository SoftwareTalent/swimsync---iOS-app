//
//  ApplicationTimer.m
//  SGCarDepre
//
//  Created by Krishna Kant Kaira on 24/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "ApplicationTimer.h"

@interface ApplicationTimer ()

@property (nonatomic, assign) BOOL canStartTimer;

@end

@implementation ApplicationTimer

//here we are listening for any touch. If the screen receives touch, the timer is reset
-(void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    
    if (!myidleTimer) [self resetApplicationTimeOutTimer];
    
    if (self.canStartTimer) {
        
        NSSet *allTouches = [event allTouches];
        if ([allTouches count] > 0) {
            
            UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
            if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
                [self resetApplicationTimeOutTimer];
        }
    }
}

//as labeled...reset the timer
-(void)resetApplicationTimeOutTimer {
    
    [self invalidateApplicationTimeOutTimer];
    if (self.canStartTimer)
        //default value is 5 min
        myidleTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

//invalidate existing timer
-(void)invalidateApplicationTimeOutTimer {
    
    if ([myidleTimer isValid]) {
        [myidleTimer invalidate];
        myidleTimer = nil;
    }
}

//if the timer reaches the limit as defined in kApplicationTimeoutInMinutes, post this notification
-(void)idleTimerExceeded {
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

-(void)resetApplicationTimerWithState:(BOOL)canTimedOut {

    self.canStartTimer = canTimedOut;
    [self resetApplicationTimeOutTimer];
}

@end