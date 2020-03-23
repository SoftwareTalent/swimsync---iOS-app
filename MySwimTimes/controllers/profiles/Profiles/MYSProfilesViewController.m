//
//  MYSProfilesViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSProfilesViewController.h"
#import "MYSProfileCell.h"
#import "MYSNewProfileViewController.h"
#import "MYSViewProfileViewController.h"

static NSString * const kSegueModalStarScreen = @"SegueModalStarScreen";

@interface MYSProfilesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tbvProfiles;

@property (nonatomic, retain) NSArray* profileDataSource;

- (IBAction)onAdd:(id)sender;
- (IBAction)onBack:(id)sender;

@end

@implementation MYSProfilesViewController {
    BOOL isNeedShowInsertAnimation;
}

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
    
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"viewprofile"])
    {
        MYSViewProfileViewController *viewProfileViewController = segue.destinationViewController;
        viewProfileViewController.swimmer = sender;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadProfilesData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)loadProfilesData
{
    NSArray *arySwimmers = [[MYSDataManager shared] getAllProfiles];
    
    _profileDataSource = [arySwimmers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        NSString *obj1Name = ((MYSProfile *)obj1).name;
        NSString *obj2Name = ((MYSProfile *)obj2).name;
        
        return [obj1Name compare:obj2Name];
    }];
    
    if (_profileDataSource.count == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentProfile];
//        [[[MYSAppData sharedInstance] appInstructor] setCurrentProfile:nil];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter a swimmer(+) to get started." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        alertView = nil;
    }
    else
    {
        NSString *profileIdStr = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentProfile];
//        NSString *profileIdStr = [[[MYSAppData sharedInstance] appInstructor] currentProfile];
        
        MYSProfile *currentPro5 = [[MYSDataManager shared] getProfileWithId:profileIdStr];
        if (currentPro5)
        {
            int index = (int)[_profileDataSource indexOfObject:currentPro5];
            if (index >= 0 && index < _profileDataSource.count) {
                //[_tbvProfiles selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
        }
    }
    
    [self.tbvProfiles reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAdd:(id)sender
{
    [self gotoAddNewSwimmer];
}

- (void) gotoAddNewSwimmer
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (BOOL)validateStats:(MYSProfile*)profile
{
    if ([profile.time count] == 0)
    {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"ADD_NEW_TIME", nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
        return NO;
    }
    
    return YES;
}

#pragma mark - === UITableView Datasource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.profileDataSource count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tbvProfiles.frame), 40.0f);
    headerView.backgroundColor = [UIColor colorWithRed:112.0f / 255.0f green:181.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    label.text = @"Swimmers";
    
    [headerView addSubview:label];
    label = nil;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 80.0f;
    }
    
    return 68.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = ProfileCellIdentifier;
    
    MYSProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    MYSProfile *profile = [_profileDataSource objectAtIndex:indexPath.row];
    [cell loadDataForCellWithProfile:profile];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        MYSProfile *profile = [self.profileDataSource objectAtIndex:indexPath.row];
        [[MYSDataManager shared] deleteProfile:profile];
        
        [self loadProfilesData];
    }
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Profiel Object
    MYSProfile *profile = [self.profileDataSource objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", profile.userid] forKey:kCurrentProfile];
//    [[[MYSAppData sharedInstance] appInstructor] setCurrentProfile:[NSString stringWithFormat:@"%@", profile.userid]];

    [self performSegueWithIdentifier:@"viewprofile" sender:profile];
}

@end
