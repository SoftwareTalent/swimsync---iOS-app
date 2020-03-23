//
//  MYSViewController.m
//  MySwimTimes
///Users/tomorrow/Desktop/IOS_Code_SwimSync/Swimsync/MySwimTimes/controllers/UploadResults/MSRAccountController.m
//  Created by Kerofrog on 3/3/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MSRImportController.h"

@interface MSRImportController ()<UITextFieldDelegate>


@end

@implementation MSRImportController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(IBAction)addNewButtonMethod:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message: @"Would you like to add another My Swim Results account?"
                                                       delegate: self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
    alertView.tag=1;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        NSLog(@"selected index is %ld",(long)buttonIndex);
    }
    else
    {
    
    }

}

@end
