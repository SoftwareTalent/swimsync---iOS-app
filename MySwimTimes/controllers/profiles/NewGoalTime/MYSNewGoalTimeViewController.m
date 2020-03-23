//
//  MYSNewGoalTimeViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/5/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSNewGoalTimeViewController.h"
#import "MYSLapViewController.h"
#import "UIAlertView+Blocks.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSChooseProfileViewController.h"

#import "MYSLapViewController.h"
#import "MYSSelectDistanceViewController.h"


@interface MYSNewGoalTimeViewController ()<MYSChooseProfileViewControllerDelegate, MYSSelectDistanceViewControllerDelegate>
{
    int64_t _newTimeForShort;
    int64_t _newTimeForLong;
}

@property (nonatomic, assign) IBOutlet UIButton *btnFLY;
@property (nonatomic, assign) IBOutlet UIButton *btnBK;
@property (nonatomic, assign) IBOutlet UIButton *btnBR;
@property (nonatomic, assign) IBOutlet UIButton *btnFR;
@property (nonatomic, assign) IBOutlet UIButton *btnIM;

- (IBAction)distanceSegmentSelected:(UISegmentedControl*)sender;
@property (nonatomic, assign) IBOutlet UISegmentedControl *sgCourseType;

@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (weak, nonatomic) IBOutlet UITextField *txtDistance;

@property (weak, nonatomic) IBOutlet UITextField *txtTime;

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

@end

@implementation MYSNewGoalTimeViewController

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
    
    [self initView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"selectswimmer"])
    {
        MYSChooseProfileViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"selectdistance"])
    {
        MYSSelectDistanceViewController *vc = segue.destinationViewController;
        vc.distance = [self.txtDistance.text doubleValue];
        vc.delegate = self;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadSelectedSwimmerData];
}

- (void) initView
{
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 70.0f);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwimmerView:)];
    [self.swimmerView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self.view addSubview:self.swimmerView];
}

- (void) tapSwimmerView:(UITapGestureRecognizer *)tapGesture
{
    if(self.isEditing) return;
    
    [self performSegueWithIdentifier:@"selectswimmer" sender:nil];
}

- (void) loadSelectedSwimmerData
{
    if(self.swimmer == nil)
        return;
    
    self.swimmerView.ivProfile.image = [UIImage imageWithData:self.swimmer.image];
    
    self.swimmerView.lblUserName.text = self.swimmer.name;
    self.swimmerView.lblClub.text = self.swimmer.nameSwimClub;
    self.swimmerView.lblLocation.text = [NSString stringWithFormat:@"%@, %@", self.swimmer.city, self.swimmer.country];
    self.swimmerView.lblYear.text = [NSString stringWithFormat:@"%.0f years",[MethodHelper countYearOld2:self.swimmer.birthday]];
    
    [self updateUI];
}

- (IBAction)onSelectStroke:(id)sender
{
    if(self.isEditing) return;
    
    NSInteger tag = ((UIButton *)sender).tag;
    
    self.stroke = tag;
    
    [self updateUI];
}

- (void) updateUI
{
    self.btnFLY.selected = (self.stroke == 0);
    self.btnBK.selected = (self.stroke == 1);
    self.btnBR.selected = (self.stroke == 2);
    self.btnFR.selected = (self.stroke == 3);
    self.btnIM.selected = (self.stroke == 4);
    
    if(self.stroke == 0)
    {
        self.lblStrokeName.text = @"Butterfly";
        
    }
    else if(self.stroke == 1)
    {
        self.lblStrokeName.text = @"Backstroke";
    }
    else if(self.stroke == 2)
    {
        self.lblStrokeName.text = @"Breaststroke";
    }
    else if(self.stroke == 3)
    {
        self.lblStrokeName.text = @"Freestyle";
    }
    else if(self.stroke == 4)
    {
        self.lblStrokeName.text = @"Individual medley";
    }
    
    if(self.isEditing)
    {
        self.txtDistance.text = [NSString stringWithFormat:@"%d", (int)self.distance];
        
        MYSGoalTime *goldTime = nil;
        if(self.sgCourseType.selectedSegmentIndex == 0)
        {
            goldTime = [[MYSDataManager shared] getGoalTimeOfProfile:self.swimmer withCourse:MYSCourseType_Short stroke:self.stroke distance:self.distance];
            
            if(_newTimeForShort > 0)
            {
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:_newTimeForShort withMinimumFormat:YES];
            }
            else
            {
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[goldTime.time integerValue] withMinimumFormat:YES];
            }
        }
        else
        {
            goldTime = [[MYSDataManager shared] getGoalTimeOfProfile:self.swimmer withCourse:MYSCourseType_Long stroke:self.stroke distance:self.distance];
            
            if(_newTimeForLong > 0)
            {
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:_newTimeForLong withMinimumFormat:YES];
            }
            else
            {
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:[goldTime.time integerValue] withMinimumFormat:YES];
            }
        }
    }
    else
    {
        if(self.sgCourseType.selectedSegmentIndex == 0)
        {
            if(_newTimeForShort > 0)
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:_newTimeForShort withMinimumFormat:NO];
            else
                self.txtTime.text = @"";
        }
        else
        {
            if(_newTimeForLong > 0)
                self.txtTime.text = [MYSLap getSplitTimeStringFromMiliseconds:_newTimeForLong withMinimumFormat:NO];
            else
                self.txtTime.text = @"";
        }
    }
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChangeCourseType:(id)sender
{
    [self updateUI];
}

- (IBAction)onDone:(id)sender
{
    CGFloat distance = [self.txtDistance.text floatValue];
    float time = [MYSLap milisecondsFromLapTime:_txtTime.text];
    if (!(distance > 0)) {
        [UIAlertView showWithTitle:@"" message:@"Distance must be larger than zero." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    if (!(time >  0)) {
        [UIAlertView showWithTitle:@"" message:@"Time must be larger than zero." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }

    MYSCourseType courseType = self.sgCourseType.selectedSegmentIndex;
    
    MYSGoalTime *goldTime = [[MYSDataManager shared] getGoalTimeOfProfile:self.swimmer withCourse:courseType stroke:self.stroke distance:self.distance];
    
    if(!self.isEditing || goldTime == nil)
    {
        // Save goal time data
        MYSGoalTime *goalTime = [[MYSDataManager shared] insertGoalTimeWithProfile:self.swimmer time:time course:courseType stroke:self.stroke distance:distance];
        
        [self.swimmer addGoaltimeObject:goalTime];
        [[MYSDataManager shared] save];
    }
    else
    {
        goldTime.time = [NSNumber numberWithLongLong:time];
        
        [[MYSDataManager shared] save];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) gotoInputTimeScreen
{
    MYSLapViewController *lapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSLapViewController"];
    int64_t t = [MYSLap milisecondsFromLapTime:self.txtTime.text];
    [lapVC setAddNewTime:YES];
    [lapVC setTimeValue:t];
    [lapVC setTimeValueChangedBlock:^(int64_t timeValue)
     {
         if(self.sgCourseType.selectedSegmentIndex == 0)
             _newTimeForShort = timeValue;
         else
             _newTimeForLong = timeValue;
     }];
    
    [self.navigationController pushViewController:lapVC animated:YES];
}

#pragma mark MYSChooseSwimmerViewControllerDelegate

- (void) chooseProfile:(MYSProfile *) profile
{
    self.swimmer = profile;
}

#pragma mark - == UITextField Delegate ===

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.txtTime == textField)
    {
        [self gotoInputTimeScreen];
        
        return NO;
    }
    if(self.txtDistance == textField)
    {
//         if(!self.isEditing)
//         {
//             [self performSegueWithIdentifier:@"selectdistance" sender:textField.text];
//         }
        
        return NO;
    }
    
    return YES;
}

#pragma mark MYSSelectDistanceViewControllerDelegate

- (void) selectDistance:(double)distance
{
    if(distance == 33.3)
        self.txtDistance.text = [NSString stringWithFormat:@"%.1f", distance];
    else
        self.txtDistance.text = [NSString stringWithFormat:@"%.0f", distance];
}

- (IBAction)distanceSegmentSelected:(UISegmentedControl*)sender {
    //    [_sgDistance setHidden:YES];
    
    if (sender.selectedSegmentIndex == 3) {
        
        [self performSegueWithIdentifier:@"selectdistance" sender:self.txtDistance.text];
    }
    else {
        _txtDistance.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    }
    
//    [self refreshLapTimes];
}

@end
