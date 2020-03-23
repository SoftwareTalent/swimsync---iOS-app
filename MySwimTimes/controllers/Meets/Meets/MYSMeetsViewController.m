//
//  MYSMeetsViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSMeetsViewController.h"
#import "MYSMeetCell.h"
#import "MYSMeetDetailsViewController.h"
#import "MYSNewMeetViewController.h"
#import "MYSMeet.h"

@interface MYSMeetsViewController ()

@property (nonatomic, assign) IBOutlet UISegmentedControl *sgCourseType;

// Table view meets
@property (weak, nonatomic) IBOutlet UITableView *tbvMeets;

@property (nonatomic, retain) NSMutableDictionary* dicShortMeets;
@property (nonatomic, retain) NSMutableArray *aryShortMeetKeys;

@property (nonatomic, retain) NSMutableDictionary* dicLongMeets;
@property (nonatomic, retain) NSMutableArray *aryLongMeetKeys;

@property (nonatomic, retain) NSMutableDictionary* dicOpenMeets;
@property (nonatomic, retain) NSMutableArray *aryOpenMeetKeys;

- (IBAction)onBack:(id)sender;

- (IBAction)onAddNewMeet:(id)sender;

- (IBAction)onChangeCourseType:(id)sender;

@end

@implementation MYSMeetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // transparent navigation
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    // Load meets data
    [self loadMeetsData];
}

- (void)loadMeetsData
{
    if(self.dicShortMeets == nil)
    {
        self.dicShortMeets  = [[NSMutableDictionary alloc] init];
        self.aryShortMeetKeys = [[NSMutableArray alloc] init];
    }
    [self.dicShortMeets removeAllObjects];
    [self.aryShortMeetKeys removeAllObjects];
    
    if(self.dicLongMeets == nil)
    {
        self.dicLongMeets = [[NSMutableDictionary alloc] init];
        self.aryLongMeetKeys = [[NSMutableArray alloc] init];
    }
    [self.dicLongMeets removeAllObjects];
    [self.aryLongMeetKeys removeAllObjects];
    
    if(self.dicOpenMeets == nil)
    {
        self.dicOpenMeets = [[NSMutableDictionary alloc] init];
        self.aryOpenMeetKeys = [[NSMutableArray alloc] init];
    }
    [self.dicOpenMeets removeAllObjects];
    [self.aryOpenMeetKeys removeAllObjects];
    
    NSArray *aryAllMeets = [[MYSDataManager shared] getAllMeetsInDatabase];
    [[MYSDataManager shared] setAllMeets:[NSMutableArray arrayWithArray:aryAllMeets]];
    
    aryAllMeets = [aryAllMeets sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                              NSDate *obj1StartDate = ((MYSMeet *)obj1).startDate;
                              NSDate *obj2StartDate = ((MYSMeet *)obj2).startDate;
                              
                              NSComparisonResult compareResult = [obj1StartDate compare:obj2StartDate];
                              
                              if(compareResult == NSOrderedAscending)
                              {
                                  compareResult = NSOrderedDescending;
                              }
                              else if(compareResult == NSOrderedDescending)
                              {
                                  compareResult = NSOrderedAscending;
                              }
                              
                              return compareResult;
                          }];
    
    for (MYSMeet *meet in aryAllMeets) {
        
        int courseType = (int)[meet.courseType integerValue];
        
        NSMutableDictionary *dicMeets = nil;
        NSMutableArray *aryKeys = nil;
        if(courseType == MYSCourseType_Short)
        {
            dicMeets = self.dicShortMeets;
            aryKeys = self.aryShortMeetKeys;
        }
        else if(courseType == MYSCourseType_Long)
        {
            dicMeets = self.dicLongMeets;
            aryKeys = self.aryLongMeetKeys;
        }
        else if(courseType == MYSCourseType_Open)
        {
            dicMeets = self.dicOpenMeets;
            aryKeys = self.aryOpenMeetKeys;
        }
        else
        {
            continue;
        }
        
        NSString *groupString = [self getStartYearWithMeet:meet];
        
        if(groupString == nil) continue;
        
        NSMutableArray *aryGroupMeets = [dicMeets objectForKey:groupString];
        
        if(aryGroupMeets == nil)
        {
            aryGroupMeets = [[NSMutableArray alloc] init];
            [aryGroupMeets addObject:meet];
            
            [dicMeets setObject:aryGroupMeets forKey:groupString];
            [aryKeys addObject:groupString];
        }
        else
        {
            [aryGroupMeets addObject:meet];
        }
    }
    
    [self.tbvMeets reloadData];
}

- (NSString *) getStartYearWithMeet:(MYSMeet *)meet
{
    NSDate *startDate = meet.startDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *year = [dateFormatter stringFromDate:startDate];
    dateFormatter = nil;
    
    return year;
}

#pragma mark - === UITableView Datasource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
        return [self.dicShortMeets.allKeys count];
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
        return [self.dicLongMeets.allKeys count];
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
        return [self.dicOpenMeets.allKeys count];
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
    {
        NSString *groupString = [self.aryShortMeetKeys objectAtIndex:section];
        
        NSMutableArray *aryMeets = [self.dicShortMeets objectForKey:groupString];
        
        return aryMeets.count;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
    {
        NSString *groupString = [self.aryLongMeetKeys objectAtIndex:section];
        
        NSMutableArray *aryMeets = [self.dicLongMeets objectForKey:groupString];
        
        return aryMeets.count;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
    {
        NSString *groupString = [self.aryOpenMeetKeys objectAtIndex:section];
        
        NSMutableArray *aryMeets = [self.dicOpenMeets objectForKey:groupString];
        
        return aryMeets.count;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *aryKeys = nil;
    if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
    {
        aryKeys = self.aryShortMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
    {
        aryKeys = self.aryLongMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
    {
        aryKeys = self.aryOpenMeetKeys;
    }
    
    NSString *groupString = [aryKeys objectAtIndex:section];
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tbvMeets.frame), 16);
    headerView.backgroundColor = [UIColor colorWithRed:224.0f / 255.0f green:224.0f / 255.0f blue:224.0f / 255.0f alpha:1.0f];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(20, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f];
    label.text = [NSString stringWithFormat:@"%@ Meets", groupString];
    
    [headerView addSubview:label];
    label = nil;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 80;
    
    return 66.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = MeetCellIdentifier;
    
    MYSMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSMutableDictionary *dicMeets = nil;
    NSMutableArray *aryKeys = nil;
    if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
    {
        dicMeets = self.dicShortMeets;
        aryKeys = self.aryShortMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
    {
        dicMeets = self.dicLongMeets;
        aryKeys = self.aryLongMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
    {
        dicMeets = self.dicOpenMeets;
        aryKeys = self.aryOpenMeetKeys;
    }
    
    NSString *groupString = [aryKeys objectAtIndex:indexPath.section];
    
    NSMutableArray *aryMeets = [dicMeets objectForKey:groupString];
    
    MYSMeet *meet = [aryMeets objectAtIndex:indexPath.row];
    [cell loadDataForCellWithMeet:meet];
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    return cell;
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dicMeets = nil;
    NSMutableArray *aryKeys = nil;
    if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
    {
        dicMeets = self.dicShortMeets;
        aryKeys = self.aryShortMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
    {
        dicMeets = self.dicLongMeets;
        aryKeys = self.aryLongMeetKeys;
    }
    else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
    {
        dicMeets = self.dicOpenMeets;
        aryKeys = self.aryOpenMeetKeys;
    }
    
    NSString *groupString = [aryKeys objectAtIndex:indexPath.section];
    
    NSMutableArray *aryMeets = [dicMeets objectForKey:groupString];
    
    MYSMeet *meet = [aryMeets objectAtIndex:indexPath.row];
    
    MYSMeetDetailsViewController *meetDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MYSMeetDetailsViewController class])];
    meetDetailsVC.meet = meet;
    [self.navigationController pushViewController:meetDetailsVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)// Delete cell
    {
        NSMutableDictionary *dicMeets = nil;
        if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Short)
        {
            dicMeets = self.dicShortMeets;
        }
        else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Long)
        {
            dicMeets = self.dicLongMeets;
        }
        else if(self.sgCourseType.selectedSegmentIndex == MYSCourseType_Open)
        {
            dicMeets = self.dicOpenMeets;
        }
        
        NSString *groupString = [dicMeets.allKeys objectAtIndex:indexPath.section];
        
        NSMutableArray *aryMeets = [dicMeets objectForKey:groupString];
        
        MYSMeet *meet = [aryMeets objectAtIndex:indexPath.row];
        
        [[MYSDataManager shared] deleteMeet:meet];
    
        [self loadMeetsData];
    }
}

#pragma mark - === Implement Action Methods ===
- (IBAction)onAddNewMeet:(id)sender
{
    [self performSegueWithIdentifier:@"newmeet" sender:nil];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChangeCourseType:(id)sender
{
    [self loadMeetsData];
}

@end
