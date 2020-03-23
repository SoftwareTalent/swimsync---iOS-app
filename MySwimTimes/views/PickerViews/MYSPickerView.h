//
//  MYSPickerView.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/24/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^PickerViewDoneBlock)(MYSPickerView *picker, NSInteger selectedIndex, id selectedValue);
//typedef void(^PickerViewCancelBlock)(MYSPickerView *picker);

@interface MYSPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UILabel *pickerTitle;

@property (readonly, strong) NSArray *data;
@property (readonly, strong) NSDate *date;
@property (readonly) BOOL isShowing;

// Action method, should be used on subclass only
- (IBAction)didPressDone:(id)sender;
- (IBAction)didPressCancel:(id)sender;

- (void) showPickerInView:(UIView *)view;
- (void) hidePicker;

@end
