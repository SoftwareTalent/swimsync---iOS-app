//
//  MYSLoginVC.m
//  swimsync
//
//  Created by Probir Chakraborty on 24/06/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import "MYSLoginVC.h"
#import "MYSCustomTF.h"
#import "MYSLandViewController.h"
#import "Constant.h"
#import "MYSValidateFields.h"
#import "MYSForgotPasswordVC.h"
#import "MYSSignUpVC.h"
#import "MYSAppDelegate.h"
 

@interface MYSLoginVC ()<UITextFieldDelegate, NetworkingClientDelegate> {
    
    NetworkingClient *networkingClient;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet MYSCustomTF *usernameTextField;
@property (weak, nonatomic) IBOutlet MYSCustomTF *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordAlertLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *button_singUp;

- (IBAction)rememberBtnAction:(UIButton *)sender;
- (IBAction)loginBtnAction:(UIButton *)sender;
- (IBAction)signUpBtnAction:(UIButton *)sender;
- (IBAction)frgtPswrdBtnAction:(UIButton *)sender;

@end

@implementation MYSLoginVC {
    
    NSString *alert;
    NSInteger labelTag;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customInit];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _usernameAlertLabel.hidden = YES;
    _passwordAlertLabel.hidden = YES;
    
    [self.containerView setCenter:self.view.center];
    [self.navigationController setNavigationBarHidden:YES];

//#warning - need to be uncommented
    BOOL userRegisterd = ([[MYSDataManager shared] getCountOfInstructor] > 0);
    userRegisterd = [[NSUserDefaults standardUserDefaults] boolForKey:@"userSignedUp"];
    [self.button_singUp setEnabled:!userRegisterd];
    [self.button_singUp setAlpha:(userRegisterd ? 0.5 : 1.0)];
    
    [self setupPreviousLogin];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)setupPreviousLogin {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //Go to splash screen then login screen each time someone opens thea app(even if loggedin).The ‘Remember me’ box will be ticked and the user will just tap ‘login’.
    NSDictionary *userInfo = [prefs objectForKey:@"userInfo"];

//    if ([[userInfo valueForKey:@"rememberMe"] boolValue] || ([[prefs valueForKey:@"loggedInInstructor"] length] > 0)) {
    if ([[userInfo valueForKey:@"rememberMe"] boolValue]) {

        _usernameTextField.text = [userInfo valueForKey:@"userName"];
        _passwordTextField.text = [userInfo valueForKey:@"password"];
        _rememberBtn.selected = YES;
    }
    else {
        _usernameTextField.text = (userInfo ? [userInfo valueForKey:@"userName"] : @"");
        _rememberBtn.selected = NO;
    }
}

-(void)customInit {
    
    [_usernameTextField addBorder:KAppTextBorderColor AndRadius:3.0f];
    [_passwordTextField addBorder:KAppTextBorderColor AndRadius:3.0f];
    [_usernameTextField setlefImageWithName:@"user_icon"];
    [_passwordTextField setlefImageWithName:@"lock1_icon"];
    [_loginBtn.layer setCornerRadius:3.0f];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up movementDistance: (CGFloat) movementDistance{
    
    if (movementDistance == 0) return;
    
    // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Private Method
-(BOOL)isallFieldsVerified {
    
    BOOL  isVerified = NO;
    labelTag = 0;
    if([_usernameTextField.text length]==0){
        alert = @"*Please enter username";
        labelTag = 1;
    }
    else if (([MYSValidateFields validateUsername:_usernameTextField.text] || ![MYSValidateFields validateEmailAddress:_usernameTextField.text] ) && ([MYSValidateFields validateEmailAddress:_usernameTextField.text] || ![MYSValidateFields validateUsername:_usernameTextField.text])){
        alert = @"*Please enter valid username";
        labelTag = 1;
    }
    else if([_passwordTextField.text length]==0){
        alert = @"*Please enter Password";
        labelTag = 2;
    }
    else if ([_passwordTextField.text length] <6){
        alert = @"*Password must be of atleast 6 characters";
        labelTag = 2;
    }
    else {
        isVerified = YES;
        [self.view endEditing:YES];
    }
    
    return isVerified;
}

#pragma mark - Touch Event Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - Button Action Methods
- (IBAction)rememberBtnAction:(UIButton *)sender {
    _rememberBtn.selected = !_rememberBtn.selected;
}

- (IBAction)loginBtnAction:(UIButton *)sender {

    [self isallFieldsVerified];
    
//    if ([[MYSDataManager shared] getCountOfInstructor] == 0) {
//        [MethodHelper showAlertViewWithTitle:@"Error!" andMessage:@"Kindly signup on the device first." andButtonTitle:NSLocalizedString(@"OK", nil)];
//        return;
//    }
    
    switch (labelTag) {
        case 0: {
            [[self getNetworkingClient] requestServerForMethod:APIMethodType_Login withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:TRIM_SPACE(_usernameTextField.text), @"user_name", TRIM_SPACE(_passwordTextField.text), @"password", @"NO-TOKEN-YET", @"device_token", @"iOS", @"device_type", nil] controller:self forHTTPMethod:HTTPMethod_POST];
        }
            break;
        case 1:
        {
            [_usernameTextField addBorder:[UIColor redColor] AndRadius:4.0f];
            [_passwordTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
            _usernameAlertLabel.text = alert;
            _usernameAlertLabel.hidden = NO;
            _passwordAlertLabel.hidden = YES;
        }
            break;
        case 2:
        {
            [_passwordTextField addBorder:[UIColor redColor] AndRadius:4.0f];
            [_usernameTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
            _passwordAlertLabel.text = alert;
            _passwordAlertLabel.hidden = NO;
            _usernameAlertLabel.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)signUpBtnAction:(UIButton *)sender {
    [self refreshScreenData];

    MYSSignUpVC *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSSignUpVCID"];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (IBAction)frgtPswrdBtnAction:(UIButton *)sender {
    [self refreshScreenData];

    MYSForgotPasswordVC *forgotVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSForgotPasswordVCID"];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

#pragma mark - TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self animateTextField:textField up:YES movementDistance:((WIN_HEIGHT == 480) ? 85: 0)];
    [_usernameTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
    _usernameAlertLabel.hidden = YES;
    [_passwordTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
    _passwordAlertLabel.hidden = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self animateTextField:textField up:NO movementDistance:((WIN_HEIGHT == 480) ? 85: 0)];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _usernameTextField) {
        if([TRIM_SPACE(newText) length]> 55){
            return NO;
        }if (!newText.length) {
            return YES;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    if (textField == _passwordTextField) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if([TRIM_SPACE(newText) length]> 8){
            return NO;
        }if (!newText.length) {
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
        [_usernameTextField resignFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

-(void)navigateToLandingControllerWithUser : (MYSInstructorProfile*)instructor withAnimation:(BOOL)animated{
    
    //enable timeout function
    [(MYSAppDelegate*)[[UIApplication sharedApplication] delegate] applicationShouldTimedout:YES];

    //save instructor to shared instance
    [[MYSAppData sharedInstance] setAppInstructor:instructor];
    
    [[NSUserDefaults standardUserDefaults] setValue:instructor.instructorID forKey:@"loggedInInstructor"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSDictionary dictionaryWithObjectsAndKeys: TRIM_SPACE(_usernameTextField.text), @"userName", TRIM_SPACE(_passwordTextField.text), @"password", [NSNumber numberWithBool:self.rememberBtn.selected], @"rememberMe", nil] forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    MYSLandViewController *landVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSLandViewControllerID"];
    [self.navigationController pushViewController:landVC animated:animated];
    
    [self refreshScreenData];
}

-(void)refreshScreenData {
    
    _usernameTextField.text = @"";
    _passwordTextField.text = @"";
    _rememberBtn.selected = NO;
    [self.view endEditing:YES];
    
    [_usernameTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
    [_passwordTextField addBorder:KAppTextBorderColor AndRadius:4.0f];
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
            MYSInstructorProfile *instructor = [[MYSDataManager shared] logInInstructorWithUserName:TRIM_SPACE(_usernameTextField.text) andPassword:TRIM_SPACE(_passwordTextField.text)];
            if (instructor) {
                [self navigateToLandingControllerWithUser:instructor withAnimation:YES];
            }
            else
                [MethodHelper showAlertViewWithTitle:@"Authentication Failed" andMessage:@"The username and password you entered don't match any entry." andButtonTitle:NSLocalizedString(@"OK", nil)];
        }
        else
            [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(errMessage, nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
    }
    else {
        switch (methodType) {
            case APIMethodType_Login: {
                
                
                
                [self navigateToLandingControllerWithUser:[[MYSDataManager shared] getInstructorProfileWithData:response] withAnimation:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
