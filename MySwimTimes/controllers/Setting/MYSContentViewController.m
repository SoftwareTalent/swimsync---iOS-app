//
//  MYSContentViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/30/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSContentViewController.h"

@interface MYSContentViewController ()

@property (nonatomic, assign) IBOutlet UIWebView *contentView;

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

@end

@implementation MYSContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.contentType == 0)
    {
        self.lblTitle.text = @"swimsync FAQs";
    }
    else
    {
        self.lblTitle.text = @"Contact us";
    }
    
    [self loadContent];
    
    self.navigationController.navigationBarHidden = NO;
    
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadContent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"swimsync_FAQs_June_2015" ofType:@"pdf"];
    NSURL *tagetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:tagetURL];
    [self.contentView loadRequest:request];
    
    [self.contentView setScalesPageToFit:YES];
}

@end
