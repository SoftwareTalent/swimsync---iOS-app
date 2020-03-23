//
//  MYSViewProfileViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 9/23/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSViewProfileViewController.h"

#import "MYSNewProfileViewController.h"

#import "DFPBannerView.h"
#import "MYSShareResultsVC.h"

@interface MYSViewProfileViewController ()<GADBannerViewDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) IBOutlet UIImageView *ivProfile;
@property (nonatomic, assign) IBOutlet UILabel *lblName;
@property (nonatomic, assign) IBOutlet UILabel *lblAge;

@property (nonatomic, assign) IBOutlet UILabel *lblGender;
@property (nonatomic, assign) IBOutlet UILabel *lblBirthday;
@property (nonatomic, assign) IBOutlet UILabel *lblSwimmerClub;
@property (nonatomic, assign) IBOutlet UILabel *lblCity;
@property (nonatomic, assign) IBOutlet UILabel *lblCountry;

@property (nonatomic, assign) IBOutlet UIImageView *ivImage;

@property (nonatomic, retain) DFPBannerView *bannerView;

- (IBAction)onBack:(id)sender;
- (IBAction)onEdit:(id)sender;
- (IBAction)shareBtnAction:(UIButton *)sender;


@end

@implementation MYSViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ivProfile.backgroundColor = [UIColor lightGrayColor];
    self.ivProfile.layer.cornerRadius = 5;
    self.ivProfile.clipsToBounds = YES;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"editprofile"])
    {
        MYSNewProfileViewController *newProfileViewController = segue.destinationViewController;
        newProfileViewController.profile = self.swimmer;
        newProfileViewController.isEdit = YES;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL isPurchased = [prefs boolForKey:@"purchased"];
    BOOL isPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue];
    self.bannerView.hidden = isPurchased;
    
    [self loadInformation];
}

- (void) loadInformation
{
    self.ivProfile.image = [UIImage imageWithData:self.swimmer.image];
    
    self.lblName.text = [NSString stringWithFormat:@"%@", self.swimmer.name];
    self.lblAge.text = [NSString stringWithFormat:@"%.0f years",[MethodHelper countYearOld2:self.swimmer.birthday]];
    
    self.lblBirthday.text = [MethodHelper convertFullMonth:self.swimmer.birthday];
    self.lblSwimmerClub.text = self.swimmer.nameSwimClub;
    self.lblCity.text = self.swimmer.city;
    self.lblCountry.text = self.swimmer.country;
    
    self.lblGender.text = [NSString stringWithFormat:@"%@", [self.swimmer.gender intValue] == 0 ? @"Male" : @"Female"];
}

#pragma mark - Button Action Methods

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEdit:(id)sender
{
    [self performSegueWithIdentifier:@"editprofile" sender:self.swimmer];
}

- (IBAction)shareBtnAction:(UIButton *)sender {
    
    if ([[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Would you like to send all results of this swimmer to another swimsync user?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }
    else {
        [UIAlertView alertViewWithTitle:@"Alert" message:@"Would you like to purchase the sharing function?" cancelButtonTitle:@"No" otherButtonTitles:[NSArray arrayWithObject:@"Yes"] onDismiss:^(int buttonIndex) {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MYSSettings"] animated:YES];
        } onCancel:^{
        }];
    }
}

#pragma mark - GABDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view {
//    NSLog(@"ADBanner==>adViewDidReceiveAd");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"ADBanner==>adViewFailed, %@", error.userInfo[@"error"]);
}

#pragma mark - AlertView Delegate Method

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MYSShareResultsVC *shareResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSShareResultsVCID"];
        shareResultVC.string_resultData = [self getReportStrtoShare];
        [self.navigationController pushViewController:shareResultVC animated:YES];
    }
}

-(NSString*)getReportStrtoShare {
    
    NSMutableDictionary *reportdata = [NSMutableDictionary dictionary];
    [reportdata setValue:[[[MYSAppData sharedInstance] appInstructor] userName] forKey:@"userName"];
    [reportdata setValue:self.swimmer.name forKey:@"swimmerName"];
    [reportdata setValue:@"1" forKey:@"reportType"];
    [reportdata setValue:@"All swimsync results" forKey:@"reportTitle"];
    [reportdata setValue:@"" forKey:@"reportSubTitle"];
    
    NSString *imageStr = [UIImagePNGRepresentation([UIImage imageWithData:self.swimmer.image]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *profileInfo = [NSMutableDictionary dictionary];
    [profileInfo setValue:self.swimmer.name forKey:@"swimmerName"];
    [profileInfo setValue:[NSString stringWithFormat:@"%lld",[self.swimmer.userid longLongValue]] forKey:@"swimmerID"];
    [profileInfo setValue:((imageStr.length > 0) ? imageStr : @"") forKey:@"profileImage"];
    [profileInfo setValue:[NSString stringWithFormat:@"%d",[self.swimmer.gender shortValue]] forKey:@"gender"];
    [profileInfo setValue:[MethodHelper convertFullMonth:self.swimmer.birthday] forKey:@"birthday"];
    [profileInfo setValue:(self.swimmer.nameSwimClub ? self.swimmer.nameSwimClub : @"") forKey:@"club"];
    [profileInfo setValue:(self.swimmer.city ? self.swimmer.city : @"") forKey:@"city"];
    [profileInfo setValue:(self.swimmer.country ? self.swimmer.country : @"") forKey:@"country"];
    [reportdata setValue:profileInfo forKey:@"swimmerInfo"];
    
    NSMutableArray *goalTimeData = [NSMutableArray array];
    for (MYSGoalTime*goalTime in self.swimmer.goaltime) {
        NSMutableDictionary *goalItem = [NSMutableDictionary dictionary];
        [goalItem setValue:[NSString stringWithFormat:@"%d",[goalTime.courseType shortValue]] forKey:@"courseType"];
        [goalItem setValue:[NSString stringWithFormat:@"%lld",[goalTime.distance longLongValue]] forKey:@"distance"];
        [goalItem setValue:[NSString stringWithFormat:@"%d",[goalTime.stroke intValue]] forKey:@"stroke"];
        [goalItem setValue:[NSString stringWithFormat:@"%lld",[goalTime.time longLongValue]] forKey:@"time"];
        [goalTimeData addObject:goalItem];
    }
    [reportdata setValue:goalTimeData forKey:@"goalInfo"];
    
    NSMutableArray *array_times = [NSMutableArray array];
    NSMutableDictionary *dict_meetInfo = [NSMutableDictionary dictionary];
    NSMutableArray *temp_meetID = [NSMutableArray array];
    for (MYSTime *time in [self.swimmer.time allObjects]) {
        
        NSMutableDictionary *timeData = [NSMutableDictionary dictionary];
        [timeData setValue:[NSString stringWithFormat:@"%d",[time.course intValue]] forKey:@"course"];
        [timeData setValue:[NSString stringWithFormat:@"%f",[time.date timeIntervalSince1970]] forKey:@"date"];
        [timeData setValue:[NSString stringWithFormat:@"%f",[time.distance floatValue]] forKey:@"distance"];
        [timeData setValue:[NSString stringWithFormat:@"%lld",[time.reactionTime longLongValue]] forKey:@"reactionTime"];
        [timeData setValue:[NSString stringWithFormat:@"%d",[time.stage shortValue]] forKey:@"stage"];
        [timeData setValue:[NSString stringWithFormat:@"%d",[time.status intValue]] forKey:@"status"];
        [timeData setValue:[NSString stringWithFormat:@"%d",[time.stroke intValue]] forKey:@"stroke"];
        [timeData setValue:[NSString stringWithFormat:@"%lld",[time.time longLongValue]] forKey:@"time"];
        
        NSMutableArray *lapInfo = [NSMutableArray array];
        for (MYSLap *lapObj in [time.laps allObjects]) {
            NSMutableDictionary *lapData = [NSMutableDictionary dictionary];
            [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.id longLongValue]] forKey:@"id"];
            [lapData setValue:[NSString stringWithFormat:@"%lld",lapObj.idValue] forKey:@"idValue"];
            [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.lapNumber longLongValue]] forKey:@"lapNumber"];
            [lapData setValue:[NSString stringWithFormat:@"%lld",[lapObj.splitTime longLongValue]] forKey:@"splitTime"];
            [lapInfo addObject:lapData];
        }
        [timeData setValue:lapInfo forKey:@"lapInfo"];
        
        NSString *temp_meetIDValue = [NSString stringWithFormat:@"%lld",time.meet.idValue];
        if (temp_meetIDValue) {
            [timeData setValue:temp_meetIDValue forKey:@"meetidValue"];
            if ([temp_meetID containsObject:[timeData valueForKey:@"meetidValue"]] == NO) {
                [temp_meetID addObject:[timeData valueForKey:@"meetidValue"]];
                [dict_meetInfo setValue:[self getMeetData:time.meet] forKey:[timeData valueForKey:@"meetidValue"]];
            }
        }
        
        [array_times addObject:timeData];
    }
    
    [reportdata setValue:array_times forKey:@"timesInfo"];
    [reportdata setValue:dict_meetInfo forKey:@"meetInfo"];
    
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
    
    NSMutableArray *array_qualify = [NSMutableArray array];
    for (MYSQualifyTime *timeItem in [meet.qualifytimes allObjects]) {
        
        NSMutableDictionary *timeData = [NSMutableDictionary dictionary];
        [timeData setValue:[NSString stringWithFormat:@"%d",[timeItem.gender shortValue]] forKey:@"gender"];
        [timeData setValue:[NSString stringWithFormat:@"%d",[timeItem.id intValue]] forKey:@"id"];
        [timeData setValue:[NSString stringWithFormat:@"%d",timeItem.idValue] forKey:@"idValue"];
        [timeData setValue:(timeItem.name ? timeItem.name : @"") forKey:@"name"];
        
        NSMutableArray *array_event = [NSMutableArray array];
        for (MYSEvent *eventItem in [timeItem.events allObjects]) {
            
            NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
            [eventData setValue:[NSString stringWithFormat:@"%f",[eventItem.distance floatValue]] forKey:@"distance"];
            [eventData setValue:[NSString stringWithFormat:@"%f",eventItem.distanceValue] forKey:@"distanceValue"];
            [eventData setValue:[NSString stringWithFormat:@"%lld",[eventItem.id longLongValue]] forKey:@"id"];
            [eventData setValue:[NSString stringWithFormat:@"%lld",eventItem.idValue] forKey:@"idValue"];
            [eventData setValue:[NSString stringWithFormat:@"%d",[eventItem.stroke shortValue]] forKey:@"stroke"];
            [eventData setValue:[NSString stringWithFormat:@"%lld",[eventItem.time longLongValue]] forKey:@"time"];
            
            [array_event addObject:eventData];
        }
        
        [timeData setValue:array_event forKey:@"eventsInfo"];
        [array_qualify addObject:timeData];
    }
    
    [meetdata setValue:array_qualify forKey:@"qualifyTimesInfo"];
    
    return meetdata;
}

@end
