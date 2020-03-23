//
//  MYSChooseProfileViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/17/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSChooseProfileViewController.h"
#import "MYSProfile.h"
#import "MYSProfileCell.h"

@interface MYSChooseProfileViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tbvProfiles;

@property (nonatomic, strong) NSMutableArray* profileDataSource;

@end

@implementation MYSChooseProfileViewController

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
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadProfilesData];
}

- (void)loadProfilesData
{
    _profileDataSource = [[[MYSDataManager shared] getAllProfiles] mutableCopy];
    
    [_tbvProfiles reloadData];
}

#pragma mark - === UITableView Datasource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = ProfileCellIdentifier;
    
    MYSProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    MYSProfile *profile = [_profileDataSource objectAtIndex:indexPath.row];
    [cell loadDataForCellWithProfile:profile];
    
    return cell;
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYSProfile* profile = [self.profileDataSource objectAtIndex:indexPath.row];
    
    [MYSDataManager shared].lastSelectedSwimmer = profile;
    
    [self.delegate chooseProfile:profile];
    
    [self onBack:nil];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
