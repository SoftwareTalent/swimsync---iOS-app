//
//  MYSStopwatchViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/11/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSStopwatchViewController.h"
#import "MYSLapCell.h"
#import "MYSCustomTabBarViewController.h"

#import "MYSNewManualTimeViewController.h"

#define kTimerInterval           0.01

@interface MYSStopwatchViewController ()<UIAlertViewDelegate>
{
    __weak NSMutableArray *_currentLaps;
    MYSLapInfo *_currentLap;
}

// Label stopwatch
@property (strong, nonatomic) IBOutlet UILabel *lblStopwatch;
// Label lap
@property (weak, nonatomic) IBOutlet UILabel *lblLapTime;
// Table lap
@property (weak, nonatomic) IBOutlet UITableView *tbvLap;
// Button start
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
// Button stop
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
// Button lap
@property (weak, nonatomic) IBOutlet UIButton *btnLap;
// Button reset
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (strong, nonatomic) MYSStopWatch *stopWatch;
//@property (nonatomic, assign) NSTimeInterval time;
//@property (nonatomic, assign) NSTimeInterval lapTime;
@property (nonatomic, readonly) BOOL running;
@property (strong, nonatomic) NSTimer   *stopWatchTimer; // Store the timer that fires after a certain time
//@property (strong, nonatomic) NSDate    *startDate; // Stores the date of the click on the start button *
@property (strong, nonatomic) NSArray   *laps;  // List of lap time
//@property (strong, nonatomic) NSDate    *lapStartDate; // Stores the date of the click on the start button *

@end

@implementation MYSStopwatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"newtime"])
    {
        MYSNewManualTimeViewController *vc = segue.destinationViewController;
        vc.aryStopwatchLaps = [MYSDataManager shared].currentStopwatchLapsData;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _currentLaps = [MYSDataManager shared].currentStopwatchLapsData;
    
    [self initStopWatchData];
    
    [self onResetPressed:nil];
    
//    if ([_currentLaps count] > 0)
//    {
//        [self onResetPressed:nil];
//    }
//    else
//    {
//        [self setTime:_stopWatch.timeValue];
//    }
    
    [_tbvLap reloadData];
}

#pragma mark - === Implement Instance Methods ===

- (void)updateTimer
{
    NSDate* now = [NSDate date];
    NSTimeInterval offset = [now timeIntervalSinceDate:_stopWatch.startDate];
    _stopWatch.startDate = now;
    [self setTime:_stopWatch.timeValue + offset];
    
    offset = [now timeIntervalSinceDate:_stopWatch.lapStartDate];
    _stopWatch.lapStartDate = now;
    [self setLapTime:_stopWatch.lapTimeValue + offset];
}

- (void)loadLapsData {
    _laps = [[MYSDataManager shared] getAllLapsInDatabase];
}

/**
 Init stop watch data and resume stop watch running
 */
- (void) initStopWatchData
{
    if (_stopWatch == nil) {
        _stopWatch = [[MYSDataManager shared] getCurrentStopWatch];
    }
    
    _stopWatch.lapStartDate = [NSDate date];
    _stopWatch.runningValue = NO;
    
    [[MYSDataManager shared] save];
    
    // Check to resume stop watch
    if (_stopWatch.runningValue == YES) {
        [self setTime:_stopWatch.timeValue];
        [self setLapTime:_stopWatch.lapTimeValue];
        
        [self updateTimer];
        [self resumeStopWatch];
    } else {
        [self setTime:_stopWatch.timeValue];
        [self setLapTime:_stopWatch.lapTimeValue];
    }
}

#pragma mark - === Properties ===
-(void)setTime:(float)time
{
    if (time != _stopWatch.timeValue)
    {
        _stopWatch.timeValue = time;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (time > 24*60*60) {
        // Time larger than 1 day
        [dateFormatter setDateFormat:@"dd:HH:mm:ss.SS"];
    } else if (time > 60*60) {
        // Time larger 1 hour
        [dateFormatter setDateFormat:@"HH:mm:ss.SS"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss.SS"];
    }
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];

    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    self.lblStopwatch.text = timeString;
//    DebugLog(@" %.2f - %@", time, timeString);
    
    dateFormatter = nil;
}

-(BOOL)running
{
    BOOL status = (_stopWatchTimer != nil);
    return status;
}

-(void)setLapTime:(NSTimeInterval)lapTime
{
    if (lapTime != _stopWatch.lapTimeValue) {
        _stopWatch.lapTimeValue = lapTime;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (lapTime > 24*60*60) {
        // Time larger than 1 day
        [dateFormatter setDateFormat:@"dd:HH:mm:ss.SS"];
    } else if (lapTime > 60*60) {
        // Time larger 1 hour
        [dateFormatter setDateFormat:@"HH:mm:ss.SS"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss.SS"];
    }
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:lapTime]];
    self.lblLapTime.text = timeString;
}

#pragma mark - === Implement Action Methods ===
- (void) resumeStopWatch
{
    // When stopwatch is started --> Show stop and lap button
    [_btnStop setHidden:NO];
    [_btnLap setHidden:NO];
    // Hide start and reset button
    [_btnStart setHidden:YES];
    [_btnReset setHidden:YES];
    // Enable user interaction on lap button
    [_btnLap setUserInteractionEnabled:YES];
    
    // Update stopwatch status
    _stopWatch.runningValue = YES;
    
    _stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                       target:self
                                                     selector:@selector(updateTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_stopWatchTimer forMode:NSRunLoopCommonModes];
}

- (IBAction)onStartPressed:(id)sender
{
    // When stopwatch is started --> Show stop and lap button
    [_btnStop setHidden:NO];
    [_btnLap setHidden:NO];
    // Hide start and reset button
    [_btnStart setHidden:YES];
    [_btnReset setHidden:YES];
    // Enable user interaction on lap button
    [_btnLap setUserInteractionEnabled:YES];
    
    // Update stopwatch status
    _stopWatch.runningValue = YES;
    
    // Create the stop watch timer that fires every 10 ms
    if (self.running == NO) {
        _stopWatch.startDate = [NSDate date];
        _stopWatch.lapStartDate = [NSDate date];
        
        _stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_stopWatchTimer forMode:NSRunLoopCommonModes];
    }
    
    [[MYSDataManager shared] save];
}

- (IBAction)onStopPressed:(id)sender
{
    // When stopwatch is stopped --> Show start and reset button
    [_btnStart setHidden:NO];
    [_btnReset setHidden:NO];
    // Hide stop and lap button
    [_btnStop setHidden:YES];
    [_btnLap setHidden:YES];
    
    MYSLapInfo *lapInfo = [[MYSLapInfo alloc] initWithLapTime:[MYSLap milisecondsFromLapTime:_lblStopwatch.text] - _currentLap.totalTimeToCurrentLap];
    if (_currentLap != nil) {
        lapInfo.totalTimeToCurrentLap = lapInfo.lapTime + _currentLap.totalTimeToCurrentLap;
    } else {
        lapInfo.totalTimeToCurrentLap = lapInfo.lapTime;
    }
    [[MYSDataManager shared].currentStopwatchLapsData addObject:lapInfo];
    _currentLap = lapInfo;
    
    self.lblLapTime.text = @"00:00.00";
    self.lapTime = 0;
    _stopWatch.lapStartDate = [NSDate date];
    
    [_tbvLap beginUpdates];
    [_tbvLap insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentLaps.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tbvLap endUpdates];
    
    [_tbvLap scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentLaps.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    // Stop stopwatch
    if (self.running == YES) {
        [self.stopWatchTimer invalidate];
        self.stopWatchTimer = nil;
//        [self updateTimer];
        
        _stopWatch.runningValue = NO;
    }
    
    // Show alert to save new time
    [MethodHelper showAlertViewWithDelegate:self title:MTLocalizedString(@"NEW_TIME") andMessage:MTLocalizedString(@"SAVE_NEW_TIME") andCancelButtonTitle:MTLocalizedString(@"NO") andOkButtonTitle:MTLocalizedString(@"YES")];
    
    [[MYSDataManager shared] save];
}

- (IBAction)onLapPressed:(id)sender
{
    MYSLapInfo *lapInfo = [[MYSLapInfo alloc] initWithLapTime:[MYSLap milisecondsFromLapTime:_lblStopwatch.text] - _currentLap.totalTimeToCurrentLap];
    if (_currentLap != nil) {
        lapInfo.totalTimeToCurrentLap = lapInfo.lapTime + _currentLap.totalTimeToCurrentLap;
    } else {
        lapInfo.totalTimeToCurrentLap = lapInfo.lapTime;
    }
    [[MYSDataManager shared].currentStopwatchLapsData addObject:lapInfo];
    _currentLap = lapInfo;
    
    self.lblLapTime.text = @"00:00.00";
    self.lapTime = 0;
    _stopWatch.lapStartDate = [NSDate date];
    
//    // Record lap data
//    MYSLap *aLap = [[MYSDataManager shared] saveLapWithTime:_lblLapTime.text];
//    [_stopWatch addLapsObject:aLap];
//    [[MYSDataManager shared] save];
//    
//    // Reset lap time
    

    [_tbvLap beginUpdates];
    [_tbvLap insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentLaps.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tbvLap endUpdates];

    [_tbvLap scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentLaps.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (IBAction)onResetPressed:(id)sender
{
    // Show start and lap button
    [_btnStart setHidden:NO];
    [_btnLap setHidden:NO];
    // Hide stop and reset button
    [_btnStop setHidden:YES];
    [_btnReset setHidden:YES];
    // Disbale user interaction on lap button
    [_btnLap setUserInteractionEnabled:NO];
    
    // Clear stopwatch label, lap label
    _lblStopwatch.text = @"00:00.00";
    _lblLapTime.text = @"00:00.00";
    
    // Reset start date, lap start date, time
    _stopWatch.startDate = nil;
    _stopWatch.lapStartDate = nil;
    self.time = 0;
    self.lapTime = 0;
    _stopWatch.runningValue = NO;
    
    [[MYSDataManager shared].currentStopwatchLapsData removeAllObjects];
    _currentLap = nil;
    
    // Clear data on lap table view
//    [[MYSDataManager shared] deleteAllLapsWithTime:nil];
//    [self loadLapsData];
    [_tbvLap reloadData];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - === UITableView Datasource ===
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentLaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = LapCellIdentifier;
    
    MYSLapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MYSLapInfo *currentLap = _currentLaps[indexPath.row];
    cell.lblLapNumber.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.lblLapSplit.text = [MYSLap getSplitTimeStringFromMiliseconds:currentLap.lapTime withMinimumFormat:NO];
    cell.lblLapTotal.text = [MYSLap getSplitTimeStringFromMiliseconds:currentLap.totalTimeToCurrentLap withMinimumFormat:NO];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        cell.lblLapNumber.frame = CGRectMake(20, 0, 60, 43);
        cell.lblLapSplit.frame = CGRectMake(220, 0, 200, 43);
        cell.lblLapTotal.frame = CGRectMake(500, 0, 200, 43);
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGSize tableSize = tableView.frame.size;
    
    // Number label
    UILabel *number = [[UILabel alloc]init];
    number.text = MTLocalizedString(@"Lap");
    number.backgroundColor = [UIColor clearColor];
    number.textColor = [UIColor whiteColor];
    number.font = [UIFont boldSystemFontOfSize:12];
    number.textAlignment = NSTextAlignmentCenter;
    
    // Split
    UILabel *split = [[UILabel alloc]init];
    split.text = MTLocalizedString(@"Split");
    split.backgroundColor = [UIColor clearColor];
    split.textColor = [UIColor whiteColor];
    split.font = [UIFont boldSystemFontOfSize:12];
    split.textAlignment = NSTextAlignmentCenter;
    
    // Total
    UILabel *total = [[UILabel alloc]init];
    total.text = MTLocalizedString(@"Total");
    total.backgroundColor = [UIColor clearColor];
    total.textColor = [UIColor whiteColor];
    total.font = [UIFont boldSystemFontOfSize:12];
    total.textAlignment = NSTextAlignmentCenter;
  
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    view.backgroundColor = [UIColor colorWithRed:112.0f / 255.0f green:181.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        number.frame = CGRectMake(20, 0, 60, 25);
        split.frame = CGRectMake(220, 0, 200, 25);
        total.frame = CGRectMake(500, 0, 200, 25);
        view.frame = CGRectMake(0, 0, tableSize.width, 25);
    }
    else {
        
        number.frame = CGRectMake(20.0, 0, 40, 16);
        split.frame = CGRectMake(80, 0, 110, 16);
        total.frame = CGRectMake(190.0, 0, 110, 16);
        view.frame = CGRectMake(0, 0, 320.0, 16);
    }
    
    [number setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [split setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin)];
    [total setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    
    [view setAutoresizesSubviews:YES];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [view addSubview:number];
    [view addSubview:split];
    [view addSubview:total];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 25 : 16.0);
}

#pragma mark - === Alert View Delegate method ===
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {// NO button
    
        
    } else {// YES button
        // Update timer value;
        self.lblLapTime.text = @"00:00.00";
        self.lapTime = 0;
        _stopWatch.lapStartDate = [NSDate date];
        
//        // Go to new time view controller
//        MYSNewTimeViewController *newTimeVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MYSNewTimeViewController class])];
//        newTimeVC.stopWatch = _stopWatch;
//        newTimeVC.laps = [NSMutableArray arrayWithArray:[_stopWatch getAllSortedLaps]];
//        [self.navigationController pushViewController:newTimeVC animated:YES];
        
        [self performSegueWithIdentifier:@"newtime" sender:nil];
        
    }
}

@end
