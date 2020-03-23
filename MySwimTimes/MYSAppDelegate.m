//
//  MYSAppDelegate.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/3/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSAppDelegate.h"
#import "ApplicationTimer.h"

@implementation MYSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"MySwimTimesDB.sqlite"];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self initChartOption];
    [NSThread sleepForTimeInterval:(4.0)];
    
    //add notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:NULL];
    
    [self applicationShouldTimedout:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (void) initChartOption
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    BOOL isExist = [prefs boolForKey:APPNAME];
    
    if(!isExist)
    {
        [prefs setBool:YES forKey:APPNAME];
        
        [prefs setInteger:0 forKey:CHART_STROKE];
        [prefs setInteger:100 forKey:CHART_DISTANCE];
        [prefs setInteger:0 forKey:CHART_COURSE];
        [prefs setInteger:20 forKey:CHART_NUMER_OF_TIMES];
        [prefs setBool:NO forKey:CHART_ANOTHER_SWIMMER];
        [prefs setInteger:-1 forKey:CHART_ANOTHER_SWIMMER_ID];
        [prefs setBool:NO forKey:CHART_SHOW_PB];
        [prefs setBool:NO forKey:CHART_SHOW_GOAL];
        [prefs setBool:NO forKey:CHART_SHOW_PB_OTHER];
        [prefs setBool:NO forKey:CHART_SHOW_CUSTOM];
        [prefs setObject:@"" forKey:CHART_CUSTOM_TITLE];
        [prefs setObject:[NSNumber numberWithLongLong:0] forKey:CHART_CUSTOM_TIME];
        
        [prefs synchronize];
    }
}

-(void)applicationShouldTimedout:(BOOL)shouldTimeout {
    
    ApplicationTimer *appInstance = (ApplicationTimer*)[UIApplication sharedApplication];
    [appInstance resetApplicationTimerWithState:shouldTimeout];
}

#pragma mark - Notification selector

-(void)applicationDidTimeout:(NSNotification *) notif {
    
    UINavigationController*navControlelr = (UINavigationController*)self.window.rootViewController;
    if (navControlelr.presentedViewController)
        [navControlelr.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    if (navControlelr.topViewController.presentedViewController)
        [navControlelr.topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    if ([navControlelr isKindOfClass:[UINavigationController class]])
        [navControlelr popToRootViewControllerAnimated:YES];
}

@end
