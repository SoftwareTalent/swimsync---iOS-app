//
//  MYSForgotPasswordVC.m
//  swimsync
//
//  Created by Probir Chakraborty on 24/06/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSForgotPasswordVC.h"
#import "Constant.h"
#import "MYSCustomTF.h"
#import "MethodHelper.h"
#import "MYSValidateFields.h"

@interface MYSForgotPasswordVC () <NetworkingClientDelegate,UITextFieldDelegate> {
    
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UILabel *frgtPswrdLbl;
    __weak IBOutlet MYSCustomTF *emailTxt;
    __weak IBOutlet UILabel *userNameLbl;
    __weak IBOutlet UIButton *sendBtn;
    BOOL checkSend;
    
    NetworkingClient *networkingClient;
}

- (IBAction)sendBtnAction:(UIButton *)sender;
- (IBAction)backBtnAction:(UIButton *)sender;

@end

@implementation MYSForgotPasswordVC

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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(NSAttributedString *)gettingAttributedString:(NSString *)text AndFontSize:(CGFloat)size AndSpace:(CGFloat)space{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = space;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@{
                  NSFontAttributeName: CandaraRegularFont(size),NSParagraphStyleAttributeName:paragraphStyle
                  }];
    return attributedText;
}

-(void)customInit {
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationItem setTitle:@"Forgot Your Password"];
    [emailTxt setlefImageWithName:@"email_icon.png"];
    frgtPswrdLbl.attributedText = [self gettingAttributedString:@"Forgot Your password?\nNo problem, we will send your\n password to your email." AndFontSize:IS_IPHONE == YES ? 18 : 24 AndSpace:8.0f];
    [frgtPswrdLbl setTextAlignment:NSTextAlignmentCenter];
    sendBtn.layer.cornerRadius = 4.0f;
    self.navigationItem.leftBarButtonItem = backButtonForController(self);
    if (IS_IPHONE_6)
    {
        containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y+40, containerView.frame.size.width, containerView.frame.size.height);
    }
    if (IS_IPHONE_6Plus)
    {
        containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y+60, containerView.frame.size.width, containerView.frame.size.height);
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up movementDistance: (CGFloat) movementDistance{
    
    // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    containerView.frame = CGRectOffset(containerView.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Private Methods

-(BOOL)isallFieldsVerified {
    
    BOOL isVerified = NO;
    
    if (![TRIM_SPACE(emailTxt.text) length])
    {
        [emailTxt addBorder:[UIColor redColor] AndRadius:4.0f];
        userNameLbl.text = @"*Please enter email";
        [userNameLbl setHidden:NO];
    }
    else if([MYSValidateFields validateEmailAddress:emailTxt.text]){
        [emailTxt addBorder:[UIColor redColor] AndRadius:4.0f];
        userNameLbl.text = @"*Please enter a valid email";
        [userNameLbl setHidden:NO];
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
    
    [self animateTextField:textField up:YES movementDistance:((WIN_HEIGHT == 480) ? 80: 0)];
    [emailTxt addBorder:KAppTextBorderColor AndRadius:4.0f];
    [userNameLbl setHidden:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == emailTxt) {
        if ([textField.text length]>0) {
            [emailTxt addBorder:KAppTextBorderColor AndRadius:4.0f];
            [userNameLbl setHidden:YES];
        }
        if([TRIM_SPACE(newText) length]> 55){
            return NO;
        }if (!newText.length) {
            return YES;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self animateTextField:textField up:NO movementDistance:((WIN_HEIGHT == 480) ? 80: 0)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Button Action Methods

- (IBAction)sendBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if([self isallFieldsVerified]) {
        
        [[self getNetworkingClient] requestServerForMethod:APIMethodType_ForgotPassword withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:TRIM_SPACE(emailTxt.text), @"email", nil] controller:self forHTTPMethod:HTTPMethod_POST];
    } else {
    }
}

- (IBAction)backBtnAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
            case APIMethodType_ForgotPassword: {
                [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString([response valueForKey:@"responseMessage"], nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
