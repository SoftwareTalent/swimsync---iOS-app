//
//  MYSOpenTimesViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/26/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSOpenTimesViewController.h"

#import "MYSTimeCell.h"
#import "MYSOpenPBGoalTableViewCell.h"

#import "MYSCustomTabBarViewController.h"
#import "MYSProfilesViewController.h"

#import "MYSNewGoalTimeViewController.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSSelectStrokeAndDistanceViewController.h"

#import "MYSChooseProfileViewController.h"

#import "MYSTimeDetailViewController.h"

#import "MYSMeetDetailsViewController.h"

@interface MYSOpenTimesViewController ()<MYSChooseProfileViewControllerDelegate, MYSSelectStrokeAndDistanceViewControllerDelegate, UIAlertViewDelegate>
{
    NSIndexPath *_selectingIndexPathForPB;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView_indicator;

@property (weak, nonatomic) IBOutlet UITableView *tbvTimes;

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgFilter;

@property (nonatomic, assign) IBOutlet UIButton *btnSelectStrokeAndDis;

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

@property (nonatomic, retain) MYSProfile *swimmer;

@property (nonatomic, retain) NSMutableArray* aryTimeKeys;
@property (nonatomic, retain) NSMutableDictionary* dicTimes;

@property (nonatomic, retain) NSMutableArray *aryPBGoalTimeKeys;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) int strokeIndex;

@end

@implementation MYSOpenTimesViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"selectswimmer"])
    {
        MYSChooseProfileViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"distanceAndStroke"])
    {
        MYSSelectStrokeAndDistanceViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.distance = self.distance;
        vc.strokeIndex = 3;
        vc.isStaticStroke = YES;
    }
    else if([segue.identifier isEqualToString:@"newgold"])
    {
        MYSNewGoalTimeViewController *vc = segue.destinationViewController;
        vc.swimmer = self.swimmer;
        
        if(sender != nil)
        {
            NSIndexPath *indexPath = sender;
            
            NSString *distance = [self.aryPBGoalTimeKeys objectAtIndex:indexPath.section];
            
            MYSStrokeTypes stroke = 3;
            
            vc.distance = [distance floatValue];
            vc.stroke = stroke;
            vc.isEditing = YES;
        }
        else
        {
            vc.isEditing = NO;
        }
    }
    else if([segue.identifier isEqualToString:@"timedetail"])
    {
        MYSTimeDetailViewController *vc = segue.destinationViewController;
        vc.time = sender;
    }
    else if([segue.identifier isEqualToString:@"meetdetail"])
    {
        MYSMeetDetailsViewController *vc = segue.destinationViewController;
        vc.meet = sender;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.distance = 10000;
    self.strokeIndex = 3;
    
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
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self loadAllDatas];
}

- (void) initView
{
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 105, CGRectGetWidth(self.view.frame), 70.0f);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwimmerView:)];
    [self.swimmerView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self.view addSubview:self.swimmerView];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:[self.btnSelectStrokeAndDis attributedTitleForState:UIControlStateNormal]];
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
    [self performSegueWithIdentifier:@"selectswimmer" sender:nil];
}

- (void) loadAllDatas
{
    [self loadSelectedSwimmerData];
    [self loadCurrentDistanceAndStroke];
    
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        [self loadTimesData];
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        [self loadPBGoalTimes];
    }
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
    
    [self.btnSelectStrokeAndDis setTitle:[NSString stringWithFormat:@"%@m %@", [MYSDataManager numberStringWithCommna:self.distance], strokeName] forState:UIControlStateNormal];
}

- (void)loadTimesData
{
    NSArray *times = [self.swimmer.time allObjects];
    
    MYSCourseType courseType = MYSCourseType_Open;
    
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
        return [obj1.date compare:obj2.date];
    }];
    
    [self sortTimes:aryTimes];
    aryTimes = nil;
    
    [_tbvTimes reloadData];
}

- (void)sortTimes:(NSMutableArray *)aryTimes
{
    if(self.dicTimes == nil)
    {
        self.dicTimes = [[NSMutableDictionary alloc] init];
    }
    [self.dicTimes removeAllObjects];
    
    NSMutableArray *aryKeys = [[NSMutableArray alloc] init];
    for (MYSTime *time in aryTimes) {
        
        NSDate *date = time.meet.startDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *year = [dateFormatter stringFromDate:date];
        dateFormatter = nil;
        
        NSMutableArray *arySubTimes = [self.dicTimes objectForKey:year];
        
        if(arySubTimes == nil)
        {
            arySubTimes = [[NSMutableArray alloc] init];
            [arySubTimes addObject:time];
            
            [self.dicTimes setObject:arySubTimes forKey:year];
            [aryKeys addObject:year];
        }
        else
        {
            [arySubTimes addObject:time];
        }
    }
    
    self.aryTimeKeys = (NSMutableArray *)[aryKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                          {
                                              float distance1 = [obj1 floatValue];
                                              float distance2 = [obj2 floatValue];
                                              
                                              if(distance1 < distance2)
                                              {
                                                  return NSOrderedDescending;
                                              }
                                              else if(distance1 == distance2)
                                              {
                                                  return NSOrderedSame;
                                              }
                                              
                                              return NSOrderedAscending;
                                          }];
    
    aryKeys = nil;
}

- (void) loadPBGoalTimes
{
    NSArray *times = [self.swimmer.time allObjects];
    
    NSMutableArray *aryKeys = [[NSMutableArray alloc] init];
    for (MYSTime *time in times)
    {
        MYSStrokeTypes stroke = [time.stroke intValue];
        MYSCourseType courseType = [time.course intValue];
        
        if(stroke != 3 || courseType != MYSCourseType_Open)
            continue;
        
        int distance = (int)[time.distance floatValue];
        
        NSString *distanceKeyword = [NSString stringWithFormat:@"%d", distance];
        
        if([aryKeys indexOfObject:distanceKeyword] == NSNotFound)
        {
            [aryKeys addObject:distanceKeyword];
        }
    }
    
    self.aryPBGoalTimeKeys = (NSMutableArray *)[aryKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                            {
                                                float distance1 = [obj1 floatValue];
                                                float distance2 = [obj2 floatValue];
                                                
                                                if(distance1 > distance2)
                                                {
                                                    return NSOrderedDescending;
                                                }
                                                else if(distance1 == distance2)
                                                {
                                                    return NSOrderedSame;
                                                }
                                                
                                                return NSOrderedAscending;
                                            }];
    
    aryKeys = nil;
    
    
    [self.tbvTimes reloadData];
}

#pragma mark - === UITableView Datasource ===
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(self.sgFilter.selectedSegmentIndex == 0)
        {
            return TimeCellHeightPad;
        }
        else if(self.sgFilter.selectedSegmentIndex == 1)
        {
            return MYSOpenPBGoalTimeCellHeightPad;
        }
    }
    else
    {
        if(self.sgFilter.selectedSegmentIndex == 0)
        {
            return TimeCellHeight;
        }
        else if(self.sgFilter.selectedSegmentIndex == 1)
        {
            return MYSOpenPBGoalTimeCellHeight;
        }
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        return self.aryTimeKeys.count;
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        return self.aryPBGoalTimeKeys.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        NSString *year = [self.aryTimeKeys objectAtIndex:section];
        
        NSMutableArray *arySubTimes = [self.dicTimes objectForKey:year];
        
        return arySubTimes.count;
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        //NSString *distance = [self.aryPBGoalTimeKeys objectAtIndex:section];
        
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        static NSString *cellIdentifier = TimeCellIdentifier;
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *year = [self.aryTimeKeys objectAtIndex:indexPath.section];
        
        NSMutableArray *arySubTimes = [self.dicTimes objectForKey:year];
        
        MYSTime* time = [arySubTimes objectAtIndex:indexPath.row];
        
        [(MYSTimeCell *)cell loadDataForCellWithTime:time];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        NSString *distance = [self.aryPBGoalTimeKeys objectAtIndex:indexPath.section];
        
        MYSStrokeTypes stroke = 3;
        
        [(MYSOpenPBGoalTableViewCell *)cell setPBGoalTimeInformationWithSwimmer:self.swimmer distance:[distance intValue] stroke:stroke];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 16)];
    view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0f];
    
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        NSString *year = [self.aryTimeKeys objectAtIndex:section];
        
        // Name meet
        UILabel *date = [[UILabel alloc]init];
        date.frame = CGRectMake(12, 0, 100, 16);
        date.text = [NSString stringWithFormat:@"%@ Times", year];
        date.backgroundColor = [UIColor clearColor];
        date.textColor = [UIColor blackColor];
        date.font = [UIFont boldSystemFontOfSize:12];
        
        [view addSubview:date];
        date = nil;
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        view.backgroundColor = [UIColor colorWithRed:112.0f / 255.0f green:181.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
        
        NSString *distance = [self.aryPBGoalTimeKeys objectAtIndex:section];
        
        UILabel *lblDistance = [[UILabel alloc]init];
        lblDistance.frame = CGRectMake(4, 0, 100, 16);
        lblDistance.text = [NSString stringWithFormat:@"%@m", [MYSDataManager numberStringWithCommna:[distance doubleValue]]];
        lblDistance.backgroundColor = [UIColor clearColor];
        lblDistance.textColor = [UIColor whiteColor];
        lblDistance.font = [UIFont boldSystemFontOfSize:12];
        
        [view addSubview:lblDistance];
        lblDistance = nil;
        
        UILabel *lblShort = [[UILabel alloc]init];
        lblShort.textAlignment = NSTextAlignmentCenter;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            lblShort.frame = CGRectMake(350, 0, 80, 16);
        else
            lblShort.frame = CGRectMake(140, 0, 80, 16);
        lblShort.text = @"PB";
        lblShort.backgroundColor = [UIColor clearColor];
        lblShort.textColor = [UIColor whiteColor];
        lblShort.font = [UIFont boldSystemFontOfSize:12];
        
        [view addSubview:lblShort];
        lblShort = nil;
        
        UILabel *lblLong = [[UILabel alloc]init];
        lblLong.textAlignment = NSTextAlignmentCenter;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            lblLong.frame = CGRectMake(620, 0, 80, 16);
        else
            lblLong.frame = CGRectMake(230, 0, 80, 16);
        lblLong.text = @"Goal time";
        lblLong.backgroundColor = [UIColor clearColor];
        lblLong.textColor = [UIColor whiteColor];
        lblLong.font = [UIFont boldSystemFontOfSize:12];
        
        [view addSubview:lblLong];
        lblLong = nil;
    }
    
    return view;
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        NSString *year = [self.aryTimeKeys objectAtIndex:indexPath.section];
        
        NSMutableArray *arySubTimes = [self.dicTimes objectForKey:year];
        
        MYSTime* time = [arySubTimes objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"timedetail" sender:time];
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        NSString *distance = [self.aryPBGoalTimeKeys objectAtIndex:indexPath.section];
        
        MYSStrokeTypes stroke = 3;
        
        MYSTime *pbTime = [[MYSDataManager shared] getLatestPersionalBestOfProfile:self.swimmer withCourse:MYSCourseType_Open distance:[distance doubleValue] stroke:stroke];
        
        [self performSegueWithIdentifier:@"timedetail" sender:pbTime];
    }
}

#pragma mark MYSChooseSwimmerViewControllerDelegate

- (void) chooseProfile:(MYSProfile *) profile
{
    self.swimmer = profile;
}

- (IBAction)onSelectFilter:(id)sender
{
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        self.btnSelectStrokeAndDis.hidden = NO;
        //self.viewPB.hidden = NO;
        
        //float pos = self.viewPB.frame.origin.y + CGRectGetHeight(self.viewPB.frame) + 10;
        float pos = self.btnSelectStrokeAndDis.frame.origin.y + CGRectGetHeight(self.btnSelectStrokeAndDis.frame) + 6;
        float height = CGRectGetHeight(self.view.frame) - pos - 60;
        
        self.tbvTimes.frame = CGRectMake(self.tbvTimes.frame.origin.x, pos, CGRectGetWidth(self.tbvTimes.frame), height);
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        self.btnSelectStrokeAndDis.hidden = YES;
        //self.viewPB.hidden = YES;
        
        float height = CGRectGetHeight(self.view.frame) - self.btnSelectStrokeAndDis.frame.origin.y - 60;
        
        self.tbvTimes.frame = CGRectMake(self.tbvTimes.frame.origin.x, self.btnSelectStrokeAndDis.frame.origin.y, CGRectGetWidth(self.tbvTimes.frame), height);
    }
    
    [self loadAllDatas];
}

- (IBAction)onSelectStrokeAndDistance:(id)sender
{
    [self performSegueWithIdentifier:@"distanceAndStroke" sender:nil];
}

- (IBAction)onAddNewTime:(id)sender
{
    if(self.sgFilter.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"newtime" sender:nil];
    }
    else if(self.sgFilter.selectedSegmentIndex == 1)
    {
        [self performSegueWithIdentifier:@"newgold" sender:nil];
    }
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}

#pragma mark MYSSelectStrokeAndDistanceViewControllerDelegate

- (void) doneSelectDistanceAndStroke:(float) distance stroke:(int)stroke
{
    self.distance = distance;
    self.strokeIndex = 3;//stroke;
    
    [self loadAllDatas];
}

@end

