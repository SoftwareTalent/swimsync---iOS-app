//
//  MYSProgressChartOptionViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/7/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSProgressChartOptionViewController.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSChooseProfileViewController.h"

#import "MYSLapViewController.h"
#import "MYSSelectDistanceViewController.h"

@interface MYSProgressChartOptionViewController ()<MYSChooseProfileViewControllerDelegate, MYSSelectDistanceViewControllerDelegate>
{
    BOOL _isSelectingAnotherSwimmer;
    
    int _contentMaxHeight;
    int _contentMinHeight;
}

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

@property (nonatomic, assign) IBOutlet UITableView *tvMain;

@property (nonatomic, assign) IBOutlet UIView *viewContents;

@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgCourseType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_distance;

@property (nonatomic, assign) IBOutlet UIButton *btnFLY;
@property (nonatomic, assign) IBOutlet UIButton *btnBK;
@property (nonatomic, assign) IBOutlet UIButton *btnBR;
@property (nonatomic, assign) IBOutlet UIButton *btnFR;
@property (nonatomic, assign) IBOutlet UIButton *btnIM;

@property (nonatomic, assign) IBOutlet UITextField *txtDistance;

@property (nonatomic, assign) IBOutlet UITextField *txtNumberOfTimes;

@property (nonatomic, assign) IBOutlet UITextField *txtAnotherSwimmer;

@property (nonatomic, assign) IBOutlet UISwitch *swtAnotherSwimmer;
@property (nonatomic, assign) IBOutlet UISwitch *swtAnotherSwimmerPB;
@property (nonatomic, assign) IBOutlet UISwitch *swtShowPB;
@property (nonatomic, assign) IBOutlet UISwitch *swtShowGoalTime;
@property (nonatomic, assign) IBOutlet UISwitch *swtCustomeTimeLine;

@property (nonatomic, assign) IBOutlet UITextField *txtCustomeTimeTitle;
@property (nonatomic, assign) IBOutlet UITextField *txtCustomeTimeValue;

@end

@implementation MYSProgressChartOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment_distance addTarget:self action:@selector(distanceSegmentSelected:) forControlEvents:UIControlEventValueChanged];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        _contentMaxHeight = 480;
        _contentMinHeight = 420;
    }
    else
    {
        _contentMaxHeight = 550;
        _contentMinHeight = 470;
    }
    
    [self _initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment Controller Action Method
- (IBAction)distanceSegmentSelected:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 3)
        [self performSegueWithIdentifier:@"selectdistance" sender:self.txtDistance.text];
    else
        _txtDistance.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"addtime"])
    {
        MYSLapViewController *lapVC = segue.destinationViewController;
        int64_t t = [MYSLap milisecondsFromLapTime:sender];
        [lapVC setAddNewTime:YES];
        [lapVC setTimeValue:t];
        [lapVC setTimeValueChangedBlock:^(int64_t timeValue)
         {
             self.txtCustomeTimeValue.text = [MYSLap getSplitTimeStringFromMiliseconds:timeValue withMinimumFormat:NO];

         }];
    }
    else if([segue.identifier isEqualToString:@"selectdistance"])
    {
        MYSSelectDistanceViewController *vc = segue.destinationViewController;
        vc.distance = [sender doubleValue];
        vc.delegate = self;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    [self.view endEditing:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self loadSelectedSwimmerData];
    
    [self updateUI];
    
    if ([self.txtDistance.text integerValue] > 0) {
        switch ([self.txtDistance.text integerValue]) {
            case 50: [self.segment_distance setSelectedSegmentIndex:0]; break;
            case 100: [self.segment_distance setSelectedSegmentIndex:1]; break;
            case 200: [self.segment_distance setSelectedSegmentIndex:2]; break;
            default: [self.segment_distance setSelectedSegmentIndex:3]; break;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil]; //this is it!
    
    float diff = (keyboardRect.origin.y < self.view.frame.size.height) ? 0 : (_contentMaxHeight - _contentMinHeight);
    
    self.tvMain.frame = CGRectMake(self.tvMain.frame.origin.x,
                                   self.tvMain.frame.origin.y,
                                   self.tvMain.frame.size.width,
                                   keyboardRect.origin.y - self.tvMain.frame.origin.y - diff);
    
    self.tvMain.contentSize = CGSizeMake(CGRectGetWidth(self.tvMain.frame), _contentMaxHeight);
    
    [self.tvMain setContentOffset:CGPointMake(self.tvMain.contentOffset.x, self.tvMain.contentSize.height - CGRectGetHeight(self.tvMain.frame)) animated:NO] ;
}

- (void) loadSelectedSwimmerData
{
    if(self.swimmer == nil)
        return;
    
    self.swimmerView.ivProfile.image = [UIImage imageWithData:self.swimmer.image];
    
    self.swimmerView.lblUserName.text = self.swimmer.name;
    self.swimmerView.lblClub.text = self.swimmer.nameSwimClub;
    self.swimmerView.lblLocation.text = [NSString stringWithFormat:@"%@, %@", self.swimmer.city, self.swimmer.country];
    self.swimmerView.lblYear.text = [NSString stringWithFormat:@"%.0f years",[MethodHelper countYearOld2:self.swimmer.birthday]];
}

- (void) _initView
{
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 70.0f);
    self.swimmerView.ivDeclour.hidden = YES;
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwimmerView:)];
//    [self.swimmerView addGestureRecognizer:tapGesture];
//    tapGesture = nil;
    
    [self.view addSubview:self.swimmerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    toolbar.barTintColor = [UIColor colorWithRed:185.0f / 255.0f green:190.0f / 255.0f blue:195.0f / 255.0f alpha:1.0f];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexibleButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(closeKeyboard)];
    [doneButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                              forState:UIControlStateNormal];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexibleButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    
    [self.txtDistance setInputAccessoryView:toolbar];
    
    UIToolbar *toolbar1 = [[UIToolbar alloc] init];
    //[toolbar1 setBarStyle:UIBarStyleBlackTranslucent];
    toolbar1.barTintColor = [UIColor colorWithRed:185.0f / 255.0f green:190.0f / 255.0f blue:195.0f / 255.0f alpha:1.0f];
    [toolbar1 sizeToFit];
    
    UIBarButtonItem *flexibleButton1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton1 =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(closeKeyboard)];
    [doneButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                              forState:UIControlStateNormal];
    
    NSArray *itemsArray1 = [NSArray arrayWithObjects:flexibleButton1, doneButton1, nil];
    [toolbar1 setItems:itemsArray1];
    
    [self.txtNumberOfTimes setInputAccessoryView:toolbar1];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.strokeIndex = (int)[prefs integerForKey:CHART_STROKE];

    self.txtDistance.text = [NSString stringWithFormat:@"%@", [prefs objectForKey:CHART_DISTANCE]];
    
    self.sgCourseType.selectedSegmentIndex = [prefs integerForKey:CHART_COURSE];

    self.txtNumberOfTimes.text = [NSString stringWithFormat:@"%@", [prefs objectForKey:CHART_NUMER_OF_TIMES]];
    
    self.swtAnotherSwimmer.on = [prefs boolForKey:CHART_ANOTHER_SWIMMER];
    
    self.swtShowPB.on = [prefs boolForKey:CHART_SHOW_PB];
    
    self.swtShowGoalTime.on = [prefs boolForKey:CHART_SHOW_GOAL];
    
    self.swtAnotherSwimmerPB.on = [prefs boolForKey:CHART_SHOW_PB_OTHER];
    
    self.swtCustomeTimeLine.on = [prefs boolForKey:CHART_SHOW_CUSTOM];

    self.txtCustomeTimeTitle.text = [NSString stringWithFormat:@"%@", [prefs objectForKey:CHART_CUSTOM_TITLE]];
    
    int64_t time = [[prefs objectForKey:CHART_CUSTOM_TIME] longLongValue];
    
    if(time == 0)
        self.txtCustomeTimeValue.text = @"";
    else
        self.txtCustomeTimeValue.text = [MYSLap getSplitTimeStringFromMiliseconds:time withMinimumFormat:YES];
    
    int64_t anotherUserId = [[prefs objectForKey:CHART_ANOTHER_SWIMMER_ID] longLongValue];
    
    if(anotherUserId != -1)
    {
        MYSProfile *anotherSwimmer = [[MYSDataManager shared] getProfileWithId:[NSString stringWithFormat:@"%lld", anotherUserId]];
        
        if(anotherSwimmer)
        {
            self.txtAnotherSwimmer.text = anotherSwimmer.name;
        }
    }
    
    self.tvMain.contentSize = CGSizeMake(CGRectGetWidth(self.tvMain.frame), _contentMaxHeight);
}

- (void) tapSwimmerView:(UITapGestureRecognizer *)tapGesture
{
    MYSChooseProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSChooseProfileViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) closeKeyboard
{
    [self.txtDistance resignFirstResponder];
    [self.txtNumberOfTimes resignFirstResponder];
}

- (void) initView
{
    
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setInteger:self.strokeIndex forKey:CHART_STROKE];
    [prefs setInteger:[self.txtDistance.text integerValue] forKey:CHART_DISTANCE];
    [prefs setInteger:self.sgCourseType.selectedSegmentIndex forKey:CHART_COURSE];
    [prefs setInteger:[self.txtNumberOfTimes.text integerValue] forKey:CHART_NUMER_OF_TIMES];
    [prefs setBool:self.swtAnotherSwimmer.on forKey:CHART_ANOTHER_SWIMMER];
    [prefs setBool:self.swtShowPB.on forKey:CHART_SHOW_PB];
    [prefs setBool:self.swtShowGoalTime.on forKey:CHART_SHOW_GOAL];
    //[prefs setBool:self.swtAnotherSwimmerPB.on forKey:CHART_SHOW_PB_OTHER];
    [prefs setBool:NO forKey:CHART_SHOW_PB_OTHER];
    
    if(self.txtCustomeTimeTitle.text.length > 0)
    {
        [prefs setBool:self.swtCustomeTimeLine.on forKey:CHART_SHOW_CUSTOM];
        [prefs setObject:self.txtCustomeTimeTitle.text forKey:CHART_CUSTOM_TITLE];
        
        int64_t customTime = [MYSLap milisecondsFromLapTime:self.txtCustomeTimeValue.text];
        [prefs setObject:[NSNumber numberWithLongLong:customTime] forKey:CHART_CUSTOM_TIME];
    }
    else
    {
        [prefs setBool:NO forKey:CHART_SHOW_CUSTOM];
        [prefs setObject:self.txtCustomeTimeTitle.text forKey:CHART_CUSTOM_TITLE];
        
        int64_t customTime = [MYSLap milisecondsFromLapTime:self.txtCustomeTimeValue.text];
        [prefs setObject:[NSNumber numberWithLongLong:customTime] forKey:CHART_CUSTOM_TIME];
    }

    [prefs synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectStroke:(id)sender
{
    int tag = (int)((UIButton *)sender).tag;
    
    self.strokeIndex = tag;
    
    [self initReferenceLines];
    
    [self updateUI];
}

- (void) initReferenceLines
{
    self.swtAnotherSwimmerPB.on = NO;
    self.swtShowPB.on = NO;
    self.swtShowGoalTime.on = NO;
    self.swtCustomeTimeLine.on = NO;
}

- (void) updateUI
{
    self.btnFLY.selected = (self.strokeIndex == 0);
    self.btnBK.selected = (self.strokeIndex == 1);
    self.btnBR.selected = (self.strokeIndex == 2);
    self.btnFR.selected = (self.strokeIndex == 3);
    self.btnIM.selected = (self.strokeIndex == 4);
    
    if(self.strokeIndex == 0)
    {
        self.lblStrokeName.text = @"Butterfly";
        
    }
    else if(self.strokeIndex == 1)
    {
        self.lblStrokeName.text = @"Backstroke";
    }
    else if(self.strokeIndex == 2)
    {
        self.lblStrokeName.text = @"Breaststroke";
    }
    else if(self.strokeIndex == 3)
    {
        self.lblStrokeName.text = @"Freestyle";
    }
    else if(self.strokeIndex == 4)
    {
        self.lblStrokeName.text = @"Individual medley";
    }
    
    self.viewContents.frame = CGRectMake(self.viewContents.frame.origin.x, self.viewContents.frame.origin.y, CGRectGetWidth(self.viewContents.frame), self.swtCustomeTimeLine.on ? _contentMaxHeight : _contentMinHeight);
    
    self.tvMain.contentSize = CGSizeMake(CGRectGetWidth(self.tvMain.frame), _contentMaxHeight);
    
    self.txtAnotherSwimmer.hidden = !self.swtAnotherSwimmer.on;
}

- (IBAction)onChangeSwitch:(id)sender
{
    [self updateUI];
    
    UISwitch *switchView = (UISwitch *)sender;
    
    if(switchView == self.swtAnotherSwimmer)
    {
        if(!self.swtAnotherSwimmer.on)
        {
            //[self.swtAnotherSwimmerPB setOn:NO animated:YES];
        }
    }
    else if(switchView == self.swtCustomeTimeLine)
    {
        if(self.swtCustomeTimeLine.on)
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [self.tvMain setContentOffset:CGPointMake(self.tvMain.contentOffset.x, self.tvMain.contentSize.height - CGRectGetHeight(self.tvMain.frame)) animated:YES];
            }
        }
    }
}

- (void) selectAnotherSwimmer
{
    _isSelectingAnotherSwimmer = YES;
    
    MYSChooseProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSChooseProfileViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark MYSChooseSwimmerViewControllerDelegate

- (void) chooseProfile:(MYSProfile *) profile
{
    if(_isSelectingAnotherSwimmer)
    {
        _isSelectingAnotherSwimmer = NO;
        
        if(self.swimmer == profile)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can't select another swimmer yourself" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
            alertView = nil;
            
            return;
        }
        
        int64_t userid = [profile.userid longLongValue];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSNumber numberWithLongLong:userid] forKey:CHART_ANOTHER_SWIMMER_ID];
        
        self.txtAnotherSwimmer.text = profile.name;
    }
    else
    {
        self.swimmer = profile;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtCustomeTimeValue)
    {
        [self performSegueWithIdentifier:@"addtime" sender:textField.text];
        
        return NO;
    }
    else if(textField == self.txtAnotherSwimmer)
    {
        [self selectAnotherSwimmer];
        
        return NO;
    }
    else if(textField == self.txtCustomeTimeTitle)
    {
        //[self keyboardWillShow];
        
        return YES;
    }
    else if(textField == self.txtDistance)
    {
//        [self performSegueWithIdentifier:@"selectdistance" sender:textField.text];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.txtCustomeTimeTitle == textField)
    {
        
    }
    else if(self.txtDistance == textField)
    {
        [self initReferenceLines];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark MYSSelectDistanceViewControllerDelegate

- (void) selectDistance:(double)distance
{
    if(distance == 33.3)
        self.txtDistance.text = [NSString stringWithFormat:@"%.1f", distance];
    else
        self.txtDistance.text = [NSString stringWithFormat:@"%.0f", distance];
}

@end
