//
//  MYSNewManualTimeViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 9/25/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSNewManualTimeViewController.h"

#import "MYSLapViewController.h"

#import "UIAlertView+Blocks.h"

#import "MYSNewMeetViewController.h"
#import "MYSSelectDistanceViewController.h"

@interface MYSNewManualTimeViewController ()<UITextFieldDelegate, MYSNewMeetViewControllerDelegate, UIAlertViewDelegate, MYSSelectDistanceViewControllerDelegate>
{
    int _selectedSwimmerIndex;
    
    int _selectedMeetIndex;
    
    int _selectedStrock;
    
    NSTimeInterval _totalTime;
    
    int _editingTimeIndex;
}

@property (nonatomic, assign) IBOutlet UIScrollView *svMain;

@property (nonatomic, assign) IBOutlet UIView *viewMain;

@property (nonatomic, assign) IBOutlet UITextField *txtSwimmerName;

@property (nonatomic, assign) IBOutlet UITextField *txtMeetTitle;
@property (nonatomic, assign) IBOutlet UITextField *txtMeetLocation;
@property (nonatomic, assign) IBOutlet UITextField *txtMeetDate;

@property (nonatomic, assign) IBOutlet UIButton *btnFLY;
@property (nonatomic, assign) IBOutlet UIButton *btnBK;
@property (nonatomic, assign) IBOutlet UIButton *btnBR;
@property (nonatomic, assign) IBOutlet UIButton *btnFR;
@property (nonatomic, assign) IBOutlet UIButton *btnIM;

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgCourse;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sgDistance;

@property (nonatomic, assign) IBOutlet UITextField *txtDistance;
@property (nonatomic, assign) IBOutlet UITextField *txtSwimTime;
@property (nonatomic, assign) IBOutlet UITextField *txtReactionTime;

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgStage;

@property (nonatomic, assign) IBOutlet UIView *viewLapHeader;

@property (nonatomic, assign) IBOutlet UIView *viewLaps;

@property (nonatomic, assign) IBOutlet UIView *viewPopMenu;

@property (nonatomic, assign) IBOutlet UITableView *tvPopmenu;

@property (nonatomic, assign) IBOutlet UILabel *lblHeaderLapNumber;
@property (nonatomic, assign) IBOutlet UILabel *lblHeaderLapTime;
@property (nonatomic, assign) IBOutlet UILabel *lblHeaderLapTotalTime;

@property (nonatomic, retain) NSMutableArray *arySwimmers;
@property (nonatomic, retain) NSMutableArray *aryMeets;

@property (nonatomic, retain) NSMutableArray *aryLapDatas;

@end

@implementation MYSNewManualTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_sgDistance addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.viewPopMenu.hidden = YES;
    
    
   
    
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
    
    NSArray *itemsArray1 = [NSArray arrayWithObjects:flexibleButton1, doneButton1, nil];
    [toolbar1 setItems:itemsArray1];
    
    [self.txtDistance setInputAccessoryView:toolbar1];
    toolbar1 = nil;
    flexibleButton1 = nil;
    doneButton1 = nil;
    
    [self refreshLapTimes];
    
    [self _initData];
    
         
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
//    [self.svMain addGestureRecognizer:tapGesture];
//    tapGesture = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment Controller Action Method

- (IBAction)segmentAction:(UISegmentedControl *)sender
{
//    [_sgDistance setHidden:YES];
    
    if (sender.selectedSegmentIndex == 3) {
        
        [self closeKeyboard];
        [self hidePopmenu];
        [self performSegueWithIdentifier:@"selectdistance" sender:self.txtDistance.text];
    }
    else {
        _txtDistance.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    }
    
    [self refreshLapTimes];
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
            if(_editingTimeIndex == -1)
            {
                self.txtSwimTime.text = [MYSLap getSplitTimeStringFromMiliseconds:timeValue withMinimumFormat:NO];
            }
            else if(_editingTimeIndex == 0)
            {
                self.txtReactionTime.text = [MYSLap getSplitTimeStringFromMiliseconds:timeValue withMinimumFormat:NO];
            }
            else
            {
                if([self checkValidLapTotalTime:timeValue index:(_editingTimeIndex - 1)])
                {
                    NSMutableDictionary *lapData = [self.aryLapDatas objectAtIndex:(_editingTimeIndex - 1)];
                    
                    UITextField *txtTotalTime = [lapData objectForKey:@"totaltime"];
                    txtTotalTime.text = [MYSLap getSplitTimeStringFromMiliseconds:timeValue withMinimumFormat:NO];
                    
                    [self updateLapTimes];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Entered time is not valid. Please check it." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alertView show];
                    alertView = nil;
                }
            }
        }];
    }
    else if([segue.identifier isEqualToString:@"selectdistance"])
    {
        MYSSelectDistanceViewController *vc = segue.destinationViewController;
        vc.distance = [sender doubleValue];
        vc.delegate = self;
    }
}

- (BOOL) checkValidLapTotalTime:(int64_t) time index:(int)index
{
    int64_t preTotalTime = 0;
    int64_t nextTotalTime = 0;
    
    if(index > 0)
    {
        NSMutableDictionary *lapData = [self.aryLapDatas objectAtIndex:(index - 1)];
        
        UITextField *txtTotalTime = [lapData objectForKey:@"totaltime"];
        
        preTotalTime = [MYSLap milisecondsFromLapTime:txtTotalTime.text];
    }
    
    if(index < (self.aryLapDatas.count - 1))
    {
        NSMutableDictionary *nextData = [self.aryLapDatas objectAtIndex:(index + 1)];
        
        UITextField *txtTotalTime = [nextData objectForKey:@"totaltime"];
        
        nextTotalTime = [MYSLap milisecondsFromLapTime:txtTotalTime.text];
    }
    
    if(time < preTotalTime)
        return NO;
    
    if(nextTotalTime > 0 && time >= nextTotalTime)
        return NO;
    
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self closeKeyboard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
 
    [self updateUI];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    
    self.svMain.frame = CGRectMake(self.svMain.frame.origin.x,self.svMain.frame.origin.y, self.svMain.frame.size.width, self.view.frame.size.height - self.svMain.frame.origin.x - 320);
    
    [UIView animateWithDuration:0.0 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.svMain.frame = CGRectMake(self.svMain.frame.origin.x,self.svMain.frame.origin.y, self.svMain.frame.size.width, self.view.frame.size.height - self.svMain.frame.origin.y);
    } completion:^(BOOL finished) {
        
    }];
}

 
- (void) _initData
{
    NSArray *arySwimmers = [[MYSDataManager shared] getAllProfiles];
   
    self.arySwimmers = [NSMutableArray arrayWithArray:[arySwimmers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                              NSString *obj1Name = ((MYSProfile *)obj1).name;
                              NSString *obj2Name = ((MYSProfile *)obj2).name;
                              
                              return [obj1Name compare:obj2Name];
                          }]];
    
    self.aryMeets = [[MYSDataManager shared] allMeets];
    
    if(self.time == nil)
    {
        _selectedSwimmerIndex = -1;
        _selectedMeetIndex = -1;
        _selectedStrock = -1;
    }
    else
    {
        BOOL isExistSwimmer = NO;
        for (int n = 0 ; n < self.arySwimmers.count ; n++) {
            
            MYSProfile *swimmer = [self.arySwimmers objectAtIndex:n];
            
            if([self.time.profile.userid longLongValue] == [swimmer.userid longLongValue])
            {
                _selectedSwimmerIndex = n;
                isExistSwimmer = YES;
            }
        }
        
        if(!isExistSwimmer) _selectedSwimmerIndex = -1;
        
        BOOL isExistMeet = NO;
        for (int n = 0 ; n < self.aryMeets.count ; n++) {
            
            MYSMeet *meet = [self.aryMeets objectAtIndex:n];
            
            if([self.time.meet.id longLongValue] == [meet.id longLongValue])
            {
                _selectedMeetIndex = n;
                isExistMeet = YES;
            }
        }
        
        if(!isExistMeet) _selectedMeetIndex = -1;
        
        _selectedStrock = [self.time.stroke intValue];
        
        self.txtDistance.text = [NSString stringWithFormat:@"%d", (int)[self.time.distance floatValue]];
        self.txtSwimTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[self.time.time longLongValue] withMinimumFormat:NO];
        self.txtReactionTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[self.time.reactionTime longLongValue] withMinimumFormat:NO];
        
        self.sgStage.selectedSegmentIndex = [self.time.stage intValue];
        
        self.aryStopwatchLaps = [[NSMutableArray alloc] init];
        
        NSMutableArray *laps = (NSMutableArray *)[self.time.laps allObjects];
        
        laps = (NSMutableArray *)[laps sortedArrayUsingComparator:^NSComparisonResult(MYSLap * obj1, MYSLap * obj2) {
            return [obj1.lapNumber compare:obj2.lapNumber];
        }];
        
        int lapIndex = 0;
        for (MYSLap *lap in laps) {
            
            MYSLapInfo *lapInfo = [[MYSLapInfo alloc] initWithLapTime:lap.splitTimeValue];
            lapInfo.lapNumber = lapIndex;
            
            [self.aryStopwatchLaps addObject:lapInfo];
            
            lapIndex ++;
        }
        
        [self refreshLapTimes];
    }
}

- (void) updateUI
{
    if(_selectedSwimmerIndex != -1)
    {
        MYSProfile *profile = [self.arySwimmers objectAtIndex:_selectedSwimmerIndex];
        self.txtSwimmerName.text = profile.name;
    }
    
    if(self.meet != nil)
    {
        self.txtMeetTitle.text = self.meet.title;
        
        self.txtMeetLocation.text = [NSString stringWithFormat:@"%@, %@", self.meet.location, self.meet.city];
        // Set data for date label
        NSString *startDate = @"";
        NSString *endDate = @"";
        if (self.meet.startDate != nil) {
            startDate = [MethodHelper convertFullMonth:self.meet.startDate];
        }
        if (self.meet.endDate != nil) {
            endDate = [MethodHelper convertFullMonth:self.meet.endDate];
        }
        if ([startDate isEqualToString:@""] && [endDate isEqualToString:@""]) {
            self.txtMeetDate.text = @"";
        } else {
            self.txtMeetDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
        }
        
        MYSCourseType courseType = [self.meet.courseType intValue];

        self.sgCourse.selectedSegmentIndex = courseType;
        self.sgCourse.userInteractionEnabled = NO;
    }
    if(_selectedMeetIndex != -1)
    {
        MYSMeet *meet = [self.aryMeets objectAtIndex:_selectedMeetIndex];
        
        self.txtMeetTitle.text = meet.title;
        
        self.txtMeetLocation.text = [NSString stringWithFormat:@"%@, %@", meet.location, meet.city];
        // Set data for date label
        NSString *startDate = @"";
        NSString *endDate = @"";
        if (meet.startDate != nil) {
            startDate = [MethodHelper convertFullMonth:meet.startDate];
        }
        if (meet.endDate != nil) {
            endDate = [MethodHelper convertFullMonth:meet.endDate];
        }
        if ([startDate isEqualToString:@""] && [endDate isEqualToString:@""]) {
            self.txtMeetDate.text = @"";
        } else {
            self.txtMeetDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
        }
        
        MYSCourseType courseType = [meet.courseType intValue];
        
        self.sgCourse.selectedSegmentIndex = courseType;
        self.sgCourse.userInteractionEnabled = NO;
        
        if(courseType == MYSCourseType_Open)
        {
            _selectedStrock = 3;
        }
    }
    
    //if(_selectedStrock != -1)
    {
        [self.btnFLY setSelected:(_selectedStrock == 0)];
        [self.btnBK setSelected:(_selectedStrock == 1)];
        [self.btnBR setSelected:(_selectedStrock == 2)];
        [self.btnFR setSelected:(_selectedStrock == 3)];
        [self.btnIM setSelected:(_selectedStrock == 4)];
    }
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    NSString *message = @"";
    if(_selectedSwimmerIndex == -1)
    {
        message = @"Please select a swimmer.";
    }
    
    if(self.meet == nil && _selectedMeetIndex == -1)
    {
        message = @"Please select a meet.";
    }
    
    if(_selectedStrock == -1)
    {
        message = @"Please select a valid stroke.";
    }
    
    if([self.txtDistance.text doubleValue] == 0)
    {
        message = @"Please add a vaild distance.";
    }
    
    if( [MYSLap milisecondsFromLapTime:self.txtSwimTime.text] == 0)
    {
        message = @"Please add a valid time.";
    }
    
    if(message.length > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    MYSProfile *profile = [self.arySwimmers objectAtIndex:_selectedSwimmerIndex];
    
    MYSMeet *meet = nil;
    
    if(self.meet != nil)
    {
        meet = self.meet;
    }
    else
    {
        meet = [self.aryMeets objectAtIndex:_selectedMeetIndex];
    }
    
    float distance = [self.txtDistance.text floatValue];
    int64_t totalTime = [MYSLap milisecondsFromLapTime:self.txtSwimTime.text];
    int64_t reactionTime = [MYSLap milisecondsFromLapTime:self.txtReactionTime.text];

    MYSCourseType courseType = self.sgCourse.selectedSegmentIndex;
    MYSStageType stage = 0;
    if(self.sgStage.selectedSegmentIndex == 0) stage = MYSStageType_Heat;
    else if(self.sgStage.selectedSegmentIndex == 1) stage = MYSStageType_Semi_Final;
    else if(self.sgStage.selectedSegmentIndex == 2) stage = MYSStageType_Final;
    else stage = MYSStageType_Final;
    
    MYSTime *time = nil;
    
    if(self.time)
    {
//        self.time.profile = profile;
//        self.meet = meet;
//        self.time.course = [NSNumber numberWithInt:courseType];
//        self.time.distance = [NSNumber numberWithFloat:distance];
//        self.time.stroke = [NSNumber numberWithInt:_selectedStrock];
//        self.time.time = [NSNumber numberWithLongLong:totalTime];
//        self.time.reactionTime = [NSNumber numberWithLongLong:reactionTime];
//        self.time.stage = [NSNumber numberWithInt:stage];
//        
//        [self.time removeLaps:self.time.laps];
        
        [[MYSDataManager shared] deleteTime:self.time];
    }

    {
        time = [[MYSDataManager shared] insertTimeWithMeet:meet swimmer:profile course:courseType distance:distance stroke:_selectedStrock reactionTime:reactionTime time:totalTime * 1L stage:stage date:[NSDate date]];
        
        time.meet = meet;
        [meet addTimesObject:time];
    }
    
    // Add laps for times
    for (int lap = 0 ; lap < self.aryLapDatas.count ; lap ++)
    {
        NSMutableDictionary *lapData = [self.aryLapDatas objectAtIndex:lap];
        
        UILabel *lblTime = [lapData objectForKey:@"laptime"];
        
        int64_t lapTime = [MYSLap milisecondsFromLapTime:lblTime.text];
        
        MYSLap *lapObject = [[MYSDataManager shared] saveLapWithMiliseconds:lapTime];
        lapObject.lapNumberValue = lap;
        
        [time addLapsObject:lapObject];
        lapObject.time = time;
    }
    
    [[MYSDataManager shared] save];
    
    if(self.time)
    {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:(viewControllers.count - 3)] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onStrock:(id)sender
{
    [self closeKeyboard];
    
    [self hidePopmenu];
    
    if(_selectedMeetIndex != -1)
    {
        MYSMeet *meet = [self.aryMeets objectAtIndex:_selectedMeetIndex];

        MYSCourseType courseType = [meet.courseType intValue];
        
        if(courseType == MYSCourseType_Open)
        {
            return;
        }
    }
    
    UIButton *button = (UIButton *)sender;
    
    if(self.btnFLY == button)
    {
        _selectedStrock = 0;
    }
    else if(self.btnBK == button)
    {
        _selectedStrock = 1;
    }
    else if(self.btnBR == button)
    {
        _selectedStrock = 2;
    }
    else if(self.btnFR == button)
    {
        _selectedStrock = 3;
    }
    else if(self.btnIM == button)
    {
        _selectedStrock = 4;
    }
    
    [self.btnFLY setSelected:(_selectedStrock == 0)];
    [self.btnBK setSelected:(_selectedStrock == 1)];
    [self.btnBR setSelected:(_selectedStrock == 2)];
    [self.btnFR setSelected:(_selectedStrock == 3)];
    [self.btnIM setSelected:(_selectedStrock == 4)];
}

- (void) refreshLapTimes
{
    NSArray *subviews = [self.viewLaps subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    if(self.aryLapDatas == nil)
    {
        self.aryLapDatas = [[NSMutableArray alloc] init];
    }
    [self.aryLapDatas removeAllObjects];
    
    int lapUnit = self.sgCourse.selectedSegmentIndex == 0 ? 25 : 50;
    int distance = [self.txtDistance.text intValue];
    
    int numberOfLap = distance / lapUnit + (distance % lapUnit > 0 ? 1 : 0);
    
    float height = 44.0f, width = CGRectGetWidth(self.viewLaps.frame);
    float fontSize = 14.0f;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        height = 50.0f;
        fontSize = 18.0f;
        
    }
    
    self.viewLaps.frame = CGRectMake(self.viewLaps.frame.origin.x, self.viewLaps.frame.origin.y, width, height * numberOfLap);
    
    NSMutableArray *aryStopwatchLaps = (NSMutableArray *)[self.aryStopwatchLaps sortedArrayUsingComparator:^NSComparisonResult(MYSLapInfo * obj1, MYSLapInfo * obj2) {
        return [[NSNumber numberWithInteger:obj1.lapNumber] compare:[NSNumber numberWithInteger:obj2.lapNumber]];
    }];
    
    int64_t totalTime = 0;
    for (int lap = 0 ; lap < numberOfLap ; lap ++)
    {
        int64_t lapTime = 0;
        if(self.aryStopwatchLaps != nil)
        {
            if(lap < aryStopwatchLaps.count)
            {
                MYSLapInfo *stopwatchLap = [aryStopwatchLaps objectAtIndex:lap];
                
                lapTime = stopwatchLap.lapTime;
            }
        }
        
        totalTime += lapTime;
        
        UILabel *lblLapIndex = [UILabel new];
        
        lblLapIndex.frame = CGRectMake(self.lblHeaderLapNumber.frame.origin.x, lap * height, self.lblHeaderLapNumber.frame.size.width, height);
        lblLapIndex.textAlignment = NSTextAlignmentCenter;
        lblLapIndex.font = [UIFont systemFontOfSize:fontSize];
        lblLapIndex.backgroundColor = [UIColor clearColor];
        lblLapIndex.textColor = [UIColor lightGrayColor];
        lblLapIndex.text = [NSString stringWithFormat:@"%d", lap + 1];
        
        [self.viewLaps addSubview:lblLapIndex];
        lblLapIndex = nil;
        
        UILabel *lblLapTime = [UILabel new];
        lblLapTime.frame = CGRectMake(self.lblHeaderLapTime.frame.origin.x, lap * height, self.lblHeaderLapTime.frame.size.width, height);
        lblLapTime.textAlignment = NSTextAlignmentCenter;
        lblLapTime.font = [UIFont systemFontOfSize:fontSize];
        lblLapTime.backgroundColor = [UIColor clearColor];
        lblLapTime.textColor = [UIColor lightGrayColor];
        lblLapTime.text = @"";
        
        [self.viewLaps addSubview:lblLapTime];
        
        UITextField *txtTotalTime = [[UITextField alloc] initWithFrame:CGRectMake(self.lblHeaderLapTotalTime.frame.origin.x, lap * height, self.lblHeaderLapTotalTime.frame.size.width, height)];
        txtTotalTime.tag = lap + 1;
        txtTotalTime.font = [UIFont systemFontOfSize:fontSize];
        txtTotalTime.textAlignment = NSTextAlignmentCenter;
        txtTotalTime.backgroundColor = [UIColor clearColor];
        txtTotalTime.textColor = [UIColor lightGrayColor];
        txtTotalTime.placeholder = @"Tap to input";
        txtTotalTime.delegate = self;
        
        if(totalTime > 0)
        {
            txtTotalTime.text = [MYSLap getSplitTimeStringFromMiliseconds:totalTime withMinimumFormat:NO];
        }
        
        [self.viewLaps addSubview:txtTotalTime];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:189.0f / 255.0f green:189.0f / 255.0f blue:189.0f / 255.0f alpha:1.0f];
        view.frame = CGRectMake(12, (lap + 1) * height, width - 12, 1);
        
        [self.viewLaps addSubview:view];
        view = nil;
        
        NSMutableDictionary *dicLapData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           txtTotalTime, @"totaltime",
                                           lblLapTime, @"laptime",
                                           nil];
        
        [self.aryLapDatas addObject:dicLapData];
        txtTotalTime = nil;
        lblLapTime = nil;
    }
    
    self.svMain.contentSize = CGSizeMake(CGRectGetWidth(self.svMain.frame), self.viewLaps.frame.origin.y + CGRectGetHeight(self.viewLaps.frame) + 70);
    
    [self updateLapTimes];
}

- (void) updateLapTimes
{
    int64_t preLapTotalTime = 0;
    
    for (NSMutableDictionary *lapData in self.aryLapDatas)
    {
        UITextField *txtLapTotalTime = [lapData objectForKey:@"totaltime"];
        UILabel *lblCalculated = [lapData objectForKey:@"laptime"];
        
        int64_t lapTotalTime = [MYSLap milisecondsFromLapTime:txtLapTotalTime.text];
        
        int64_t lapTime = lapTotalTime - preLapTotalTime;
        
        if(lapTime > 0)
        {
            lblCalculated.text = [MYSLap getSplitTimeStringFromMiliseconds:lapTime withMinimumFormat:NO];
            
            preLapTotalTime = lapTotalTime;
        }
    }
    
    if(preLapTotalTime > 0)
    {
        self.txtSwimTime.text = [MYSLap getSplitTimeStringFromMiliseconds:preLapTotalTime withMinimumFormat:NO];
        self.txtSwimTime.userInteractionEnabled = NO;
    }
    else
    {
        self.txtSwimTime.userInteractionEnabled = YES;
    }
}

- (BOOL)validate
{
    if (!([self.txtDistance.text intValue] > 0))
    {
        [UIAlertView showWithTitle:@"" message:@"Distance must be larger than zero" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        
        return NO;
    }
    
    if (_totalTime <= 2000) {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"Total time is less tham 2 second. Plase check your total time", nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
        return NO;
    }
    
    return YES;
}

- (void) closeKeyboard
{
    [self.txtSwimmerName resignFirstResponder];
    [self.txtMeetTitle resignFirstResponder];
    [self.txtMeetLocation resignFirstResponder];
    [self.txtMeetDate resignFirstResponder];
    
    [self.txtDistance resignFirstResponder];
    [self.txtSwimTime resignFirstResponder];
    [self.txtReactionTime resignFirstResponder];
}

- (void) showPopmenu:(int) menu
{
    [self.svMain bringSubviewToFront:self.viewPopMenu];
    
    self.viewPopMenu.tag = menu;
    self.viewPopMenu.hidden = NO;
    
    [self.tvPopmenu reloadData];
    
    [self.view bringSubviewToFront:self.viewPopMenu];
    
    UITextField *textField = nil;
    
    if(menu == 0) textField = self.txtSwimmerName;
    else if(menu == 1) textField = self.txtMeetTitle;
    
    float pos = textField.frame.origin.x + CGRectGetWidth(textField.frame) - CGRectGetWidth(self.viewPopMenu.frame);
    
    CGRect rtBefor = CGRectMake(pos, textField.frame.origin.y + CGRectGetHeight(textField.frame), CGRectGetWidth(self.viewPopMenu.frame), 0);
    CGRect rtAfter = CGRectMake(pos, textField.frame.origin.y + CGRectGetHeight(textField.frame), CGRectGetWidth(self.viewPopMenu.frame), 200);
    
    self.viewPopMenu.frame = rtBefor;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.viewPopMenu.frame = rtAfter;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hidePopmenu
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.viewPopMenu.frame = CGRectMake(self.viewPopMenu.frame.origin.x, self.viewPopMenu.frame.origin.y, CGRectGetWidth(self.viewPopMenu.frame), 0);
        
    } completion:^(BOOL finished) {
        
        self.viewPopMenu.hidden = YES;
        
    }];
}

- (void) gotoNewMeet
{
    MYSNewMeetViewController *meetDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSNewMeetViewController"];
    meetDetailsVC.delegate = self;
    meetDetailsVC.createPassedMeet = YES;
    
    [self.navigationController pushViewController:meetDetailsVC animated:YES];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if(self.viewPopMenu.tag == 0)
    {
        return self.arySwimmers.count;
    }
    else if(self.viewPopMenu.tag == 1)
    {
        return self.aryMeets.count + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //str1 = [[NSString alloc]initWithFormat:@"%d",indexPath.row];
    //
    //	[arr addObject:str1];
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(self.viewPopMenu.tag == 0)
    {
        MYSProfile *profile = [self.arySwimmers objectAtIndex:indexPath.row];
        
        cell.textLabel.text = profile.name;
    }
    else if(self.viewPopMenu.tag == 1)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"New Meet";
        }
        else
        {
            MYSMeet *meet = [self.aryMeets objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = meet.title;
            
            if([meet.startDate compare:[NSDate date]] == NSOrderedDescending )
            {
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.textLabel.textColor = [UIColor blackColor];
            }
        }
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    //cell.textLabel.textColor =  [UIColor colorWithRed:151.0f / 255.0f green:153.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.viewPopMenu.tag == 0)
    {
        _selectedSwimmerIndex = (int)indexPath.row;
    }
    else if(self.viewPopMenu.tag == 1)
    {
        if(indexPath.row == 0)
        {
            [self gotoNewMeet];
        }
        else
        {
            MYSMeet *meet = [self.aryMeets objectAtIndex:(indexPath.row - 1)];
            
            if([meet.startDate compare:[NSDate date]] == NSOrderedDescending )
            {
                return;
            }
            
            _selectedMeetIndex = (int)indexPath.row - 1;
        }
    }
    
    [self hidePopmenu];
    
    [self updateUI];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtSwimmerName)
    {
        [self showPopmenu:0];
        [self closeKeyboard];
        
        return NO;
    }
    else if(textField == self.txtMeetTitle)
    {
        if(self.meet != nil)
            return NO;
        
        [self showPopmenu:1];
        [self closeKeyboard];
        
        return NO;
    }
    else if(textField == self.txtSwimTime || textField == self.txtReactionTime || textField.tag >= 1)
    {
        [self hidePopmenu];
        
        if(textField == self.txtSwimTime)
        {
            _editingTimeIndex = -1;
        }
        else if(textField == self.txtReactionTime)
        {
            _editingTimeIndex = 0;
        }
        else
        {
            _editingTimeIndex = (int)textField.tag;
        }
        
        [self closeKeyboard];
        
        [self performSegueWithIdentifier:@"addtime" sender:textField.text];
        
        return NO;
    }
    else if(textField == self.txtDistance)
    {
        
//        [self closeKeyboard];
//        [self hidePopmenu];
//        [self performSegueWithIdentifier:@"selectdistance" sender:textField.text];
        
        return NO;
    }
    else
    {
        [self hidePopmenu];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtDistance)
    {
        [self refreshLapTimes];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self closeKeyboard];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"addtime" sender:@""];
    }
}

#pragma mark MYSNewMeetViewControllerDelegate

- (void) addedNewMeet:(MYSMeet *)meet
{
    self.meet = meet;
}

#pragma mark MYSSelectDistanceViewControllerDelegate

- (void) selectDistance:(double)distance
{
    if(distance == 33.3)
        self.txtDistance.text = [NSString stringWithFormat:@"%.1f", distance];
    else
        self.txtDistance.text = [NSString stringWithFormat:@"%.0f", distance];
    
    [self refreshLapTimes];
}

@end
