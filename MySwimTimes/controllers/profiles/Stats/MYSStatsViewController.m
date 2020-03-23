//
//  MYSStatsViewController.m
//  MySwimTimes
//
//  Created by hanjinghe
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSStatsViewController.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSChooseProfileViewController.h"

#import "MYSReactionChartOptionViewController.h"
#import "MYSProgressChartOptionViewController.h"

#import "MYSSelectStrokeAndDistanceViewController.h"

#import "MYSChartView.h"

#import "MYSTimeDetailViewController.h"


@interface MYSStatsViewController ()<MYSChooseProfileViewControllerDelegate, MYSSelectStrokeAndDistanceViewControllerDelegate, MYSChartViewDelegate>

@property (nonatomic, assign) IBOutlet UIScrollView *svMain;
@property (nonatomic, assign) IBOutlet UIButton *btnSelectStrokeAndDis;

@property (nonatomic, assign) IBOutlet UILabel *lblCourseType;

@property (nonatomic, assign) IBOutlet UILabel *lblPBTimeTile;
@property (nonatomic, assign) IBOutlet UIView *viewPBTimeColor;

@property (nonatomic, assign) IBOutlet UILabel *lblGoalTimeTile;
@property (nonatomic, assign) IBOutlet UIView *viewGoalTimeColor;

@property (nonatomic, assign) IBOutlet UILabel *lblCustomTimeTile;
@property (nonatomic, assign) IBOutlet UIView *viewCustomeTimeColor;

@property (nonatomic, assign) IBOutlet UILabel *lblAnotherSwimmer;
@property (nonatomic, assign) IBOutlet UIView *viewAnotherTimeColor;

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgCourseType;

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

@property (nonatomic, strong) MYSChartView *chartView;

@property (nonatomic, retain) MYSProfile *swimmer;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) int strokeIndex;

@property (nonatomic, assign) MYSCourseType courseType;

@end

@implementation MYSStatsViewController
{

}

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
    
    self.distance = 100;
    self.strokeIndex = 0;
    
    if([MYSDataManager shared].lastSelectedSwimmer)
    {
        self.swimmer = [MYSDataManager shared].lastSelectedSwimmer;
    }
    else
    {
        NSArray *aryAllSwimmer = [[MYSDataManager shared] getAllProfiles];
        
        if(aryAllSwimmer.count > 0)
        {
            self.swimmer = [aryAllSwimmer objectAtIndex:0];
        }
    }
    
    [self _initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"selectswimmer"])
    {
        MYSChooseProfileViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"reactionchartoption"])
    {
        MYSReactionChartOptionViewController *vc = segue.destinationViewController;
        vc.swimmer = self.swimmer;
    }
    else if([segue.identifier isEqualToString:@"progresschartoption"])
    {
        MYSProgressChartOptionViewController *vc = segue.destinationViewController;
        vc.swimmer = self.swimmer;
    }
    else if([segue.identifier isEqualToString:@"distanceAndStroke"])
    {
        MYSSelectStrokeAndDistanceViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.distance = self.distance;
        vc.strokeIndex = self.strokeIndex;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.courseType = [prefs integerForKey:CHART_COURSE];
    
    self.lblCourseType.text = [MYSDataManager getCourseTypeStringFromType:self.courseType];
    
    self.distance = [prefs floatForKey:CHART_DISTANCE];
    self.strokeIndex = (int)[prefs integerForKey:CHART_STROKE];
    
    [self loadAllDatas];
}

- (void) _initView
{
//    self.viewPBTimeColor.layer.borderColor = [UIColor colorWithRed:91.0f / 255.0f green:146.0f / 255.0f blue:196.0f / 255.0f alpha:1.0].CGColor;
//    self.viewPBTimeColor.layer.borderWidth = 2;
//    
//    self.viewGoalTimeColor.layer.borderColor = [UIColor colorWithRed:91.0f / 255.0f green:146.0f / 255.0f blue:196.0f / 255.0f alpha:1.0].CGColor;
//    self.viewGoalTimeColor.layer.borderWidth = 2;
//    
//    self.viewAnotherTimeColor.layer.borderColor = [UIColor colorWithRed:91.0f / 255.0f green:146.0f / 255.0f blue:196.0f / 255.0f alpha:1.0].CGColor;
//    self.viewAnotherTimeColor.layer.borderWidth = 2;
//    
//    self.viewCustomeTimeColor.layer.borderColor = [UIColor colorWithRed:91.0f / 255.0f green:146.0f / 255.0f blue:196.0f / 255.0f alpha:1.0].CGColor;
//    self.viewCustomeTimeColor.layer.borderWidth = 2;
    
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 70.0f);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwimmerView:)];
    [self.swimmerView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self.svMain addSubview:self.swimmerView];
    
    CGRect rect = CGRectMake(10, 180, CGRectGetWidth(self.view.frame) - 30, 300.0f);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(20, 250, CGRectGetWidth(self.view.frame) - 50, 600.0f);
    }
    
    MYSChartView *chartView = [[MYSChartView alloc] initWithFrame:rect];
    
    [self.svMain addSubview:chartView];
    self.chartView = chartView;
    [self.chartView _initChart];
    self.chartView.clipsToBounds = YES;
    self.chartView.delegate = self;
    
    self.svMain.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.chartView.frame.origin.y + CGRectGetHeight(self.chartView.frame));
    
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

- (void) tapSwimmerView:(UITapGestureRecognizer *)tapGesture
{
    MYSChooseProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSChooseProfileViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOption:(id)sender
{
//    if(self.sgmSwitchGraph.selectedSegmentIndex == 0)
//    {
//        [self performSegueWithIdentifier:@"reactionchartoption" sender:nil];
//    }
//    else
    {
        [self performSegueWithIdentifier:@"progresschartoption" sender:nil];
    }
}

- (IBAction)onSelectStrokeAndDistance:(id)sender
{
    return ;
    
    [self performSegueWithIdentifier:@"distanceAndStroke" sender:nil];
}

- (IBAction)onChangeCourseType:(id)sender
{
    [self loadChart];
}

- (void) loadAllDatas
{
    [self loadSelectedSwimmerData];
    [self loadCurrentDistanceAndStroke];
    
    [self loadChart];
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

- (void) loadCurrentDistanceAndStroke
{
    NSString *strokeImageName = @"";
    NSString *strokeName = @"";
    if(self.strokeIndex == 0)
    {
        strokeImageName = @"icon-FLY-tap";
        strokeName = @"Butterfly";
        
    }
    else if(self.strokeIndex == 1)
    {
        strokeImageName = @"icon-BK-tap";
        strokeName = @"Backstroke";
    }
    else if(self.strokeIndex == 2)
    {
        strokeImageName = @"icon-BR-tap";
        strokeName = @"Breaststroke";
    }
    else if(self.strokeIndex == 3)
    {
        strokeImageName = @"icon-FR-tap";
        strokeName = @"Freestyle";
    }
    else if(self.strokeIndex == 4)
    {
        strokeImageName = @"icon-IM-tap";
        strokeName = @"Individual medley";
    }
    
    [self.btnSelectStrokeAndDis setImage: [UIImage imageNamed:strokeImageName] forState:UIControlStateNormal];
    
    [self.btnSelectStrokeAndDis setTitle:[NSString stringWithFormat:@"%.0fm %@", self.distance, strokeName] forState:UIControlStateNormal];
}

- (void) loadChart
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int64_t pbTime = [self getPBTime:self.swimmer];
    int64_t goalTime = [self getGoalTime];
    
    int64_t anotherPbTime = -1;
    
    int64_t customTime = [[prefs objectForKey:CHART_CUSTOM_TIME] longLongValue];
    
    int numberOfTimes = (int)[prefs integerForKey:CHART_NUMER_OF_TIMES];
    
    NSMutableArray *aryTimes = [self getChartTimes:self.swimmer];
    
    int64_t min = [self getShowableMinTime:aryTimes pb:pbTime time:goalTime time:customTime];
    int64_t max = [self getShowableMaxTime:aryTimes pb:pbTime time:goalTime time:customTime];
    
    BOOL showAnotherSwimmer = [prefs boolForKey:CHART_ANOTHER_SWIMMER];
    
    NSMutableArray *aryAnotherSwimmerTimes = nil; MYSProfile *anotherSwimmer = nil;
//    if(showAnotherSwimmer)
    {
        int64_t anotherSwimmerId = [[prefs objectForKey:CHART_ANOTHER_SWIMMER_ID] longLongValue];
        
        if(anotherSwimmerId != -1)
        {
            anotherSwimmer = [[MYSDataManager shared] getProfileWithId:[NSString stringWithFormat:@"%lld", anotherSwimmerId]];
            
            anotherPbTime = [self getPBTime:anotherSwimmer];
            
            aryAnotherSwimmerTimes = [self getChartTimes:anotherSwimmer];
            
            int64_t min1 = [self getShowableMinTime:aryAnotherSwimmerTimes pb:anotherPbTime time:goalTime time:customTime];
            int64_t max1 = [self getShowableMaxTime:aryAnotherSwimmerTimes pb:anotherPbTime time:goalTime time:customTime];
            
            min = MIN(min, min1);
            max = MAX(max, max1);
        }
    }
    
    //if(max == 0) max = 10000;
    //if(min == max) min = 0;
    
    min = (min / 1000) * 1000;
    max = ((max / 1000) + 1) * 1000;
    
    int64_t temp = (max - min) / 6000;
    max = min + 6 * (temp + 1) * 1000;
    
    [self.chartView setYAxisLabelWithMin:min max:max];
    [self.chartView setXAxisLabelWithMaxNumber:numberOfTimes];
    
    [self.chartView setChartTimes:[self getFinalChartDatas:aryTimes min:min max:max]];
    
    if(showAnotherSwimmer && aryAnotherSwimmerTimes)
    {
        self.viewAnotherTimeColor.hidden = NO;
        self.lblAnotherSwimmer.hidden = NO;
        
        self.lblAnotherSwimmer.text = anotherSwimmer.name;
        
        [self.chartView setAnotherSwimmerChartTimes:[self getFinalChartDatas:aryAnotherSwimmerTimes min:min max:max] name:anotherSwimmer.name];
    }
    else
    {
        self.viewAnotherTimeColor.hidden = YES;
        self.lblAnotherSwimmer.hidden = YES;
    }
    
    BOOL showPB = [prefs boolForKey:CHART_SHOW_PB];
    
    if(showPB && pbTime != -1)
    {
        self.lblPBTimeTile.hidden = NO;
        self.viewPBTimeColor.hidden = NO;
        
        [self.chartView setPBTime:pbTime color:[UIColor colorWithRed:255.0f / 255.0f green:34.0f / 255.0f blue:0 alpha:1.0f]];
    }
    else
    {
        [self.chartView hidePBTime];
        
        self.lblPBTimeTile.hidden = YES;
        self.viewPBTimeColor.hidden = YES;
    }
    
    BOOL showGoal = [prefs boolForKey:CHART_SHOW_GOAL];

    if(showGoal && goalTime != -1)
    {
        self.lblGoalTimeTile.hidden = NO;
        self.viewGoalTimeColor.hidden = NO;
        
        [self.chartView setGoalTime:goalTime color:[UIColor colorWithRed:0.0f / 255.0f green:183.0f / 255.0f blue:0 alpha:1.0f]];
    }
    else
    {
        [self.chartView hideGoalTime];
        
        self.lblGoalTimeTile.hidden = YES;
        self.viewGoalTimeColor.hidden = YES;
    }
    
    BOOL showCustom = [prefs boolForKey:CHART_SHOW_CUSTOM];
    
    if(showCustom)
    {
        [self.chartView setCustomTime:customTime color:[UIColor colorWithRed:0.0f / 255.0f green:33.0f / 255.0f blue:1.0f alpha:1.0f]];
        
        self.lblCustomTimeTile.text = [prefs objectForKey:CHART_CUSTOM_TITLE];
        
        self.lblCustomTimeTile.hidden = NO;
        self.viewCustomeTimeColor.hidden = NO;
    }
    else
    {
        [self.chartView hideCustomTime];
        
        self.lblCustomTimeTile.hidden = YES;
        self.viewCustomeTimeColor.hidden = YES;
    }
    
    BOOL showAnotherPBTime = [[prefs objectForKey:CHART_SHOW_PB_OTHER] boolValue];
    
    if(showAnotherPBTime)
    {
        if(anotherPbTime != -1)
        {
            [self.chartView setAnotherPBTime:anotherPbTime color:[UIColor lightGrayColor]];
        }
    }
    else
    {
        [self.chartView hideAnotherPBTime];
    }
}

- (NSMutableArray *) getFinalChartDatas:(NSMutableArray *)aryTimes min:(int64_t)min max:(int64_t)max
{
    NSMutableArray *aryFinalChartDatas = [[NSMutableArray alloc] init];
    
    for (int n = 0 ; n < aryTimes.count ; n ++) {
        
        int64_t time = [[aryTimes objectAtIndex:n] longLongValue];
        
        float value = (float)((time - min)) / (float)((max - min));
        
        [aryFinalChartDatas addObject:[NSNumber numberWithFloat:value]];
    }
    
    return aryFinalChartDatas;
}

- (int64_t) getGoalTime
{
    NSArray *times = [self.swimmer.goaltimeSet allObjects];
    
    for (MYSGoalTime *time in times)
    {
        int distance = (int)[time.distance floatValue];
        MYSStrokeTypes stroke = [time.stroke intValue];
        MYSCourseType courseType = [time.courseType intValue];
        
        if((int)self.distance == distance && stroke == self.strokeIndex && courseType == self.courseType)
        {
            return [time.time longLongValue];
        }
    }
    
    return -1;
}

- (int64_t) getPBTime:(MYSProfile *)swimmer
{
    if(swimmer == nil) return -1;
    
    MYSTime *pbTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:swimmer withCourse:self.courseType distance:self.distance stroke:self.strokeIndex];
    
    if(pbTime)
    {
        return [pbTime.time longLongValue];
    }

    return -1;
}

- (NSMutableArray *) getChartTimes:(MYSProfile *)swimmer
{
    NSMutableArray *aryChartTimes = [[NSMutableArray alloc] init];
    
    if(swimmer == nil) return aryChartTimes;
    
    NSMutableArray *aryAllTimes = [self getAllTimes:swimmer];
    
    for (int n = 0 ; n < aryAllTimes.count ; n ++)
    {
        MYSTime *time = [aryAllTimes objectAtIndex:n];
        
        [aryChartTimes addObject:[NSNumber numberWithLongLong:[time.time longLongValue]]];
    }
    
    return aryChartTimes;
}

- (NSMutableArray *) getAllTimes:(MYSProfile *)swimmer
{
    NSArray *times = [swimmer.time allObjects];
    
    MYSCourseType courseType = self.courseType;
    
    NSMutableArray *aryTimes = [[NSMutableArray alloc] init];
    for (MYSTime *time in times) {
        
        if([time.stroke intValue] == self.strokeIndex &&
           [time.distance intValue] == self.distance &&
           [time.meet.courseType intValue] == courseType)
        {
            [aryTimes addObject:time];
        }
        
    }
    
    aryTimes = (NSMutableArray *)[aryTimes sortedArrayUsingComparator:^NSComparisonResult(MYSTime * obj1, MYSTime * obj2) {
        return [obj1.meet.startDate compare:obj2.meet.startDate];
    }];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int numberOfTimes = (int)[prefs integerForKey:CHART_NUMER_OF_TIMES];
    
    int count = (int)MIN(aryTimes.count, numberOfTimes);
    
    NSMutableArray *aryChartTimes = [[NSMutableArray alloc] init];
    for (int n = (int)aryTimes.count - count ; n < aryTimes.count ; n ++)
    {
        MYSTime *time = [aryTimes objectAtIndex:n];
        
        [aryChartTimes addObject:time];
    }
    
    return aryTimes;
}

- (int64_t) getShowableMinTime:(NSMutableArray *)aryTimes pb:(int64_t)pbTime time:(int64_t)goalTime time:(int64_t)customTime
{
    int64_t min = 0;
    
    if(goalTime == -1)
    {
        if(pbTime == -1)
        {
            if(customTime == -1)
            {
                if(aryTimes.count > 0)
                {
                    min = [[aryTimes objectAtIndex:0] longLongValue];
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                min = customTime;
            }
        }
        else
        {
            min = pbTime;
        }
    }
    else
    {
        min = goalTime;
    }
    
    for (int n = 0 ; n < aryTimes.count ; n ++) {
        
        int64_t time = [[aryTimes objectAtIndex:n] longLongValue];
        
        if(min > time) min = time;
    }
    
    if(pbTime != -1)
    {
        min = MIN(min, pbTime);
    }
    
    if(goalTime != -1)
    {
        min = MIN(min, goalTime);
    }
    
    if(customTime != -1)
    {
        min = MIN(min, customTime);
    }
    
    return min;
}

- (int64_t) getShowableMaxTime:(NSMutableArray *)aryTimes pb:(int64_t)pbTime time:(int64_t)goalTime time:(int64_t)customTime
{
    int64_t max = 0;
    
    if(goalTime == -1)
    {
        if(pbTime == -1)
        {
            if(customTime == -1)
            {
                if(aryTimes.count > 0)
                {
                    max = [[aryTimes objectAtIndex:0] longLongValue];
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                max = customTime;
            }
        }
        else
        {
            max = pbTime;
        }
    }
    else
    {
        max = goalTime;
    }
    
    for (int n = 0 ; n < aryTimes.count ; n ++) {
        
        int64_t time = [[aryTimes objectAtIndex:n] longLongValue];
        
        if(max < time) max = time;
    }
    
    if(pbTime != -1)
    {
        max = MAX(max, pbTime);
    }
    
    if(goalTime != -1)
    {
        max = MAX(max, goalTime);
    }
    
    if(customTime != -1)
    {
        max = MAX(max, customTime);
    }
    
    return max;
}

#pragma mark MYSChooseSwimmerViewControllerDelegate

- (void) chooseProfile:(MYSProfile *) profile
{
    self.swimmer = profile;
    
    [self initChartOptionSetting];
    
    [self loadAllDatas];
}

- (void) initChartOptionSetting
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
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

#pragma mark MYSSelectStrokeAndDistanceViewControllerDelegate

- (void) doneSelectDistanceAndStroke:(float) distance stroke:(int)stroke
{
    self.distance = distance;
    self.strokeIndex = stroke;
    
    [self loadAllDatas];
}

#pragma mark MYSChartViewDelegate

- (void) selectTimeOnChart:(int) index isOwner:(BOOL)isOwner
{
    MYSTime *time = nil;
    NSMutableArray *aryAllTimes = nil;
    
    if(isOwner)
    {
        aryAllTimes = [self getAllTimes:self.swimmer];
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        int64_t anotherSwimmerId = [[prefs objectForKey:CHART_ANOTHER_SWIMMER_ID] longLongValue];
            
        if(anotherSwimmerId != -1)
        {
            MYSProfile *anotherSwimmer = [[MYSDataManager shared] getProfileWithId:[NSString stringWithFormat:@"%lld", anotherSwimmerId]];
            
            aryAllTimes = [self getAllTimes:anotherSwimmer];
        }
    }
    
    if(index < aryAllTimes.count)
    {
        time = [aryAllTimes objectAtIndex:index];
    }
    
    if(time != nil)
    {
        MYSTimeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDetail"];
        vc.time = time;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}

@end
