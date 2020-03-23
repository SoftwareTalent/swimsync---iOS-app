//
//  MYSSignUpVC.m
//  swimsync
//
//  Created by Probir Chakraborty on 25/06/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import "MYSSignUpVC.h"
#import "MYSValidateFields.h"
#import "Constant.h"
#import "MYSLandViewController.h"
#import "MYSAppDelegate.h"

@interface MYSSignUpVC () <UITextFieldDelegate, NetworkingClientDelegate,UIScrollViewDelegate> {
    
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UITextField *userNameTxt;
    __weak IBOutlet UITextField *emailTxt;
    __weak IBOutlet UITextField *passwordTxt;
    __weak IBOutlet UITextField *confirmPasswordTxt;
    __weak IBOutlet UILabel *alertLbl;
    __weak IBOutlet UIButton *signUpBtn;
    
    __weak IBOutlet UIScrollView *scrollerView;
    BOOL checkSignUp;
    
    NetworkingClient *networkingClient;
}

- (IBAction)signUpBtnAction:(UIButton *)sender;
- (IBAction)backBtnAction:(UIButton *)sender;

@end

@implementation MYSSignUpVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customInit];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods

-(void)customInit {
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = backButtonForController(self);
    signUpBtn.layer.cornerRadius = 4.0f;
    
    if (WIN_HEIGHT == 480) {
        scrollerView.contentSize = CGSizeMake(WIN_WIDTH, 480);
        scrollerView.scrollEnabled = YES;
    }
}

#pragma mark - Private Methods

-(BOOL)isallFieldsVerified {
    
    BOOL isVerified = NO;
    
    if(![TRIM_SPACE(userNameTxt.text) length]){
        alertLbl.text = @"*Please enter username";
        [alertLbl setHidden:NO];
    }
    else if (([MYSValidateFields validateUsername:userNameTxt.text] || ![MYSValidateFields validateEmailAddress:userNameTxt.text] ) && ([MYSValidateFields validateEmailAddress:userNameTxt.text] || ![MYSValidateFields validateUsername:userNameTxt.text])){
        alertLbl.text = @"*Please enter valid username";
        [alertLbl setHidden:NO];
    }
    else if (![TRIM_SPACE(emailTxt.text) length])
    {
        alertLbl.text = @"*Please enter email";
        [alertLbl setHidden:NO];
    }
    else if([MYSValidateFields validateEmailAddress:emailTxt.text]){
        alertLbl.text = @"*Please enter a valid email";
        [alertLbl setHidden:NO];
    }
    else if(![TRIM_SPACE(passwordTxt.text) length]){
        alertLbl.text = @"*Please enter Password";
        [alertLbl setHidden:NO];
    }
    else if ([passwordTxt.text length] <6){
        alertLbl.text = @"*Password must be of atleast 6 characters";
        [alertLbl setHidden:NO];
    }
    else if(![TRIM_SPACE(confirmPasswordTxt.text) length]){
        alertLbl.text = @"*Please re-type your Password";
        [alertLbl setHidden:NO];
    }
    else if (![confirmPasswordTxt.text isEqualToString:passwordTxt.text]){
        alertLbl.text = @"*Password does not match";
        [alertLbl setHidden:NO];
    }
    else{
        isVerified = YES;
    }
    
    return isVerified;
}

#pragma mark - Touch Event Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - Textfield Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [alertLbl setHidden:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
        case 100:
        case 101:
        {
            NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if([TRIM_SPACE(newText) length]> 55){
                return NO;
            }if (!newText.length) {
                return YES;
            }
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
            
        }break;
        case 102:
        case 103:
        {
            NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if([TRIM_SPACE(newText) length]> 8){
                return NO;
            }if (!newText.length) {
                return YES;
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [KTextField(textField.tag+1) becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - Button Action Methods

- (IBAction)signUpBtnAction:(UIButton *)sender {
    
    if([self isallFieldsVerified]) {
        
        [[self getNetworkingClient] requestServerForMethod:APIMethodType_SignUp withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:TRIM_SPACE(userNameTxt.text), @"user_name",TRIM_SPACE(emailTxt.text), @"email",TRIM_SPACE(passwordTxt.text), @"password", @"NO-TOKEN-YET", @"device_token", @"iOS", @"device_type",@"No", @"ads_purchase",@"No", @"share_result_purchase", nil] controller:self forHTTPMethod:HTTPMethod_POST];
    } 
}

- (IBAction)backBtnAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navigateToLandingControllerWithUser : (MYSInstructorProfile*)instructor {
    
    //enable timeout function
    [(MYSAppDelegate*)[[UIApplication sharedApplication] delegate] applicationShouldTimedout:YES];
    
    //save instructor to shared instance
    [[MYSAppData sharedInstance] setAppInstructor:instructor];
    
    [[NSUserDefaults standardUserDefaults] setValue:instructor.instructorID forKey:@"loggedInInstructor"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDictionary dictionaryWithObjectsAndKeys: TRIM_SPACE(userNameTxt.text), @"userName", TRIM_SPACE(passwordTxt.text), @"password", [NSNumber numberWithBool:NO], @"rememberMe", nil] forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MYSLandViewController *landVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSLandViewControllerID"];
    [self.navigationController pushViewController:landVC animated:YES];
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
            case APIMethodType_SignUp: {
                
                [[MYSDataManager shared] removePreviousInstructroIfAny];
                
                MYSInstructorProfile *instructor = [[MYSDataManager shared] getInstructorProfileWithData:response];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setBool:YES forKey:@"userSignedUp"];
                [prefs synchronize];
                
                
                BOOL wasAdsRemoved = [prefs boolForKey:@"purchased"];
                
                if (wasAdsRemoved) {
                    [[[NetworkingClient alloc] init] requestServerForMethod:APIMethodType_UpdatePaymentStatus withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[instructor instructorID], @"userID", @"Yes", @"ads_purchase", @"No", @"share_result_purchase", nil] controller:nil forHTTPMethod:HTTPMethod_POST];
                    [instructor setPurchasedToRemoveAdsValue:YES];
                }
                
                //add existing swimmer to the first user, signs up on the device
//                [[MYSDataManager shared] checkAndAddAllExistingSwimmersToInstructor:instructor];
                
                [self navigateToLandingControllerWithUser:instructor];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
