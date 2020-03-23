//
//  MYSLapViewController.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSLapViewController.h"

// ThirdParty
#import "WTReTextField.h"
#import "UIAlertView+Blocks.h"

#define MSEC_PER_SEC    1000L
#define SEC_PER_MIN     60
#define MIN_PER_HOUR    60
#define HOUR_PER_DAY    24

@interface MYSLapViewController () <UITextFieldDelegate>

@property (nonatomic, copy) TimeValueChanged timeValueChanged;

@property (nonatomic, copy) AddNewTimeBlock aAddNewTimeBlock;

/**
 Add button
 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation MYSLapViewController {
    int64_t aDay;
    int64_t aHour;
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

    aDay = HOUR_PER_DAY * MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC;
    aHour = MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC;
    
    int hours = (int)(_timeValue / (MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC));
    int64_t otherTime = _timeValue - hours * (MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC);
    
    int mins = (int)(otherTime / (SEC_PER_MIN * MSEC_PER_SEC));
    otherTime = otherTime - mins * (SEC_PER_MIN * MSEC_PER_SEC);
    
    int seconds = (int)(otherTime / MSEC_PER_SEC);
    otherTime = otherTime - seconds * MSEC_PER_SEC;
    
    int mileseconds = (int)(otherTime / 10);
    
    self.txtHours.text = [NSString stringWithFormat:@"%02d", hours];
    self.txtMins.text = [NSString stringWithFormat:@"%02d", mins];
    self.txtSeconds.text = [NSString stringWithFormat:@"%02d", seconds];
    self.txtMiliSeconds.text = [NSString stringWithFormat:@"%02d", mileseconds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTimeValue:(int64_t)timeValue {
    _timeValue = timeValue;
}

-(void)setTimeValueChangedBlock:(TimeValueChanged)timeValueChangeBlock
{
    self.timeValueChanged = timeValueChangeBlock;
}

-(void)setAddNewTimeBlock:(AddNewTimeBlock)addNewTimeBlock
{
    self.aAddNewTimeBlock = addNewTimeBlock;
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonTapped:(id)sender
{
    int64_t time = [MYSLap milisecondsFromLapTime:[self getCurrentEditedValue]];
    if (_aAddNewTimeBlock || _timeValueChanged) {
        if (_isEnterTime == NO) {
            if (!(time > 0)) {
                [UIAlertView showWithTitle:nil message:@"Time must be larger than zero." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
                return;
            }
        }
        
        if(self.aAddNewTimeBlock)_aAddNewTimeBlock(time);
        if(self.timeValueChanged)self.timeValueChanged(time);
    }
    
    [self onBack:nil];
}

-(void)setAddNewTime:(BOOL)addNewTime
{
    _addNewTime = addNewTime;
//    if (_addNewTime == NO)
//    {
//        [self.navigationItem setRightBarButtonItem:nil];
//    }
}

- (NSString *) getCurrentEditedValue
{
    int hours = [self.txtHours.text intValue];
    int mins = [self.txtMins.text intValue];
    int seconds = [self.txtSeconds.text intValue];
    int miliseconds = [self.txtMiliSeconds.text intValue];
    
    NSString *currentEditedValue = [NSString stringWithFormat:@"%02d:%02d:%02d.%02d", hours, mins, seconds, miliseconds];
    
    return currentEditedValue;
}

- (IBAction)onChangedText:(id)sender
{
    UITextField *txtField = (UITextField *)sender;
    
    if(txtField == self.txtHours)
    {
        if(self.txtHours.text.length == 2)
        {
            [self.txtMins becomeFirstResponder];
        }
        else if(self.txtHours.text.length == 0)
        {
            
        }
    }
    else if(txtField == self.txtMins)
    {
        if(self.txtMins.text.length == 2)
        {
            [self.txtSeconds becomeFirstResponder];
        }
        else if(self.txtMins.text.length == 0)
        {
            [self.txtHours becomeFirstResponder];
        }
        else if([self.txtMins.text intValue] > 5)
        {
            [self.txtSeconds becomeFirstResponder];
        }
    }
    else if(txtField == self.txtSeconds)
    {
        if(self.txtSeconds.text.length == 2)
        {
            [self.txtMiliSeconds becomeFirstResponder];
        }
        else if(self.txtSeconds.text.length == 0)
        {
            [self.txtMins becomeFirstResponder];
        }
        else if([self.txtSeconds.text intValue] > 5)
        {
            [self.txtMiliSeconds becomeFirstResponder];
        }
    }
    else if(txtField == self.txtMiliSeconds)
    {
        if(self.txtMiliSeconds.text.length == 0)
        {
            [self.txtSeconds becomeFirstResponder];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
        return YES;
    
    if(textField == self.txtMins || textField == self.txtSeconds)
    {
        NSString *newValue = [NSString stringWithFormat:@"%@%@", textField.text, string];
        int newValueInt = [newValue intValue];
        
        if(newValueInt >= 60)
        {
            return NO;
        }
    }
    else if(textField == self.txtHours || textField == self.txtMiliSeconds)
    {
        if(textField.text.length >= 2)
            return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    int value = [textField.text intValue];
    
    textField.text = [NSString stringWithFormat:@"%2d", value];
    
    return YES;
}

@end
