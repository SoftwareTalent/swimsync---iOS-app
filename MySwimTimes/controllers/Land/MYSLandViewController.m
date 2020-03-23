//
//  MYSLandViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 9/21/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSLandViewController.h"

#import "MYSCustomTabBarViewController.h"

#import "DFPInterstitial.h"
#import "DFPBannerView.h"

#import "JSStoreManager.h"
#import "MYSUploadVC.h"
#import "MenuController.h"

@interface MYSLandViewController ()<GADBannerViewDelegate, GADInterstitialDelegate, JSStoreManagerDelegate, UploadDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerViewBG;

@property (nonatomic, assign) IBOutlet UIImageView *ivLogo;

@property (nonatomic, assign) IBOutlet UIView *viewMain;

@property (nonatomic, assign) IBOutlet UIButton *btnRemoveAds;
@property (nonatomic, assign) IBOutlet UIButton *btnRestore;

@property (nonatomic, retain) DFPInterstitial *fullAD;
@property (nonatomic, retain) DFPBannerView *bannerView;

- (IBAction)onSwimmer:(id)sender;
- (IBAction)onTimes:(id)sender;
- (IBAction)onMeets:(id)sender;
- (IBAction)onStopwatch:(id)sender;
- (IBAction)onPB:(id)sender;
- (IBAction)onChart:(id)sender;
- (IBAction)menuBtnAction:(UIButton *)sender;

@end

@implementation MYSLandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogo)];
//    [self.ivLogo addGestureRecognizer:tapGesture];
//    tapGesture = nil;
    
    self.btnRestore.layer.cornerRadius = 4;
    self.btnRestore.layer.borderColor = [UIColor grayColor].CGColor;
    self.btnRestore.layer.borderWidth = 1;
    
    self.btnRemoveAds.layer.cornerRadius = 4;
    self.btnRemoveAds.layer.borderColor = [UIColor grayColor].CGColor;
    self.btnRemoveAds.layer.borderWidth = 1;
    
//    self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    self.bannerView.rootViewController = self;
//    self.bannerView.adUnitID = EG_ADMOB_BANNERAD;
//    [self.view addSubview:self.bannerView];
//    [self.bannerView loadRequest:[GADRequest request]];
//    self.bannerView.delegate = self;
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
    
    if([segue.identifier isEqualToString:@"main"])
    {
        MYSCustomTabBarViewController *vc = segue.destinationViewController;
        vc.initMenuIndex = [sender intValue];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.containerViewBG setCenter:self.view.center];

    self.navigationController.navigationBarHidden = YES;
    
    CGSize size = self.view.frame.size;
    
    if(size.height <= 480)
    {
        self.ivLogo.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, 50 + CGRectGetHeight(self.ivLogo.frame) / 2);
        
        self.viewMain.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.viewMain.frame) / 2 - 50);
    }
//    else
//    {
//        self.ivLogo.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, self.viewMain.frame.origin.y / 2);
//    }
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL isPurchased = [prefs boolForKey:@"purchased"];
    BOOL isPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue];

    if(isPurchased)
    {
        self.btnRemoveAds.hidden = YES;
        self.bannerView.hidden = YES;
        self.btnRestore.hidden = YES;
    }
    else
    {
        self.btnRemoveAds.hidden = NO;
        self.bannerView.hidden = NO;
        self.btnRestore.hidden = NO;
        
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

- (void)tapLogo
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:6]];
}

- (IBAction)onSwimmer:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:0]];
}

- (IBAction)onTimes:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:1]];
}

- (IBAction)onMeets:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:2]];
}

- (IBAction)onStopwatch:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:3]];
}

- (IBAction)onPB:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:6]];
}

- (IBAction)onChart:(id)sender
{
    [self performSegueWithIdentifier:@"main" sender:[NSNumber numberWithInt:5]];
}

- (IBAction)menuBtnAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"to_menu" sender:sender];
}

- (IBAction)onRemoveAds:(id)sender
{
    JSStoreManager *jsStoreManager = [JSStoreManager sharedManager];
    
    jsStoreManager.delegate = self;
    
    [jsStoreManager BuyRemoveAds];
}

- (IBAction)onRestore:(id)sender
{
    JSStoreManager *jsStoreManager = [JSStoreManager sharedManager];
    jsStoreManager.delegate = self;
    
    [jsStoreManager Restore];
}

- (IBAction)onSetting:(id)sender
{
    [self performSegueWithIdentifier:@"settings" sender:nil];
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
//    NSLog(@"Admob==>interstitialDidReceiveAd");
    [ad presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"Admob==>didFailToReceiveAdWithError, %@", error.userInfo[@"error"]);
}

#pragma mark InAppPurchaseDelegate

-(void)Failed:(NSString*)errMsg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    alertView = nil;
}

-(void)SuccessedWithIdentifier:(NSString *)identifier
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Success to purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    alertView = nil;
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setBool:YES forKey:@"purchased"];
//    [prefs synchronize];
    [[[MYSAppData sharedInstance] appInstructor] setPurchasedToRemoveAdsValue:YES];
    
    self.btnRemoveAds.hidden = YES;
    self.bannerView.hidden = YES;
    self.btnRestore.hidden = YES;
}

#pragma mark - UploadDelegate
-(void)shouldBuySharingFunction {
    [self performSegueWithIdentifier:@"settings" sender:nil];
}

@end
