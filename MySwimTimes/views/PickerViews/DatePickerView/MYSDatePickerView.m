//
//  MYSDatePickerView.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/25/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSDatePickerView.h"

@interface MYSDatePickerView ()

@property (nonatomic, copy) PickerViewDoneBlock doneBlock;

@property (nonatomic, copy) PickerViewCancelBlock cancelBlock;

@property (nonatomic, copy) PickerViewChangeValueBlock changeValueBlock;

@end

@implementation MYSDatePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pickerView.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.frame = CGRectMake(0, 44, CGRectGetWidth(frame), 162);
        [self.datePicker addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        self.pickerView.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.frame = CGRectMake(0, 44, 320, 162);
        [self.datePicker addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)didPressCancel:(id)sender {
    if (_cancelBlock) {
        _cancelBlock(self);
    }
    _cancelBlock = nil;
    _changeValueBlock = nil;
    
    [self hidePicker];
}

-(void)didPressDone:(id)sender {
    if (_doneBlock) {
        _doneBlock(self, self.datePicker.date);
    }
    _doneBlock = nil;
    _changeValueBlock = nil;
    
    [self hidePicker];
}

- (IBAction)didChangeValue:(id)sender
{
    if (_changeValueBlock) {
        UIDatePicker *picker = sender;
        _changeValueBlock(self, picker.date);
    }
}

-(void)showDatePickerViewInView:(UIView *)view mode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate title:(NSString *)title doneBlock:(PickerViewDoneBlock)pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock)pickerViewCancelBlock {
    
    [self.datePicker setDatePickerMode:datePickerMode];
    
    if (selectedDate) {
        [self.datePicker setDate:selectedDate animated:YES];
    } else {
        [self.datePicker setDate:[NSDate date] animated:YES];
    }
    
    _changeValueBlock = nil;
    
    self.pickerTitle.text = title;
    
    self.doneBlock = pickerViewDoneBlock;
    
    self.cancelBlock = pickerViewCancelBlock;
    
    [self showPickerInView:view];
}

- (void) showDatePickerViewInView:(UIView *) view mode:(UIDatePickerMode) datePickerMode selectedDate:(NSDate *) selectedDate title:(NSString *) title changeValueBlock:(PickerViewChangeValueBlock)pickerChangeValueBlock doneBlock:(PickerViewDoneBlock) pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock) pickerViewCancelBlock
{
    [self.datePicker setDatePickerMode:datePickerMode];
    
    if (selectedDate) {
        [self.datePicker setDate:selectedDate animated:YES];
    } else {
        [self.datePicker setDate:[NSDate date] animated:YES];
    }
    
    self.pickerTitle.text = title;
    
    self.doneBlock = pickerViewDoneBlock;
    
    self.cancelBlock = pickerViewCancelBlock;
    
    self.changeValueBlock = pickerChangeValueBlock;
    
    [self showPickerInView:view];
}

- (void)updateDate:(NSDate *)date andTitle:(NSString *)title doneBlock:(PickerViewDoneBlock) pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock) pickerViewCancelBlock
{
    if (date) {
        [self.datePicker setDate:date animated:YES];
    } else {
        [self.datePicker setDate:[NSDate date] animated:YES];
    }
    
    self.pickerTitle.text = title;
    
    self.doneBlock = pickerViewDoneBlock;
    
    self.cancelBlock = pickerViewCancelBlock;
}
@end
