//
//  MYSViewController.m
//  MySwimTimes
///Users/tomorrow/Desktop/IOS_Code_SwimSync/Swimsync/MySwimTimes/controllers/UploadResults/MSRAccountController.m
//  Created by Kerofrog on 3/3/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "HelpController.h"

@interface HelpController ()
@end

@implementation HelpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
   
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


@end
