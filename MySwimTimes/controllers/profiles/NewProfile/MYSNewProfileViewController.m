//
//  MYSNewProfileViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSNewProfileViewController.h"

#import "MYSDatePickerView.h"
#import "MYSGoalTimeInfo.h"
#import "UIImage+FixOrientation.h"

typedef NS_ENUM(NSUInteger, NewProfileTableViewSection)
{
    ImageSection,
    NewProfileSection,
    SwimClubInfoSection,
    //    GoalTimeSection,
    
    TOTAL_NEW_PROFILE_SECTION
};

@interface MYSNewProfileViewController ()<MYSSwimClubCellDelegate, MYSNewProfileCellDelegate, MYSProfileImageCellDelegate, FDTakeDelegate>
{
    MYSDatePickerView *_datePicker;
}

@property (strong, nonatomic) MYSProfileInfo* profileInfo;

@property (strong, nonatomic) FDTakeController *takeController;

@property (strong, nonatomic) IBOutlet UITableView *tbvProfile;

@end

@implementation MYSNewProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _datePicker = [[MYSDatePickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 162)];
    
    if (!_isEdit)
    {
        _profileInfo = [[MYSProfileInfo alloc] init];
        _profileInfo.image = [UIImage imageNamed:@"no_image.jpeg"];
        _profileInfo.goalTimes = [[NSMutableArray alloc] init];
    }
    else
    {
        _profileInfo = [MYSProfileInfo profileInfoFromProfile:self.profile];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tbvProfile reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - === UITableView Datasource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TOTAL_NEW_PROFILE_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case ImageSection:
            return 1;
            
        case NewProfileSection:
            return 1;
            
        case SwimClubInfoSection:
            return 1;
            
//        case GoalTimeSection:
//            return _profileInfo.goalTimes.count + 1;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 40.0f;
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0 ) return nil;
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tbvProfile.frame), 40.0f);
    headerView.backgroundColor = [UIColor colorWithRed:112.0f / 255.0f green:181.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    label.text = @"New swimmer profile";
    
    [headerView addSubview:label];
    label = nil;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ImageSection)
    {
        static NSString *cellIdentifier = MYSProfileImageCellIdentifier;
        MYSProfileImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[MYSProfileImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.delegate = self;
        
        if (_profileInfo != nil)
        {
            cell.imgProfile.image = _profileInfo.image;
            CALayer * l = [cell.imgProfile layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:kCornerRadius];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == NewProfileSection)
    {
        // profile info
        static NSString *cellIdentifier = NewProfileCellIdentifier;
        MYSNewProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[MYSNewProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.delegate = self;
        
        if (_profileInfo != nil)
        {
            [cell loadDataToViewWithProfile:_profileInfo];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == SwimClubInfoSection)
    {
        // swim clun info
        MYSSwimClubCell *cell = [tableView dequeueReusableCellWithIdentifier:SwimClubCellIdentifier];
        
        if (cell == nil) {
            cell = [[MYSSwimClubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwimClubCellIdentifier];
        }
        
        cell.delegate = self;
        
        if (_profileInfo != nil)
        {
            [cell loadDataToViewWithProfile:_profileInfo];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
//    else {
//        if (indexPath.row == _profileInfo.goalTimes.count) {
//            // Add new lap cell
//            static NSString *cellIdentifier = @"NewCellIdentifier";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            }
//            cell.textLabel.text = MTLocalizedString(@"New Goal Time");
//            
//            return cell;
//            
//        } else {
//            // Goal Time Cell
//            MYSGoalTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:MYSGoalTimeCellIdentifier];
//            
//            if (cell == nil) {
//                cell = [[MYSGoalTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MYSGoalTimeCellIdentifier];
//            }
//            
//            [cell loadDataToViewWithGoalTime:_profileInfo.goalTimes[indexPath.row]];
//            
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//            
//            return cell;
//        }
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (indexPath.section == ImageSection)
        {
            return 80;
        }
        else if (indexPath.section == NewProfileSection)
        {
            return 150;
        }
        else if (indexPath.section == SwimClubInfoSection)
        {
            return 150;
        }
        //    else
        //    {
        //        return 70;
        //    }
    }
    else
    {
        if (indexPath.section == ImageSection)
        {
            return 71;
        }
        else if (indexPath.section == NewProfileSection)
        {
            return 111;
        }
        else if (indexPath.section == SwimClubInfoSection)
        {
            return 111;
        }
        //    else
        //    {
        //        return 51;
        //    }
    }
    
    return 0;
}

#pragma mark - === UITableView Delegate methods ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (IBAction)pressedBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressedDoneButton:(id)sender
{
    if (![self validate]) {
        return;
    }
    
    if (_isEdit)
    {
        [[MYSDataManager shared] editProfile:_profile withProfileInfo:_profileInfo];
    }
    else
    {
        _profileInfo.userId = [[NSDate date] timeIntervalSince1970];
        
        [[MYSDataManager shared] insertProfile:_profileInfo];
    }
    
    // Select profile if this is first profile
    NSString* profile = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentProfile];
//    NSString* profile = [[[MYSAppData sharedInstance] appInstructor] currentProfile];
    
    if (profile == nil || [profile isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",_profileInfo.userId] forKey:kCurrentProfile];
//        [[[MYSAppData sharedInstance] appInstructor] setCurrentProfile:[NSString stringWithFormat:@"%ld",_profileInfo.userId]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validate
{
    if (_profileInfo.name == nil || [_profileInfo.name isEqualToString:@""])
    {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"INPUT_NAME_SWIM_NAME", nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
        return NO;
    }
    
    return YES;
}

- (void)didEnteredProfileName:(NSString *)name {
    _profileInfo.name = name;
}

- (void)didChooseGender:(int)gender {
    _profileInfo.gender = gender;
}

- (void) pressedBirthdayButton:(UIButton*)button {
    // Set selected for start date button
    button.selected = YES;
    NSDate *bDate = [NSDate date];
    if (_profileInfo.birthday != nil) {
        bDate = [MethodHelper getDateFullMonth:_profileInfo.birthday];
    } else {
        if (_profile != nil) {
            bDate = _profile.birthday;
        }
    }
    _datePicker.datePicker.maximumDate = [NSDate date];
    [_datePicker showDatePickerViewInView:self.tabBarController.view mode:UIDatePickerModeDate selectedDate:bDate title:MTLocalizedString(@"Birthday") changeValueBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        // don't need update here
    } doneBlock:^(MYSDatePickerView *picker, NSDate *selectedDate) {
        
        NSString *date = [MethodHelper convertFullMonth:selectedDate];
        
        [button setTitle:date forState:UIControlStateNormal];
        
        button.selected = NO;
        
        _profileInfo.birthday = date;
    } cancelBlock:^(MYSDatePickerView *picker) {
        
        button.selected = NO;
        
    }];
}

- (void)didEnteredCity:(NSString *)city {
    _profileInfo.city = city;
}

- (void)didEnteredCountry:(NSString *)country {
    _profileInfo.country = country;
}

- (void)didEnteredNameSwimClub:(NSString *)name {
    _profileInfo.nameSwimClub = name;
}

- (void)pressedChooImageButton {
    _takeController = [[FDTakeController alloc] init];
    _takeController.delegate = self;
    _takeController.allowsEditingPhoto = YES;
    [_takeController takePhotoOrChooseFromLibrary];
}

#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
    /*
    UIAlertView *alertView;
    if (madeAttempt)
        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled after selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled without selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
     */
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    _profileInfo.image = [[UIImage imageWithData:UIImageJPEGRepresentation(photo, 0.2)] scaleToSize:CGSizeMake(200.0, 200.0)];
    [self.tbvProfile reloadData];
}

@end
