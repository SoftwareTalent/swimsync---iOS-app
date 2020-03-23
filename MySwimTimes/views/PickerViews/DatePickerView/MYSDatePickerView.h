//
//  MYSDatePickerView.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/25/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSPickerView.h"
@class MYSDatePickerView;

typedef void(^PickerViewDoneBlock)(MYSDatePickerView *picker, NSDate *selectedDate);
typedef void(^PickerViewCancelBlock)(MYSDatePickerView *picker);

typedef void(^PickerViewChangeValueBlock)(MYSDatePickerView *picker, NSDate *selectedDate);

@interface MYSDatePickerView : MYSPickerView

/**
 Show date picker view
 
 @param view view will add picker view
 
 @param datePickerMode date picker mode
 
 @param selectedDate selected date. Default is current date
 
 @param title title will show in toolbar
 
 @param pickerViewDoneBlock block will be called when user pressed done button
 
 @param pickerViewCancelBlock block will be called when user pressed cancel button or invisible exit button
 */
- (void) showDatePickerViewInView:(UIView *) view mode:(UIDatePickerMode) datePickerMode selectedDate:(NSDate *) selectedDate title:(NSString *) title doneBlock:(PickerViewDoneBlock) pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock) pickerViewCancelBlock;

- (void) showDatePickerViewInView:(UIView *) view mode:(UIDatePickerMode) datePickerMode selectedDate:(NSDate *) selectedDate title:(NSString *) title changeValueBlock:(PickerViewChangeValueBlock)pickerChangeValueBlock doneBlock:(PickerViewDoneBlock) pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock) pickerViewCancelBlock;

- (void)updateDate:(NSDate *)date andTitle:(NSString *)title doneBlock:(PickerViewDoneBlock) pickerViewDoneBlock cancelBlock:(PickerViewCancelBlock) pickerViewCancelBlock;
@end
