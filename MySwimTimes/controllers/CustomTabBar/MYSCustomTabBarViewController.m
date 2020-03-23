//
//  MYSCustomTabBarViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSCustomTabBarViewController.h"
#import "MYSStopwatchViewController.h"

#import "DFPInterstitial.h"
#import "DFPBannerView.h"

#define FONT_HELVETICA_NEUE_BOLD_12            [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]
#define INACTIVE_COLOR                          [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0]

#define ACTIVE_COLOR                          [UIColor colorWithRed:32/255.0 green:135/255.0 blue:252/255.0 alpha:1.0]

#define TAB_HEIGHT   60

@interface MYSCustomTabBarViewController ()<GADBannerViewDelegate, GADInterstitialDelegate>

@property (nonatomic, retain) DFPInterstitial *fullAD;
@property (nonatomic, retain) DFPBannerView *bannerView;

@end

@implementation MYSCustomTabBarViewController

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
    
    UIView *tabbarView = [UIView new];
    tabbarView.backgroundColor = [UIColor whiteColor];
    tabbarView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - TAB_HEIGHT, CGRectGetWidth(self.view.frame), TAB_HEIGHT);
    
    [self.view addSubview:tabbarView];
    self.myTabBar = tabbarView;
    
    float bannerHeight = 18.0f;
    float buttonWidth = 36.0f;
    
    UIView *bannerTabLabels = [UIView new];
    bannerTabLabels.backgroundColor = [UIColor colorWithRed:2.0f / 255.0f green:119.0f / 255.0f blue:254.0f / 255.0f alpha:1.0f];
    bannerTabLabels.frame = CGRectMake(0, TAB_HEIGHT - bannerHeight, CGRectGetWidth(tabbarView.frame), bannerHeight);
    
    [tabbarView addSubview:bannerTabLabels];
    
    float gap = CGRectGetWidth(self.view.frame) / 10;
    float interval = gap * 2;
    
    UILabel *lblTimes = [UILabel new];
    lblTimes.frame = CGRectMake(0, 0, 80, bannerHeight);
    lblTimes.center = CGPointMake(gap, bannerHeight / 2);
    lblTimes.backgroundColor = [UIColor clearColor];
    lblTimes.textColor = [UIColor whiteColor];
    lblTimes.font = FONT_HELVETICA_NEUE_BOLD_12;
    lblTimes.textAlignment = NSTextAlignmentCenter;
    lblTimes.text = @"Times";
    
    [bannerTabLabels addSubview:lblTimes];
    lblTimes = nil;
    
    _btnTimes = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTimes addTarget:self action:@selector(btnTimesTapped) forControlEvents:UIControlEventTouchDown];
    _btnTimes.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    _btnTimes.center = CGPointMake(gap, (TAB_HEIGHT - bannerHeight) / 2);
    [_btnTimes setBackgroundImage:[UIImage imageNamed:kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnTimes setBackgroundColor:[UIColor clearColor]];
    [self.myTabBar addSubview:_btnTimes];
    
    //-------------------------------------------------------
    
    UILabel *lblCharts = [UILabel new];
    lblCharts.frame = CGRectMake(0, 0, 80, bannerHeight);
    lblCharts.center = CGPointMake(gap + interval, bannerHeight / 2);
    lblCharts.backgroundColor = [UIColor clearColor];
    lblCharts.textColor = [UIColor whiteColor];
    lblCharts.font = FONT_HELVETICA_NEUE_BOLD_12;
    lblCharts.textAlignment = NSTextAlignmentCenter;
    lblCharts.text = @"Charts";
    
    [bannerTabLabels addSubview:lblCharts];
    lblCharts = nil;
    
    _btnCharts = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCharts addTarget:self action:@selector(btnChartsTapped) forControlEvents:UIControlEventTouchDown];
    _btnCharts.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    _btnCharts.center = CGPointMake(gap + interval, (TAB_HEIGHT - bannerHeight) / 2);
    [_btnCharts setBackgroundImage:[UIImage imageNamed:kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnCharts setBackgroundColor:[UIColor clearColor]];
    [self.myTabBar addSubview:_btnCharts];
    
    //-------------------------------------------------------
    
    UILabel *lblStopWatch = [UILabel new];
    lblStopWatch.frame = CGRectMake(0, 0, 80, bannerHeight);
    lblStopWatch.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) / 2, bannerHeight / 2);
    lblStopWatch.backgroundColor = [UIColor clearColor];
    lblStopWatch.textColor = [UIColor whiteColor];
    lblStopWatch.font = FONT_HELVETICA_NEUE_BOLD_12;
    lblStopWatch.textAlignment = NSTextAlignmentCenter;
    lblStopWatch.text = @"Stopwatch";
    
    [bannerTabLabels addSubview:lblStopWatch];
    lblStopWatch = nil;
    
    _btnStopwatch = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnStopwatch addTarget:self action:@selector(btnStopwatchTapped) forControlEvents:UIControlEventTouchDown];
    _btnStopwatch.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    _btnStopwatch.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) / 2, (TAB_HEIGHT - bannerHeight) / 2);
    [_btnStopwatch setBackgroundImage:[UIImage imageNamed:kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnStopwatch setBackgroundColor:[UIColor clearColor]];
    [self.myTabBar addSubview:_btnStopwatch];
    
    //-------------------------------------------------------
    
    UILabel *lblMeets = [UILabel new];
    lblMeets.frame = CGRectMake(0, 0, 80, bannerHeight);
    lblMeets.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) - (gap + interval), bannerHeight / 2);
    lblMeets.backgroundColor = [UIColor clearColor];
    lblMeets.textColor = [UIColor whiteColor];
    lblMeets.font = FONT_HELVETICA_NEUE_BOLD_12;
    lblMeets.textAlignment = NSTextAlignmentCenter;
    lblMeets.text = @"Meets";
    
    [bannerTabLabels addSubview:lblMeets];
    lblMeets = nil;
    
    _btnMeets = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMeets addTarget:self action:@selector(btnMeetsTapped) forControlEvents:UIControlEventTouchDown];
    _btnMeets.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    _btnMeets.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) - (gap + interval), (TAB_HEIGHT - bannerHeight) / 2);
    [_btnMeets setBackgroundImage:[UIImage imageNamed:kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnMeets setBackgroundColor:[UIColor clearColor]];
    [self.myTabBar addSubview:_btnMeets];
    
    //-------------------------------------------------------
    
    UILabel *lblSwimmers = [UILabel new];
    lblSwimmers.frame = CGRectMake(0, 0, 80, bannerHeight);
    lblSwimmers.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) - gap, bannerHeight / 2);
    lblSwimmers.backgroundColor = [UIColor clearColor];
    lblSwimmers.textColor = [UIColor whiteColor];
    lblSwimmers.font = FONT_HELVETICA_NEUE_BOLD_12;
    lblSwimmers.textAlignment = NSTextAlignmentCenter;
    lblSwimmers.text = @"Swimmers";
    
    [bannerTabLabels addSubview:lblSwimmers];
    lblSwimmers = nil;
    
    _btnProfiles = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnProfiles addTarget:self action:@selector(btnProfilesTapped) forControlEvents:UIControlEventTouchDown];
    _btnProfiles.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    _btnProfiles.center = CGPointMake(CGRectGetWidth(bannerTabLabels.frame) - gap, (TAB_HEIGHT - bannerHeight) / 2);
    [_btnProfiles setBackgroundImage:[UIImage imageNamed:kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnProfiles setBackgroundColor:[UIColor clearColor]];
    [self.myTabBar addSubview:_btnProfiles];
    
    bannerTabLabels = nil;

    [self btnProfilesTapped];
    
//    self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    self.bannerView.rootViewController = self;
//    self.bannerView.adUnitID = EG_ADMOB_BANNERAD;
//    [self.view addSubview:self.bannerView];
//    [self.bannerView loadRequest:[GADRequest request]];
//    self.bannerView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.initMenuIndex == 0)
    {
        [self btnProfilesTapped];
    }
    else if(self.initMenuIndex == 1)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:0 forKey:@"times"];
        [prefs synchronize];
        
        [self btnTimesTapped];
    }
    else if(self.initMenuIndex == 2)
    {
        [self btnMeetsTapped];
    }
    else if(self.initMenuIndex == 3)
    {
        [self btnStopwatchTapped];
    }
    else if(self.initMenuIndex == 4)
    {
        [self btnTimesTapped];
    }
    else if(self.initMenuIndex == 5)
    {
        [self btnChartsTapped];
    }
    else if(self.initMenuIndex == 6)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:1 forKey:@"times"];
        //[prefs setBool:YES forKey:@"showPBs"];
        [prefs synchronize];
        
        [self btnTimesTapped];
    }
    
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL isPurchased = [prefs boolForKey:@"purchased"];
    
    BOOL isPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue];
    if(!isPurchased)
    {
        int rand_value = rand() % 4;
        
        if(rand_value == 0)
        {
            [self initAdmobFull];
        }
    }
}

#pragma mark - Google Full AD
- (void) initAdmobFull
{
    self.fullAD = [[DFPInterstitial alloc] init];
    self.fullAD.adUnitID = EG_ADMOB_FULLAD;
    self.fullAD.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices =@[GAD_SIMULATOR_ID];
    
    [self.fullAD loadRequest:request];
}

- (BOOL)isAllowToChangeTab
{
    NSArray *pro5s = [[[MYSDataManager shared] getAllProfiles] mutableCopy];
    
    if (pro5s.count == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentProfile];
//        [[[MYSAppData sharedInstance] appInstructor] setCurrentProfile:nil];
    }
    else
    {
        NSString *profileIdStr = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentProfile];
//        NSString *profileIdStr = [[[MYSAppData sharedInstance] appInstructor] currentProfile];
        
        MYSProfile *currentPro5 = [[MYSDataManager shared] getProfileWithId:profileIdStr];
        if (currentPro5)
        {
            int index = (int)[pro5s indexOfObject:currentPro5];
            if (index >= 0 && index < pro5s.count) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)btnTimesTapped{
    if ([self isAllowToChangeTab] == NO)
    {
        return;
    }
    [self setSelectedIndex:0];
    
    // set background for other tab.
    [self updateTabButtons:0];
}

- (void)btnChartsTapped{
    if ([self isAllowToChangeTab] == NO) {
        return;
    }
    [self setSelectedIndex:4];
    
    [self updateTabButtons:1];
}

- (void)btnStopwatchTapped{
    if ([self isAllowToChangeTab] == NO) {
        return;
    }
    [self setSelectedIndex:2];
    
    [self updateTabButtons:2];
}

- (void)btnMeetsTapped{
    if ([self isAllowToChangeTab] == NO) {
        return;
    }
    [self setSelectedIndex:1];
    
    [self updateTabButtons:3];
}

- (void)btnProfilesTapped{
    [self setSelectedIndex:3];
    
    [self updateTabButtons:4];
}

- (void) updateTabButtons:(int) selectedIndex
{
    [_btnTimes setBackgroundImage:[UIImage imageNamed: (selectedIndex == 0) ? kSkinningTimesTapBG : kSkinningTimesBG] forState:UIControlStateNormal];
    [_btnCharts setBackgroundImage:[UIImage imageNamed:(selectedIndex == 1) ? kSkinningChartsTapBG : kSkinningChartsBG] forState:UIControlStateNormal];
    [_btnStopwatch setBackgroundImage:[UIImage imageNamed:(selectedIndex == 2) ? kSkinningStopwatchTapBG : kSkinningStopwatchBG] forState:UIControlStateNormal];
    [_btnMeets setBackgroundImage:[UIImage imageNamed:(selectedIndex == 3) ? kSkinningMeetsTapBG : kSkinningMeetsBG] forState:UIControlStateNormal];
    [_btnProfiles setBackgroundImage:[UIImage imageNamed:(selectedIndex == 4) ? kSkinningProfilesTapBG : kSkinningProfilesBG] forState:UIControlStateNormal];
}

#pragma mark - Implement Instance Methods

- (void)hideTabBarView:(UIViewController *)controller{
    
    self.myTabBar.hidden = YES;
    
    [controller setHidesBottomBarWhenPushed:YES];
}

- (void)showTabBarView:(UIViewController *)controller{
    
    self.myTabBar.hidden = NO;
    
    [controller setHidesBottomBarWhenPushed:NO];
}

#pragma mark - GABDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view {
//    NSLog(@"ADBanner==>adViewDidReceiveAd");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"ADBanner==>adViewFailed, %@", error.userInfo[@"error"]);
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if(self.selectedIndex == 2)
        return;
    
//    NSLog(@"Admob==>interstitialDidReceiveAd");
    [ad presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Admob==>didFailToReceiveAdWithError, %@", error.userInfo[@"error"]);
}

@end
