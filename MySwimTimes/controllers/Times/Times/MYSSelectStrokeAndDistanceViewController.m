//
//  MYSSelectStrokeAndDistanceViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 10/1/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSSelectStrokeAndDistanceViewController.h"

#import "MYSSelectDistanceViewController.h"

@interface MYSSelectStrokeAndDistanceViewController ()<MYSSelectDistanceViewControllerDelegate>

@property (nonatomic, assign) IBOutlet UITextField *txtDistance;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_distance;

@property (nonatomic, assign) IBOutlet UILabel *lblStrokeName;

@property (nonatomic, assign) IBOutlet UIButton *btnFLY;
@property (nonatomic, assign) IBOutlet UIButton *btnBK;
@property (nonatomic, assign) IBOutlet UIButton *btnBR;
@property (nonatomic, assign) IBOutlet UIButton *btnFR;
@property (nonatomic, assign) IBOutlet UIButton *btnIM;

@end

@implementation MYSSelectStrokeAndDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtDistance.text = [NSString stringWithFormat:@"%.0f",self.distance];
    
    if ([self.txtDistance.text integerValue] > 0) {
        switch ([self.txtDistance.text integerValue]) {
            case 50: [self.segment_distance setSelectedSegmentIndex:0]; break;
            case 100: [self.segment_distance setSelectedSegmentIndex:1]; break;
            case 200: [self.segment_distance setSelectedSegmentIndex:2]; break;
            default: [self.segment_distance setSelectedSegmentIndex:3]; break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"selectdistance"])
    {
        MYSSelectDistanceViewController *vc = segue.destinationViewController;
        vc.distance = [self.txtDistance.text doubleValue];
        vc.delegate = self;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    self.distance = [self.txtDistance.text floatValue];
    
    if(self.distance < 10)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid distance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    [self.delegate doneSelectDistanceAndStroke:self.distance stroke:self.strokeIndex];
    
    [self onBack:nil];
}

- (IBAction)onSelectStroke:(id)sender
{
    if(self.isStaticStroke) return;
    
    int tag = ((UIButton *)sender).tag;
    
    self.strokeIndex = tag;
    
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [self performSegueWithIdentifier:@"selectdistance" sender:textField.text];
    
    return NO;
}

#pragma mark MYSSelectDistanceViewControllerDelegate

- (void) selectDistance:(double)distance
{
    if(distance == 33.3)
        self.txtDistance.text = [NSString stringWithFormat:@"%.1f", distance];
    else
        self.txtDistance.text = [NSString stringWithFormat:@"%.0f", distance];
}

- (IBAction)distanceSegmentSelected:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 3) {
        
        [self performSegueWithIdentifier:@"selectdistance" sender:self.txtDistance.text];
    }
    else {
        _txtDistance.text = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    }
}


@end
