//
//  MYSSettingViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/30/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSSettingViewController.h"

#import "JSStoreManager.h"

#import "MYSContentViewController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "MYSSettingCell.h"

#import "MYSChangePasswordViewController.h"

@interface MYSSettingViewController () <JSStoreManagerDelegate, MFMailComposeViewControllerDelegate, NetworkingClientDelegate> {
    
    NSArray *titleArray;
    NetworkingClient *networkingClient;
}

- (IBAction)changePasswordButtonAction:(id)sender;

@property (nonatomic, strong) MFMailComposeViewController *emailComposer;
@property (weak, nonatomic) IBOutlet UITableView *tvSettings;
@property (nonatomic, strong) UISwitch *swtNotification;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation MYSSettingViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    titleArray = [NSArray arrayWithObjects:@"In-app purchase",@"Restore app",@"Help",@"Contact us", nil];
    
    [self getEmailComposerInitiated];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.logoutBtn.layer.cornerRadius = 3.0f;
    self.logoutBtn.layer.masksToBounds = YES;
    self.tvSettings.tableHeaderView = _headerView;
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.text = [[[MYSAppData sharedInstance] appInstructor] userName];
    self.emailLabel.text = [[[MYSAppData sharedInstance] appInstructor] email];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.presentedViewController)
        [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getEmailComposerInitiated {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        self.emailComposer = [[MFMailComposeViewController alloc] init];
        self.emailComposer.mailComposeDelegate = self;
        [self.emailComposer setSubject:@"swimsync"];
        [self.emailComposer setMessageBody:@"" isHTML:NO];
        [self.emailComposer setToRecipients:@[@"swimsync.app@gmail.com"]];
    }
}

#pragma mark - IBAction
- (IBAction)changePasswordButtonAction:(id)sender {
    
    MYSChangePasswordViewController *changePwd = [self.storyboard instantiateViewControllerWithIdentifier:@"changePasswordVC"];
    [self.navigationController pushViewController:changePwd animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"content"]) {
        MYSContentViewController *vc = segue.destinationViewController;
        vc.contentType = [sender intValue];
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onResture {
    
    JSStoreManager *jsStoreManager = [JSStoreManager sharedManager];
    jsStoreManager.delegate = self;
    [jsStoreManager Restore];
}

- (void) onRemoveAds {
    
    JSStoreManager *jsStoreManager = [JSStoreManager sharedManager];
    jsStoreManager.delegate = self;
    [jsStoreManager BuyRemoveAds];
}

//- (void) onShareSwimSyncResultPurchase {
//    
//    JSStoreManager *jsStoreManager = [JSStoreManager sharedManager];
//    jsStoreManager.delegate = self;
//    [jsStoreManager BuyShareSwimSyncResult];
//}

- (void) onNotification {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:self.swtNotification.isOn forKey:@"notification"];
    [prefs synchronize];
    
    if(self.swtNotification.isOn)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    else
        [[MYSDataManager shared] updateLocalNotifications];
}

- (void) contactUs {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        if (!self.emailComposer) [self getEmailComposerInitiated];
        
        self.emailComposer.navigationBar.barStyle = UIBarStyleDefault;
        [self presentViewController:self.emailComposer animated:YES completion:nil];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Your device doesn't support this feature."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark MFMailControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - === UITableView Datasource ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((section == 0) ? 2 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MYSSettingCellID";
    MYSSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MYSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.rateLabel.hidden = YES;

    switch (indexPath.section) {
        case 0: {
            cell.rateLabel.hidden = NO;

            BOOL adsPurchased = NO;
            
            if (indexPath.row == 0) {
                cell.itemLabel.text = @"Remove ads";
                cell.itemImgView.image = [UIImage imageNamed:@"up_icon"];
                
                 adsPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue];
            }
            else if (indexPath.row == 1) {
                cell.itemLabel.text = @"Share and import swimsync results";
                cell.itemImgView.image = [UIImage imageNamed:@"up_icon"];
                cell.upperLabel.hidden = YES;
                adsPurchased = [[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue];
            }
            
            cell.rateLabel.text = (adsPurchased ? @"Purchased" : @"$0.99 US");
            cell.rateLabel.textColor = (adsPurchased ? [UIColor blueColor] : [UIColor darkGrayColor]);
        }
            break;
            
        case 1:
            cell.itemLabel.text = @"Restore swimsync";
            cell.itemImgView.image = [UIImage imageNamed:@"restore_icon"];
            break;
            
        case 2:
            cell.itemLabel.text = @"swimsync FAQs";
            cell.itemImgView.image = [UIImage imageNamed:@"faq"];
            
            break;
            
        case 3:
            cell.itemLabel.text = @"Email the swimsync team";
            cell.itemImgView.image = [UIImage imageNamed:@"email_icon"];
            
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - === UITableView Delegate methods ===

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc]init];
    sectionView.frame = CGRectMake(0, 0, WIN_WIDTH, 55);
    sectionView.backgroundColor = [UIColor clearColor];
    UILabel *itemLabel = [[UILabel alloc]init];
    itemLabel.frame = CGRectMake(10, 10, WIN_WIDTH-20, 25);
    itemLabel.text = [titleArray objectAtIndex:section];
    [sectionView addSubview:itemLabel];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                //Remove ads
                if (![[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue]) {
                    [UIAlertView alertViewWithTitle:@"Alert" message:@"Would you like to purchase remove ads?" cancelButtonTitle:nil otherButtonTitles:[NSArray arrayWithObject:@"OK"] onDismiss:^(int buttonIndex) {
                        [self onRemoveAds];
                    } onCancel:^{
                    }];
                }
            }
            else if (indexPath.row == 1) {
                //Share swimsync result
                if (![[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue]) {
                    [UIAlertView alertViewWithTitle:@"Alert" message:@"Would you like to purchase share swimsync results?" cancelButtonTitle:nil otherButtonTitles:[NSArray arrayWithObject:@"OK"] onDismiss:^(int buttonIndex) {
                        //[self onShareSwimSyncResultPurchase];
                    } onCancel:^{
                    }];
                }
            }
        }
            break;
            
        case 1: {
            //restore swimsync
            [self onResture];
        }
            break;
            
        case 2: {
            //swimsync FAQs
            [self performSegueWithIdentifier:@"content" sender:[NSNumber numberWithInteger:indexPath.row]];
        }
            break;
            
        case 3: {
            //Email the swimsync team
            [self contactUs];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark InAppPurchaseDelegate

-(void)Failed:(NSString*)errMsg {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void)SuccessedWithIdentifier:(NSString *)identifier {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Your payment was successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setBool:YES forKey:@"purchased"];
//    [prefs synchronize];
    
    if ([identifier isEqualToString:@"com.swimsync.product2"]) {
        //Ads_remove
        
        [[self getNetworkingClient] requestServerForMethod:APIMethodType_UpdatePaymentStatus withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", @"Yes", @"ads_purchase", ([[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue] ? @"Yes" : @"No"), @"share_result_purchase", nil] controller:self forHTTPMethod:HTTPMethod_POST];

        [[[MYSAppData sharedInstance] appInstructor] setPurchasedToRemoveAdsValue:YES];
    }
    else if ([identifier isEqualToString:@"com.swimsync.shareResult"]) {
        //share_result
        
        [[self getNetworkingClient] requestServerForMethod:APIMethodType_UpdatePaymentStatus withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", ([[[MYSAppData sharedInstance] appInstructor] purchasedToRemoveAdsValue] ? @"Yes" : @"No"), @"ads_purchase", @"Yes", @"share_result_purchase", nil] controller:self forHTTPMethod:HTTPMethod_POST];

        [[[MYSAppData sharedInstance] appInstructor] setPurchasedForShareResultValue:YES];
    }

    [self.tvSettings reloadData];
}

- (IBAction)onLogOut:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}

#pragma mark - AlertView Delegate Method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        //Log out
        [[MYSAppData sharedInstance] setAppInstructor:nil];
        
        NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
        [userDict setValue:[NSNumber numberWithBool:NO] forKey:@"rememberMe"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"loggedInInstructor"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] setValue:userDict forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - * * * * Networking Methods * * * *
-(NetworkingClient*)getNetworkingClient {
    if (!networkingClient) networkingClient = [[NetworkingClient alloc] init];
    
    [networkingClient setClientDelegate:self];
    return networkingClient;
}

-(void)didRecieveResponse:(id)response withError:(NSString*)errMessage errorCode:(NSInteger)code forMethod:(APIMethodType)methodType {
    
    if (errMessage) {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(errMessage, nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
    }
    else {
        switch (methodType) {
            case APIMethodType_UpdatePaymentStatus: {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
