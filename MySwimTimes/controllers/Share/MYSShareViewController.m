//
//  MYSShareViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSShareViewController.h"
#import <MessageUI/MessageUI.h>

@interface MYSShareViewController () <MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    MFMailComposeViewController *mailComposer;
    
    UIImageView *bg;
}

@property (nonatomic, weak) IBOutlet UITableView *tbvShare;

@end

@implementation MYSShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    bg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:bg atIndex:0];
    bg.image = [UIImage imageNamed:@"bg.png"];
    
    self.title = @"Share";
    
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.presentedViewController)
        [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    bg.frame = [UIScreen mainScreen].bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - === UITableView Delegate methods ===
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MYSShareTableViewCell_Total;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"shareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    switch (indexPath.row) {
        case MYSShareTableViewCell_Twitter: {
            cell.textLabel.text = @"Twitter";
            break;
        }
            
        case MYSShareTableViewCell_Facebook: {
            cell.textLabel.text = @"Facebook";
            break;
        }
            
        case MYSShareTableViewCell_EmailFeedback: {
            cell.textLabel.text = @"Email/Feedback";
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_LINK]];
    } else if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FACEBOOK_LINK]];
    } else {
        
        mailComposer = [[MFMailComposeViewController alloc]init];
        [mailComposer setToRecipients:[NSArray arrayWithObjects:EMAIL_ADD, nil]];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"Feedback"];
//        [mailComposer setMessageBody:@"Testing message for the test mail" isHTML:NO];
         [self.navigationController presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"CONNECT";
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
//        NSLog(@"Result : %d",result);
    }
    if (error) {
//        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
