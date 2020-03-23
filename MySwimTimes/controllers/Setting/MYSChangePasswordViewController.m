//
//  MYSChangePasswordViewController.m
//  swimsync
//
//  Created by Krishna Kant Kaira on 14/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSChangePasswordViewController.h"
#import "MYSCustomTF.h"
#define KAppTextBorderColor         [UIColor colorWithRed:172.0/256.0 green:172.0/256.0 blue:172.0/256.0 alpha:1.0]

@interface MYSChangePasswordViewController () <NetworkingClientDelegate, UITextFieldDelegate> {
    
    NetworkingClient *networkingClient;
}

@property (nonatomic, weak) IBOutlet MYSCustomTF *textField_oldPassword;
@property (nonatomic, weak) IBOutlet MYSCustomTF *textField_newPassword;
@property (nonatomic, weak) IBOutlet MYSCustomTF *textField_confirmPassword;
@property (nonatomic, weak) IBOutlet UILabel *label_errMessage;

-(IBAction)saveButtonAction:(id)sender;

@end

@implementation MYSChangePasswordViewController

#pragma mark - View Life Cylce Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField_oldPassword addBorder:KAppTextBorderColor AndRadius:3.0f];
    [self.textField_oldPassword setlefImageWithName:@"lock1_icon"];
    [self.textField_newPassword addBorder:KAppTextBorderColor AndRadius:3.0f];
    [self.textField_newPassword setlefImageWithName:@"lock1_icon"];
    [self.textField_confirmPassword addBorder:KAppTextBorderColor AndRadius:3.0f];
    [self.textField_confirmPassword setlefImageWithName:@"lock1_icon"];
} 

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveButtonAction:(id)sender {
    
    NSString *oldPassword = [self.textField_oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newPassword = [self.textField_newPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirmPassword = [self.textField_confirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([oldPassword length] > 0) {
        if ([newPassword length] > 0) {
            if ([newPassword length] >= 6) {
                if ([confirmPassword isEqualToString:newPassword]) {
                    [[self getNetworkingClient] requestServerForMethod:APIMethodType_ChangePassword withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"user_id", oldPassword, @"old_password", newPassword, @"new_password", nil] controller:self forHTTPMethod:HTTPMethod_POST];
                }
                else {
                    self.label_errMessage.text = @"*New password and confirm password doesn't match";
                }
            }
            else {
                self.label_errMessage.text = @"*Password must be of atleast 6 characters";
            }
        }
        else {
            self.label_errMessage.text = @"*Please enter new password";
        }
    }
    else {
        self.label_errMessage.text = @"*Please enter old password";
    }
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.label_errMessage.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([TRIM_SPACE(newText) length]> 8){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    BOOL shouldReturn = YES;
    if ([textField isEqual:self.textField_oldPassword]) {
        [self.textField_newPassword becomeFirstResponder];
    }
    else if ([textField isEqual:self.textField_newPassword]) {
        [self.textField_confirmPassword becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        shouldReturn = NO;
    }

    return shouldReturn;
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
            case APIMethodType_ChangePassword: {
                
                [[[MYSAppData sharedInstance] appInstructor] setPassword:[self.textField_newPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

                [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString([response objectForKey:@"responseMessage"], nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
