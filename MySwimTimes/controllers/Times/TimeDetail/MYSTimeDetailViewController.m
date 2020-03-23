//
//  MYSTimeDetailViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/4/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSTimeDetailViewController.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSNewManualTimeViewController.h"

#import "MYSLapChartView.h"
#import "MYSShareResultsVC.h"

@interface MYSTimeDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic, assign) IBOutlet UIScrollView *svMain;

@property (nonatomic, assign) IBOutlet UILabel *lblMeetName;
@property (nonatomic, assign) IBOutlet UILabel *lblLocation;
@property (nonatomic, assign) IBOutlet UILabel *lblDate;
@property (nonatomic, assign) IBOutlet UILabel *lblCourseType;

@property (nonatomic, assign) IBOutlet UIButton *btnSelectStrokeAndDis;

@property (nonatomic, assign) IBOutlet UILabel *lblTime;
@property (nonatomic, assign) IBOutlet UILabel *lblPB;

@property (nonatomic, assign) IBOutlet UILabel *lblReactionTime;
@property (nonatomic, assign) IBOutlet UILabel *lblAverageLapTime;
@property (nonatomic, assign) IBOutlet UILabel *lblAverageSpeed;
@property (nonatomic, assign) IBOutlet UILabel *lblPersonalBestTime;
@property (nonatomic, assign) IBOutlet UILabel *lblGoalTime;

@property (nonatomic, assign) IBOutlet UIView *viewLapHeader;

@property (nonatomic, retain) MYSLapChartView *chartView;

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

- (IBAction)shareBtnAction:(id)sender;


@end

@implementation MYSTimeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"edittime"])
    {
        MYSNewManualTimeViewController *vc = segue.destinationViewController;
        vc.time = sender;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadMainDatas];
}

- (void) initView
{
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 70.0f);
    
    [self.svMain addSubview:self.swimmerView];
    
    NSMutableAttributedString *attrStr = (NSMutableAttributedString *)[self.btnSelectStrokeAndDis attributedTitleForState:UIControlStateNormal];
    [attrStr enumerateAttributesInRange:NSMakeRange(0, [attrStr length])
                                options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                             usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop)
     {
         NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
         [mutableAttributes removeObjectForKey:NSUnderlineStyleAttributeName];
         [attrStr setAttributes:mutableAttributes range:range];
     }];
}

- (void) loadMainDatas
{
    if(self.time == nil)
        return;
    
    self.swimmerView.ivProfile.image = [UIImage imageWithData:self.time.profile.image];
    
    self.swimmerView.lblUserName.text = self.time.profile.name;
    self.swimmerView.lblClub.text = self.time.profile.nameSwimClub;
    self.swimmerView.lblLocation.text = [NSString stringWithFormat:@"%@, %@", self.time.profile.city, self.time.profile.country];
    self.swimmerView.lblYear.text = [NSString stringWithFormat:@"%.0f years",[MethodHelper countYearOld2:self.time.profile.birthday]];
    self.swimmerView.ivDeclour.hidden = YES;
    
    self.lblMeetName.text = self.time.meet.title ;
    self.lblLocation.text = [NSString stringWithFormat:@"%@, %@", self.time.meet.location, self.time.meet.city];
    self.lblDate.text = [MethodHelper convertMeetDate:self.time.meet.startDate endDate:self.time.meet.endDate];
    
    self.lblCourseType.text = [MYSDataManager getCourseTypeStringFromType: [self.time.meet.courseType integerValue]];
    
    NSString *strokeImageName = @"";
    NSString *strokeName = @"";
    
    MYSStrokeTypes strokeType = [self.time.stroke intValue];
    
    if(strokeType == 0)
    {
        strokeImageName = @"icon-FLY-tap";
        strokeName = @"Butterfly";
        
    }
    else if(strokeType == 1)
    {
        strokeImageName = @"icon-BK-tap";
        strokeName = @"Backstroke";
    }
    else if(strokeType == 2)
    {
        strokeImageName = @"icon-BR-tap";
        strokeName = @"Breaststroke";
    }
    else if(strokeType == 3)
    {
        strokeImageName = @"icon-FR-tap";
        strokeName = @"Freestyle";
    }
    else if(strokeType == 4)
    {
        strokeImageName = @"icon-IM-tap";
        strokeName = @"Individual medley";
    }
    
    [self.btnSelectStrokeAndDis setImage: [UIImage imageNamed:strokeImageName] forState:UIControlStateNormal];
    [self.btnSelectStrokeAndDis setTitle:[NSString stringWithFormat:@"%.0fm %@", [self.time.distance floatValue], strokeName] forState:UIControlStateNormal];
    
    self.lblTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[self.time.time longLongValue] withMinimumFormat:YES];
    
    MYSCourseType courseType = [self.time.course intValue];
    
    MYSTime *pbTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:self.time.profile withCourse:courseType distance:[self.time.distance floatValue ] stroke:strokeType];
    
    if(pbTime)
    {
        MYSTimeStatus timeState = [pbTime.status intValue];
        
        if(timeState == MYSTimeStatusLatestPersionalBest)
        {
            self.lblPersonalBestTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[pbTime.time longLongValue] withMinimumFormat:YES];
        }
        else
        {
            self.lblPersonalBestTime.text = @"-";
        }
        
        self.lblPB.hidden = !([pbTime.time longLongValue] == [self.time.time longLongValue]);
    }
    else
    {
        self.lblPB.hidden = YES;
        self.lblPersonalBestTime.text = @"-";
    }
    
    [self loadTimes];
    [self loadLapTimes];
}

- (void) loadTimes
{
    int64_t reactionTime = [self.time.reactionTime longLongValue];
    
    if(reactionTime == 0)
        self.lblReactionTime.text = @"-";
    else
        self.lblReactionTime.text = [MYSLap getSplitTimeStringFromMiliseconds:reactionTime withMinimumFormat:YES];
    
    //Logic have been UPDATED for
    //Average lap time
    //Average Speed
    
    /*
    NSMutableArray *laps = (NSMutableArray *)[self.time.laps allObjects];
    
    if(laps == nil || laps.count == 0)
    {
        self.lblAverageLapTime.text = @"-";
    }
    else
    {
        int64_t laptimes = 0;
        for (MYSLap *lap in laps)
        {
            laptimes += lap.splitTimeValue;
        }
        
        int64_t averageLapTime = laptimes / laps.count;
        
        if(averageLapTime == 0)
            self.lblAverageLapTime.text = @"-";
        else
            self.lblAverageLapTime.text = [MYSLap getSplitTimeStringFromMiliseconds:averageLapTime withMinimumFormat:YES];
    }
     */
    
    
    /*
    float distance = [self.time.distance floatValue] * 1000.0f;
    int64_t takenTime = 3600 * [self.time.time longLongValue] / 1000;
    
    self.lblAverageSpeed.text = [NSString stringWithFormat:@"%.2f km/hour", distance / takenTime];
     */
    
    float distance = [self.time.distance floatValue] / 1000.0f;
    float takenTime = [self.time.time longLongValue] / (1000.00 * 3600.00);
    
    if (takenTime != 0.0)
        self.lblAverageSpeed.text = [NSString stringWithFormat:@"%.2f km/hour", distance / takenTime];
    else
        self.lblAverageSpeed.text = @"0.00 km/hour";
    
    MYSCourseType courseType = [self.time.course intValue];
    
    MYSGoalTime *goalTime = [[MYSDataManager shared] getGoalTimeOfProfile:self.time.profile withCourse:courseType stroke:[self.time.stroke intValue] distance:[self.time.distance floatValue]];
    
    if(goalTime == nil)
        self.lblGoalTime.text = @"-";
    else
        self.lblGoalTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[goalTime.time longLongValue] withMinimumFormat:YES];
    
    
    self.lblAverageLapTime.text = @"-";
    float distanceToBeSplit = ((courseType == MYSCourseType_Short) ? 25.0 : ((courseType == MYSCourseType_Long) ? 50.0 : 0.0));
    if (distanceToBeSplit > 0) {
        
        int64_t numberOfLaps = ([self.time.distance floatValue] / distanceToBeSplit);
        if (numberOfLaps > 0) {
            int64_t averageLapTime = [self.time.time longLongValue] / numberOfLaps;
            if(averageLapTime != 0)
                self.lblAverageLapTime.text = [MYSLap getSplitTimeStringFromMiliseconds:averageLapTime withMinimumFormat:YES];
        }
    }
}

- (void) loadLapTimes
{
    MYSCourseType courseType = [self.time.course intValue];
    
    int aLapDistance = courseType == MYSCourseType_Short ? 25 : 50;
    
    NSMutableArray *laps = (NSMutableArray *)[self.time.laps allObjects];
    
    laps = (NSMutableArray *)[laps sortedArrayUsingComparator:^NSComparisonResult(MYSLap * obj1, MYSLap * obj2) {
        return [obj1.lapNumber compare:obj2.lapNumber];
    }];
    
    int index = 0; int height = 24; int64_t totalTime = 0;float pos = self.viewLapHeader.frame.origin.y + CGRectGetHeight(self.viewLapHeader.frame);
    for (MYSLap *lap in laps)
    {
//        int lapNo = lap.lapNumberValue;
        
        totalTime += lap.splitTimeValue;
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, pos + height * index, CGRectGetWidth(self.svMain.frame), height);
        
        UILabel *lblIndex = [UILabel new];
        lblIndex.frame = CGRectMake(10, 0, 40, height);
        lblIndex.textColor = [UIColor blackColor];
        lblIndex.textAlignment = NSTextAlignmentCenter;
        lblIndex.font = [UIFont systemFontOfSize:12.0f];
        lblIndex.text = [NSString stringWithFormat:@"%d", index + 1];
        
        [view addSubview:lblIndex];
        lblIndex = nil;
        
        UILabel *lblDis = [UILabel new];
        lblDis.frame = CGRectMake(60, 0, 50, height);
        lblDis.textColor = [UIColor blackColor];
        lblDis.textAlignment = NSTextAlignmentLeft;
        lblDis.font = [UIFont systemFontOfSize:12.0f];
        lblDis.text = [NSString stringWithFormat:@"%d m", (index + 1) * aLapDistance];
        
        [view addSubview:lblDis];
        lblDis = nil;
        
        UILabel *lblTime = [UILabel new];
        if (IS_IPHONE_6) {
            lblTime.frame = CGRectMake(160, 0, 80, height);
        }else if (IS_IPHONE_6Plus){
            lblTime.frame = CGRectMake(180, 0, 80, height);
        }else if (IS_IPHONE){
            lblTime.frame = CGRectMake(130, 0, 80, height);
        }else {
        lblTime.frame = CGRectMake(380, 0, 80, height);
        }
        lblTime.autoresizingMask = (UIViewAutoresizingNone);
        lblTime.textColor = [UIColor blackColor];
        lblTime.textAlignment = NSTextAlignmentCenter;
        lblTime.font = [UIFont systemFontOfSize:12.0f];
        lblTime.text = [MYSLap getSplitTimeStringFromMiliseconds:lap.splitTimeValue withMinimumFormat:YES];
        
        [view addSubview:lblTime];
        lblTime = nil;
        
        UILabel *lblTotalTime = [UILabel new];
        if (IS_IPHONE_6) {
            lblTotalTime.frame = CGRectMake(260, 0, 80, height);
        } else if (IS_IPHONE_6Plus){
             lblTotalTime.frame = CGRectMake(290, 0, 80, height);
        } else if (IS_IPHONE){
            lblTotalTime.frame = CGRectMake(210, 0, 80, height);
        } else{
        lblTotalTime.frame = CGRectMake(595, 0, 80, height);
        }
        lblTime.autoresizingMask = (UIViewAutoresizingNone);
        lblTotalTime.textColor = [UIColor blackColor];
        lblTotalTime.textAlignment = NSTextAlignmentCenter;
        lblTotalTime.font = [UIFont systemFontOfSize:12.0f];
        lblTotalTime.text = [MYSLap getSplitTimeStringFromMiliseconds:totalTime withMinimumFormat:YES];
        
        [view addSubview:lblTotalTime];
        lblTotalTime = nil;
        
        UIView *line = [UIView new];
        line.frame = CGRectMake(0, height - 1, CGRectGetWidth(view.frame), 1);
        line.backgroundColor = [UIColor colorWithRed:112.0f / 255.0f green:182.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
        
        [view addSubview:line];
        line = nil;
        
        [self.svMain addSubview:view];
        view = nil;
        
        index ++;
    }
    
    pos += (height * laps.count + 20);
    
    UIView *viewGraph = [UIView new];
    viewGraph.frame = CGRectMake(0, pos, CGRectGetWidth(self.svMain.frame) - 10, 300);
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"Lap Splits";
    lblTitle.center = CGPointMake(CGRectGetWidth(viewGraph.frame) / 2, 8);
    
    [viewGraph addSubview:lblTitle];
    lblTitle = nil;
    
    self.chartView = [[MYSLapChartView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(viewGraph.frame), CGRectGetHeight(viewGraph.frame) - 40)];
    [self.chartView setTime:self.time];
    
    [viewGraph addSubview:self.chartView];
    
    UILabel *lblBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
    lblBottom.backgroundColor = [UIColor clearColor];
    lblBottom.textColor = [UIColor blackColor];
    lblBottom.font = [UIFont boldSystemFontOfSize:14.0f];
    lblBottom.textAlignment = NSTextAlignmentCenter;
    lblBottom.text = @"Lap";
    lblBottom.center = CGPointMake(CGRectGetWidth(viewGraph.frame) / 2, CGRectGetHeight(viewGraph.frame) - 8);
    
    [viewGraph addSubview:lblBottom];
    lblBottom = nil;
    
    [self.svMain addSubview:viewGraph];
    
    pos += CGRectGetHeight(viewGraph.frame) + 20;
    
    self.svMain.contentSize = CGSizeMake(CGRectGetWidth(self.svMain.frame), pos);
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEdit:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Time", @"Delete Time", nil];
    
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

- (NSMutableArray *)createDatasourceForGraphFromTime:(MYSTime *)time;
{
    NSMutableArray *data = [NSMutableArray array];
    for (MYSLap *lap in time.laps) {
        
        [data addObject:@(lap.splitTimeValue / 1000.0f)];
    }
    return data;
}

- (void) editTime
{
    [self performSegueWithIdentifier:@"edittime" sender:self.time];
}

- (void) deleteTime
{
    BOOL result = [[MYSDataManager shared] deleteTime:self.time];
    
    if(result)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Failed to delete this time. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        alertView = nil;
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self editTime];
    }
    else if(buttonIndex == 1)
    {
        [self deleteTime];
    }
}

#pragma mark - Button Action Methods

- (IBAction)shareBtnAction:(UIButton *)sender {
    
    if ([[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Would you like to send this result to another swimsync user?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }
    else {
        [UIAlertView alertViewWithTitle:@"Alert" message:@"Would you like to purchase the sharing function?" cancelButtonTitle:@"No" otherButtonTitles:[NSArray arrayWithObject:@"Yes"] onDismiss:^(int buttonIndex) {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MYSSettings"] animated:YES];
        } onCancel:^{
        }];
    }
}

#pragma mark - AlertView Delegate Method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MYSShareResultsVC *shareResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSShareResultsVCID"];
        shareResultVC.string_resultData = [self getReportStrtoShare];
        [self.navigationController pushViewController:shareResultVC animated:YES];
    }
}

-(NSString*)getReportStrtoShare {
    
    NSMutableDictionary *reportdata = [NSMutableDictionary dictionary];
    [reportdata setValue:[[[MYSAppData sharedInstance] appInstructor] userName] forKey:@"userName"];
    [reportdata setValue:self.time.profile.name forKey:@"swimmerName"];
    [reportdata setValue:@"4" forKey:@"reportType"];
    [reportdata setValue:self.time.meet.title forKey:@"reportTitle"];
    [reportdata setValue:self.btnSelectStrokeAndDis.titleLabel.text forKey:@"reportSubTitle"];
    
    NSString *imageStr = [UIImagePNGRepresentation([UIImage imageWithData:self.time.profile.image]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *profileInfo = [NSMutableDictionary dictionary];
    [profileInfo setValue:self.time.profile.name forKey:@"swimmerName"];
    [profileInfo setValue:[NSString stringWithFormat:@"%lld",[self.time.profile.userid longLongValue]] forKey:@"swimmerID"];
    [profileInfo setValue:((imageStr.length > 0) ? imageStr : @"") forKey:@"profileImage"];
    [profileInfo setValue:[NSString stringWithFormat:@"%d",[self.time.profile.gender shortValue]] forKey:@"gender"];
    [profileInfo setValue:[MethodHelper convertFullMonth:self.time.profile.birthday] forKey:@"birthday"];
    [profileInfo setValue:(self.time.profile.nameSwimClub ? self.time.profile.nameSwimClub : @"") forKey:@"club"];
    [profileInfo setValue:(self.time.profile.city ? self.time.profile.city : @"") forKey:@"city"];
    [profileInfo setValue:(self.time.profile.country ? self.time.profile.country : @"") forKey:@"country"];
    [reportdata setValue:profileInfo forKey:@"swimmerInfo"];
    
    NSMutableDictionary *timeData = [NSMutableDictionary dictionary];
    [timeData setValue:[NSString stringWithFormat:@"%d",[self.time.course intValue]] forKey:@"course"];
    [timeData setValue:[NSString stringWithFormat:@"%f",[self.time.date timeIntervalSince1970]] forKey:@"date"];
    [timeData setValue:[NSString stringWithFormat:@"%f",[self.time.distance floatValue]] forKey:@"distance"];
    [timeData setValue:[NSString stringWithFormat:@"%lld",[self.time.reactionTime longLongValue]] forKey:@"reactionTime"];
    [timeData setValue:[NSString stringWithFormat:@"%d",[self.time.stage shortValue]] forKey:@"stage"];
    [timeData setValue:[NSString stringWithFormat:@"%d",[self.time.status intValue]] forKey:@"status"];
    [timeData setValue:[NSString stringWithFormat:@"%d",[self.time.stroke intValue]] forKey:@"stroke"];
    [timeData setValue:[NSString stringWithFormat:@"%lld",[self.time.time longLongValue]] forKey:@"time"];
    [reportdata setValue:timeData forKey:@"timeInfo"];
    
    NSMutableArray *lapInfo = [NSMutableArray array];
    for (MYSLap *lapObj in [self.time.laps allObjects]) {
        NSMutableDictionary *lapData = [NSMutableDictionary dictionary];
        [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.id longLongValue]] forKey:@"id"];
        [lapData setValue:[NSString stringWithFormat:@"%lld",lapObj.idValue] forKey:@"idValue"];
        [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.lapNumber longLongValue]] forKey:@"lapNumber"];
        [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.splitTime longLongValue]] forKey:@"splitTime"];
        [lapInfo addObject:lapData];
    }
    [reportdata setValue:lapInfo forKey:@"lapInfo"];
    
    if (self.time.meet)
        [reportdata setValue:[self getMeetData:self.time.meet] forKey:@"meetInfo"];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:reportdata options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

-(NSMutableDictionary*)getMeetData:(MYSMeet*)meet {
    
    NSMutableDictionary *meetdata = [NSMutableDictionary dictionary];
    [meetdata setValue:[NSString stringWithFormat:@"%d",[meet.courseType shortValue]] forKey:@"courseType"];
    [meetdata setValue:(meet.city ? meet.city : @"") forKey:@"city"];
    [meetdata setValue:[NSString stringWithFormat:@"%f",[meet.endDate timeIntervalSince1970]] forKey:@"endDate"];
    [meetdata setValue:[NSString stringWithFormat:@"%f",[meet.enteredDate timeIntervalSince1970]] forKey:@"enteredDate"];
    [meetdata setValue:[NSString stringWithFormat:@"%f",[meet.startDate timeIntervalSince1970]] forKey:@"startDate"];
    [meetdata setValue:[NSString stringWithFormat:@"%lld",[meet.id longLongValue]] forKey:@"id"];
    [meetdata setValue:[NSString stringWithFormat:@"%lld",meet.idValue] forKey:@"idValue"];
    [meetdata setValue:(meet.location ? meet.location : @"") forKey:@"location"];
    [meetdata setValue:(meet.title ? meet.title : @"") forKey:@"title"];

//    NSMutableArray *array_qualify = [NSMutableArray array];
//    for (MYSQualifyTime *timeItem in [meet.qualifytimes allObjects]) {
//
//        NSMutableDictionary *timeData = [NSMutableDictionary dictionary];
//        [timeData setValue:[NSString stringWithFormat:@"%d",[timeItem.gender shortValue]] forKey:@"gender"];
//        [timeData setValue:[NSString stringWithFormat:@"%d",[timeItem.id intValue]] forKey:@"id"];
//        [timeData setValue:[NSString stringWithFormat:@"%d",timeItem.idValue] forKey:@"idValue"];
//        [timeData setValue:(timeItem.name ? timeItem.name : @"") forKey:@"name"];
//
//        NSMutableArray *array_event = [NSMutableArray array];
//        for (MYSEvent *eventItem in [timeItem.events allObjects]) {
//
//            NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
//            [eventData setValue:[NSString stringWithFormat:@"%f",[eventItem.distance floatValue]] forKey:@"distance"];
//            [eventData setValue:[NSString stringWithFormat:@"%f",eventItem.distanceValue] forKey:@"distanceValue"];
//            [eventData setValue:[NSString stringWithFormat:@"%lld",[eventItem.id longLongValue]] forKey:@"id"];
//            [eventData setValue:[NSString stringWithFormat:@"%lld",eventItem.idValue] forKey:@"idValue"];
//            [eventData setValue:[NSString stringWithFormat:@"%d",[eventItem.stroke shortValue]] forKey:@"stroke"];
//            [eventData setValue:[NSString stringWithFormat:@"%lld",[eventItem.time longLongValue]] forKey:@"time"];
//
//            [array_event addObject:eventData];
//        }
//
//        [timeData setValue:array_event forKey:@"eventsInfo"];
//        [array_qualify addObject:timeData];
//    }
//    
//    [meetdata setValue:array_qualify forKey:@"qualifyTimesInfo"];

    return meetdata;
}

@end
