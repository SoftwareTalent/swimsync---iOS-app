//
//  MYSViewController.m
//  MySwimTimes
///Users/tomorrow/Desktop/IOS_Code_SwimSync/Swimsync/MySwimTimes/controllers/UploadResults/MSRAccountController.m
//  Created by Kerofrog on 3/3/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MSRAccountController.h"
#import "MYSCustomTF.h"
#import "MYSLandViewController.h"
#import "Constant.h"
#import "MYSValidateFields.h"
#import "MYSForgotPasswordVC.h"
#import "MYSSignUpVC.h"
#import "MYSAppDelegate.h"
#import "_MYSProfile.h"
#import "NetworkingClient.h"


@interface MSRAccountController ()<UITextFieldDelegate,NetworkingClientDelegate>
{
    
       NetworkingClient *networkingClient;
    NSMutableArray *userList;
     
    
}

@property (weak, nonatomic) IBOutlet MYSCustomTF *txt_username;
@property (weak, nonatomic) IBOutlet MYSCustomTF *txt_password;

@property (nonatomic, assign) IBOutlet UIScrollView *svMain;
@property (nonatomic, assign) IBOutlet UIView *viewPopMenu;
@property (retain,nonatomic) IBOutlet UITextField *txtSwimmerName;
@property (nonatomic, assign) IBOutlet UITableView *tvPopmenu;
@property (strong,nonatomic) NSMutableArray *arySwimmers;


@end

@implementation MSRAccountController
{
    NSString *alert;
    NSInteger labelTag;
}
- (IBAction)onActive:(id)sender {
    
    [self performSegueWithIdentifier:@"to_msrsign" sender:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.viewPopMenu.hidden = YES;
   // arySwimmers=[@[@"12",@"14",@"16",@"18",@"122"] mutableCopy];
    //[self customInit];
    userList=[[NSMutableArray alloc]init];
    //[self _initData];
    [self getSwimmers];
    [self.txt_password setDelegate:self];
    [self.txt_username setDelegate:self];
    self.txt_password.secureTextEntry = YES;
     
}

-(void)removePopUp:(UITapGestureRecognizer * )tap
{
    [self hidePopmenu];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField {
   
        [textField resignFirstResponder];
          return YES;
}


- (IBAction)onBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) closeKeyboard
{
   [self.txtSwimmerName resignFirstResponder];
}

- (void) showPopmenu:(int) menu
{
    [self.svMain bringSubviewToFront:self.viewPopMenu];
    
    self.viewPopMenu.tag = menu;
    self.viewPopMenu.hidden = NO;
    
    [self.tvPopmenu reloadData];
    

    
    UITextField *textField = nil;
    
    if(menu == 0) textField = self.txtSwimmerName;
     
    
    float pos = textField.frame.origin.x + CGRectGetWidth(textField.frame) - CGRectGetWidth(self.viewPopMenu.frame);
    
    CGRect rtBefor = CGRectMake(pos,self.swimmerView.frame.origin.y+textField.frame.origin.y+CGRectGetHeight(textField.frame), CGRectGetWidth(self.viewPopMenu.frame),0);
    
    CGRect rtAfter= CGRectMake(pos,self.swimmerView.frame.origin.y+textField.frame.origin.y+CGRectGetHeight(textField.frame), CGRectGetWidth(self.viewPopMenu.frame), 200);
    
    self.viewPopMenu.frame = rtBefor;
        [self.viewPopMenu bringSubviewToFront:self.view];
    [UIView animateWithDuration:0.5f animations:^{
        
        self.viewPopMenu.frame = rtAfter;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hidePopmenu
{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.viewPopMenu.frame = CGRectMake(self.viewPopMenu.frame.origin.x, self.viewPopMenu.frame.origin.y, CGRectGetWidth(self.viewPopMenu.frame), 0);
        
    } completion:^(BOOL finished) {
        
        self.viewPopMenu.hidden = YES;
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtSwimmerName)
    {
        if([self.arySwimmers count] == 0)
        {
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"SwimSync"
                                                             message:@"No swimmer has been found."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert2 show];
            
            return NO;
        }
        [self showPopmenu:0];
        [self closeKeyboard];
        
        return NO;
    }
    else
    {
        [self hidePopmenu];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtSwimmerName)
    {
      [self hidePopmenu];
    }
    
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
        return [self.arySwimmers count];
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
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

         return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.viewPopMenu.tag == 0)
    {
        MYSProfile *profile = [self.arySwimmers objectAtIndex:indexPath.row];
        self.txtSwimmerName.text=profile.name;
    }
    
    [self hidePopmenu];
    
  
}

- (void) _initData
{
    NSArray *arySwm = [[MYSDataManager shared] getAllProfiles];
    
    self.arySwimmers = [NSMutableArray arrayWithArray:[arySwm sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                                       {
                                                           NSString *obj1Name = ((MYSProfile *)obj1).name;
                                                           NSString *obj2Name = ((MYSProfile *)obj2).name;
                                                           
                                                           return [obj1Name compare:obj2Name];
                                                       }]];

}

- (IBAction)loginBtnAction:(UIButton *)sender {
    
    [self hidePopmenu];
    [self isallFieldsVerified];

    
    switch (labelTag) {
        case 0: {
            [[self getNetworkingClient] requestServerForMethod:APIMethodType_Login withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:TRIM_SPACE(self.txt_username.text), @"user_name", TRIM_SPACE(self.txt_password.text), @"password", @"NO-TOKEN-YET", @"device_token", @"iOS", @"device_type", nil] controller:self forHTTPMethod:HTTPMethod_POST];
        }
            break;
        case 1:
        {
            [self.txt_username addBorder:[UIColor redColor] AndRadius:4.0f];
            [self.txt_password addBorder:KAppTextBorderColor AndRadius:4.0f];
                     }
            break;
        case 2:
        {
            [self.txt_password addBorder:[UIColor redColor] AndRadius:4.0f];
            [self.txt_username addBorder:KAppTextBorderColor AndRadius:4.0f];
            
        }
            break;
            
        default:
            break;
    }
}

-(BOOL)isallFieldsVerified {
    
    BOOL  isVerified = NO;
    if([self.txt_username.text isEqualToString:@""])
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"SwimSync"
                                                        message:@"Please Enter User Name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert1 show];
    }
    else if([self.txt_password.text isEqualToString:@""])
    {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"SwimSync"
                                                        message:@"Please Enter Password"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert2 show];
    } else if([self.txtSwimmerName.text isEqualToString:@""])
    {
        UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"SwimSync"
                                                         message:@"Please Select Swimmer"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert3 show];
    }

    else
    {
        isVerified=YES;
    }
    
    return isVerified;
}

#pragma mark - * * * * Networking Methods * * * *
-(NetworkingClient*)getNetworkingClient {
    if (!networkingClient) networkingClient = [[NetworkingClient alloc] init];
    
    [networkingClient setClientDelegate:self];
    return networkingClient;
}

-(void)didRecieveResponse:(id)response withError:(NSString*)errMessage errorCode:(NSInteger)code forMethod:(APIMethodType)methodType {
    
    if (errMessage) {
        if ((code == NSURLErrorNotConnectedToInternet) || (code == NSURLErrorCannotConnectToHost) || (code == NSURLErrorNetworkConnectionLost) || (code == NSURLErrorCannotFindHost)) {
           
            MYSInstructorProfile *instructor = [[MYSDataManager shared] logInInstructorWithUserName:TRIM_SPACE(self.txt_username.text) andPassword:TRIM_SPACE(self.txt_password.text)];
            if (instructor) {
                //[self navigateToLandingControllerWithUser:instructor withAnimation:YES];
            }
            else
                [MethodHelper showAlertViewWithTitle:@"Error!" andMessage:@"The username or password is incorrect. Please try again." andButtonTitle:NSLocalizedString(@"OK", nil)];
        }
        else
        {
            [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(errMessage, nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
        }
    }
    else {
        switch (methodType) {
            case APIMethodType_Login: {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Success!"
                                                                    message: @"You can now import results found on My Swim Results directly into swimsync"
                                                                   delegate: self
                                                          cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles: nil];
                alertView.tag=12;
                [alertView show];
                
            }
                
                break;
            case APIMethodType_UserList:
            {
            
                self.arySwimmers = [response objectForKey:@"userList"];
                [self.tvPopmenu reloadData];
                
            }
                
            default:
                break;
        
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==12)
    {
    if (buttonIndex==0)
    {
        [self performSegueWithIdentifier:@"to_msrsign" sender:nil];
    }
    else
    {
        
    }}
}

-(void)getSwimmers
{
    
   // NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInInstructor"];
    
    
 //[[self getNetworkingClient] requestServerForMethod:APIMethodType_UserList withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"userID",nil] controller:self forHTTPMethod:HTTPMethod_POST];
    NSArray *aryLSwimmers = [[MYSDataManager shared] getAllProfiles];
    
    self.arySwimmers = [NSMutableArray arrayWithArray:[aryLSwimmers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                                       {
                                                           NSString *obj1Name = ((MYSProfile *)obj1).name;
                                                           NSString *obj2Name = ((MYSProfile *)obj2).name;
                                                           
                                                           return [obj1Name compare:obj2Name];
                                                       }]];
               [self.tvPopmenu reloadData];
}


@end
