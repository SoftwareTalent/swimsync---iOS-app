//
//  MYSSelectDistanceViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 11/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSSelectDistanceViewController.h"

@interface MYSSelectDistanceViewController ()

@property (nonatomic, assign) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) IBOutlet UITextField *txtCustomDistance;

@property (nonatomic, assign) IBOutlet UISwitch *swtCustomDistance;

@property (nonatomic, retain) NSArray *aryDistance;

@end

@implementation MYSSelectDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.aryDistance = @[@"25", @"33.3", @"50", @"100", @"200", @"400", @"800", @"1500", @"5000", @"10000"];
    
    [self.pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initView];
}

- (void) initView
{
    self.swtCustomDistance.on = NO;
    
    if(self.distance > 0)
    {
        if(self.distance == 33.3)
        {
            [self.pickerView selectRow:1 inComponent:0 animated:NO];
        }
        else
        {
            NSInteger index = [self.aryDistance indexOfObject:[NSString stringWithFormat:@"%d", (int)self.distance]];
            
            if(index == NSNotFound)
            {
                [self.pickerView selectRow:2 inComponent:0 animated:NO];
                
                self.txtCustomDistance.text = [NSString stringWithFormat:@"%d", (int)self.distance];
                self.swtCustomDistance.on = YES;
            }
            else
            {
                [self.pickerView selectRow:index inComponent:0 animated:NO];
            }
        }
        
    }
    else
    {
        [self.pickerView selectRow:2 inComponent:0 animated:NO];
    }
    
    self.txtCustomDistance.hidden = !self.swtCustomDistance.on;
    self.pickerView.hidden = self.swtCustomDistance.on;
}

- (IBAction)onBack:(id)sender
{
    if ([self.txtCustomDistance isFirstResponder]) [self.txtCustomDistance resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    NSString *sDistance = nil;
    
    if(self.swtCustomDistance.on)
    {
        sDistance = self.txtCustomDistance.text;
    }
    else
    {
        sDistance = self.aryDistance[[self.pickerView selectedRowInComponent:0]];
    }
    
    double distance = [sDistance doubleValue];
    
    if(distance < 25)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid distance" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    [self.delegate selectDistance:[sDistance doubleValue]];
    
    [self onBack:nil];
}

- (IBAction)onChangeCustomeDistanceSelection:(id)sender
{
    self.txtCustomDistance.hidden = !self.swtCustomDistance.on;
    self.pickerView.hidden = self.swtCustomDistance.on;
}

#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.aryDistance.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *distanceWithComma = [MYSDataManager numberStringWithCommna:[self.aryDistance[row] doubleValue]];
    
    return distanceWithComma;
}

@end
