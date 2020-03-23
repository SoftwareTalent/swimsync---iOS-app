//
//  MYSNewMeetViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/24/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSNewMeetViewController.h"
#import "MYSDatePickerView.h"
#import "MYSMeetInfo.h"

#import "DFPBannerView.h"

@interface MYSNewMeetViewController ()<GADBannerViewDelegate>
{
    MYSDatePickerView *_datePicker;
    
    MYSMeetInfo *_tempMeet;
}


// Text view meet title
@property (weak, nonatomic) IBOutlet UITextField *txtMeetTitle;
// Text view meet location
@property (weak, nonatomic) IBOutlet UITextField *txtMeetLocation;
// Text view meet city
@property (weak, nonatomic) IBOutlet UITextField *txtMeetCity;
// Button meet start date
@property (weak, nonatomic) IBOutlet UIButton *btnMeetStartDate;
// Button meet end date
@property (weak, nonatomic) IBOutlet UIButton *btnMeetEndDate;
// Button meet course type
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgCourseType;
// Date picker view
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, retain) DFPBannerView *bannerView;

// Start date
@property (strong, nonatomic) NSDate *startDate;
// End date
@property (strong, nonatomic) NSDate *endDate;

@end

@implementation MYSNewMeetViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _datePicker = [[MYSDatePickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 162)];
    
    if(self.meet != nil)
    {
        _tempMeet = [[MYSMeetInfo alloc] initWithMeetData:self.meet];
    }
    else
    {
        _tempMeet = [[MYSMeetInfo alloc] init];
        _tempMeet.meetStartDate = [NSDate date];
        _tempMeet.meetEndDate = [NSDate date];
        _tempMeet.courseType = 0;
    }
    
    [self updateUI];
    
    // Hide date picker view
    [_datePickerView setHidden:YES];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    else
        self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    self.bannerView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - 60 - CGRectGetHeight(self.bannerView.frame) / 2);
    
    self.bannerView.rootViewController = self;
    self.bannerView.adUnitID = EG_ADMOB_BANNERAD;
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL isPurchased = [prefs boolForKey:@"purchased"];
    
    BOOL isPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue];
    self.bannerView.hidden = isPurchased;
}

- (void)updateUI
{
    _txtMeetLocation.text = _tempMeet.meetLocation;
    _txtMeetCity.text = _tempMeet.meetCity;
    _txtMeetTitle.text = _tempMeet.meetTitle;
    _sgCourseType.selectedSegmentIndex = _tempMeet.courseType;
    
    NSString *date = [MethodHelper convertFullMonth:_tempMeet.meetStartDate];
    [_btnMeetStartDate setTitle:date forState:UIControlStateNormal];
    
    date = [MethodHelper convertFullMonth:_tempMeet.meetEndDate];
    [_btnMeetEndDate setTitle:date forState:UIControlStateNormal];
}



#pragma mark - === UITableView Datasource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - === UITextField Delegate Methods ===

#pragma mark - === UIDatePickerView Delegate Methods ===


#pragma mark - === Implement Action Methods ===

- (IBAction)btnCancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDonePressed:(id)sender
{
    if (![self validate])
    {
        return;
    }
    
    // Save new meet
    _tempMeet.meetTitle = _txtMeetTitle.text;
    _tempMeet.meetLocation = _txtMeetLocation.text;
    _tempMeet.meetCity = _txtMeetCity.text;
    _tempMeet.courseType = _sgCourseType.selectedSegmentIndex;
    
    if(self.meet)
    {
        if([self.meet.courseType intValue] == _tempMeet.courseType)
        {
            [_tempMeet update];
        }
        else
        {
            [_tempMeet update];
            
            [[MYSDataManager shared] updateAllTimesOfMeet:self.meet];
        }
    }
    else
    {
        [_tempMeet save];
        
        [self.delegate addedNewMeet:_tempMeet.meetData];
    }
    
    [[MYSDataManager shared] updateLocalNotifications];
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validate
{
    if ([_txtMeetTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"INPUT_MEET", nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
        return NO;
    }
    
    NSTimeInterval timeInterval = [_tempMeet.meetEndDate timeIntervalSinceDate:_tempMeet.meetStartDate];
    if(timeInterval < 0)
    {
        [MethodHelper showAlertViewWithTitle:@"Alert" andMessage:@"Please pick a valid end date after start date." andButtonTitle:NSLocalizedString(@"OK", nil)];
        return NO;
    }
    
    return YES;
}

- (IBAction)btnMeetStartDatePressed:(id)sender
{
    
    // Dismiss text field
    [_txtMeetTitle endEditing:YES];
    [_txtMeetLocation endEditing:YES];
    [_txtMeetCity endEditing:YES];
    
    // Call date picker view
//    [_datePickerView setHidden:NO];
    
    // Set selected for start date button
    _btnMeetStartDate.selected = YES;
    // Set non-select for end date button
    _btnMeetEndDate.selected = NO;
    
//    if(self.createPassedMeet)
//    {
//        _datePicker.datePicker.maximumDate = [NSDate date];
//    }
    
    [_datePicker showDatePickerViewInView:self.tabBarController.view mode:UIDatePickerModeDate selectedDate:_tempMeet.meetStartDate title:MTLocalizedString(@"Start Date") changeValueBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        
        NSString *date = [MethodHelper convertFullMonth:selectedDate];
        _tempMeet.meetStartDate = selectedDate;
        [_btnMeetStartDate setTitle:date forState:UIControlStateNormal];
        
    } doneBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        
        NSString *date = [MethodHelper convertFullMonth:selectedDate];
        _tempMeet.meetStartDate = selectedDate;
        [_btnMeetStartDate setTitle:date forState:UIControlStateNormal];
        _btnMeetStartDate.selected = NO;
        
        _tempMeet.meetEndDate = selectedDate;
        [_btnMeetEndDate setTitle:date forState:UIControlStateNormal];
        _btnMeetEndDate.selected = NO;
        
    } cancelBlock:^(MYSDatePickerView *picker) {
        
        _btnMeetStartDate.selected = NO;
        
    }];
}

- (IBAction)btnMeetEndDatePressed:(id)sender
{
    
    // Dismiss text field
    [_txtMeetTitle endEditing:YES];
    [_txtMeetLocation endEditing:YES];
    [_txtMeetCity endEditing:YES];
    
    // Call date picker view
//    [_datePickerView setHidden:NO];
    
    // Set selected for end date button
    _btnMeetEndDate.selected = YES;
    // Set non-select for start date button
    _btnMeetStartDate.selected = NO;
    
    [_datePicker showDatePickerViewInView:self.tabBarController.view mode:UIDatePickerModeDate selectedDate:_tempMeet.meetEndDate title:MTLocalizedString(@"End Date") changeValueBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        
        NSString *date = [MethodHelper convertFullMonth:selectedDate];
        _tempMeet.meetEndDate = selectedDate;
        [_btnMeetEndDate setTitle:date forState:UIControlStateNormal];
        
    } doneBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        
        NSString *date = [MethodHelper convertFullMonth:selectedDate];
        _tempMeet.meetEndDate = selectedDate;
        [_btnMeetEndDate setTitle:date forState:UIControlStateNormal];
        _btnMeetEndDate.selected = NO;
        
    } cancelBlock:^(MYSDatePickerView *picker) {
        
        _btnMeetEndDate.selected = NO;
        
    }];
    
}

- (IBAction)dateValueChanged:(id)sender
{
    
    NSString *date = [MethodHelper convertFullMonth:_datePickerView.date];
    if ([_btnMeetStartDate isSelected]) {
        _startDate = _datePickerView.date;
        [_btnMeetStartDate setTitle:date forState:UIControlStateNormal];
    }else if ([_btnMeetEndDate isSelected]){
        _endDate = _datePickerView.date;
        [_btnMeetEndDate setTitle:date forState:UIControlStateNormal];
    }
}

#pragma mark - GABDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view {
//    NSLog(@"ADBanner==>adViewDidReceiveAd");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"ADBanner==>adViewFailed, %@", error.userInfo[@"error"]);
}


@end
