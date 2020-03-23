//
//  MYSReactionChartOptionViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/7/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSReactionChartOptionViewController.h"

#import "MeetDetailSwimmerHeaderView.h"

#import "MYSChooseProfileViewController.h"

@interface MYSReactionChartOptionViewController ()<MYSChooseProfileViewControllerDelegate>

@property (nonatomic, strong) MeetDetailSwimmerHeaderView *swimmerView;

@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (nonatomic, assign) IBOutlet UIButton *btnFLY;
@property (nonatomic, assign) IBOutlet UIButton *btnBK;
@property (nonatomic, assign) IBOutlet UIButton *btnBR;
@property (nonatomic, assign) IBOutlet UIButton *btnFR;
@property (nonatomic, assign) IBOutlet UIButton *btnIM;

@property (nonatomic, assign) IBOutlet UITextField *txtNumberOfTimes;

@property (nonatomic, assign) IBOutlet UISwitch *swtAnotherSwimmer;
@property (nonatomic, assign) IBOutlet UITextField *txtAnotherSwimmer;

@property (nonatomic, assign) IBOutlet UISwitch *swtShowPB;

@property (nonatomic, assign) IBOutlet UISwitch *swtAnotherStroke;
@property (nonatomic, assign) IBOutlet UITextField *txtAnotherStroke;

@property (nonatomic, assign) IBOutlet UISwitch *swtCustomTimeLine;
@property (nonatomic, assign) IBOutlet UITextField *txtCustomTimeLine;

@end

@implementation MYSReactionChartOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self loadSelectedSwimmerData];
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
    
}

- (void) _initView
{
    self.swimmerView = [[[NSBundle mainBundle] loadNibNamed:@"MeetDetailSwimmerHeaderView" owner:self options:nil] objectAtIndex:0];
    self.swimmerView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 70.0f);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwimmerView:)];
    [self.swimmerView addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self.view addSubview:self.swimmerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexibleButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(closeKeyboard)];
    [doneButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                              forState:UIControlStateNormal];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexibleButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    
    [self.txtNumberOfTimes setInputAccessoryView:toolbar];
}

- (void) tapSwimmerView:(UITapGestureRecognizer *)tapGesture
{
    MYSChooseProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MYSChooseProfileViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) closeKeyboard
{
    [self.txtNumberOfTimes resignFirstResponder];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectStroke:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    
    self.strokeIndex = (int)tag;
    
    [self updateUI];
}

- (void) updateUI
{
    self.btnFLY.selected = (self.strokeIndex == 0);
    self.btnBK.selected = (self.strokeIndex == 1);
    self.btnBR.selected = (self.strokeIndex == 2);
    self.btnFR.selected = (self.strokeIndex == 3);
    self.btnIM.selected = (self.strokeIndex == 4);
    
    if(self.strokeIndex == 0)
    {
        self.lblStrokeName.text = @"Butterfly";
        
    }
    else if(self.strokeIndex == 1)
    {
        self.lblStrokeName.text = @"Backstroke";
    }
    else if(self.strokeIndex == 2)
    {
        self.lblStrokeName.text = @"Breaststroke";
    }
    else if(self.strokeIndex == 3)
    {
        self.lblStrokeName.text = @"Freestyle";
    }
    else if(self.strokeIndex == 4)
    {
        self.lblStrokeName.text = @"Individual medley";
    }
}

#pragma mark MYSChooseSwimmerViewControllerDelegate

- (void) chooseProfile:(MYSProfile *) profile
{
    self.swimmer = profile;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.txtNumberOfTimes == textField)
        return YES;
    
    if(self.txtAnotherSwimmer == textField)
    {
        
    }
    else if(self.txtAnotherStroke == textField)
    {
        
    }
    else if(self.txtCustomTimeLine == textField)
    {
        
    }
    
    return NO;
}

@end
