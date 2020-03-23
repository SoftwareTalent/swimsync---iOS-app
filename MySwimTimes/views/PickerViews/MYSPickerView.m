//
//  MYSPickerView.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/24/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSPickerView.h"

static float const kDefaultPickerHeight = 162;
static float const kDefaultViewHeight  = 206;
static float const kAnimationDuration = 0.3f;

@interface MYSPickerView () {
    NSArray *changeColumn;
    UIToolbar *toolbar;
    CGSize screenSize;
    int currentChangeIndex;
    NSMutableArray *currentData;
    int numberOfComponent;
    
    UIButton *_btnExit;
    
    UIView *_dialogView;
}

@end

@implementation MYSPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        screenSize = [UIScreen mainScreen].bounds.size;
        
        _dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height - kDefaultViewHeight, screenSize.width, kDefaultViewHeight)];
        _dialogView.backgroundColor = [UIColor whiteColor];
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setFrame:CGRectMake(CGRectGetWidth(frame) - 65, 6, 60, 32)];
        [_btnLeft setFrame:CGRectMake(5, 6, 60, 32)];
        [_btnLeft setTitle:MTLocalizedString(@"Cancel") forState:UIControlStateNormal];
        [_btnRight setTitle:MTLocalizedString(@"Done") forState:UIControlStateNormal];
        [_btnLeft addTarget:self action:@selector(didPressCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRight addTarget:self action:@selector(didPressDone:) forControlEvents:UIControlEventTouchUpInside];
        [_btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, kDefaultPickerHeight)];
        _datePicker = [[UIDatePicker alloc] initWithFrame:_pickerView.frame];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.hidden = YES;
        
        _pickerTitle = [[UILabel alloc] initWithFrame:toolbar.frame];
        [_pickerTitle setTextAlignment:NSTextAlignmentCenter];
        [_pickerTitle setTextColor:[UIColor blackColor]];
        [_pickerTitle setBackgroundColor:[UIColor clearColor]];
        
        // Create invi button to handle user touch outside the picker
        _btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnExit.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_btnExit addTarget:self action:@selector(didPressExit:) forControlEvents:UIControlEventTouchDown];
        [_btnExit setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_btnExit];
        [self addSubview:_dialogView];
        
        [_dialogView addSubview:toolbar];
        [_dialogView addSubview:_pickerTitle];
        [_dialogView addSubview:_btnRight];
        [_dialogView addSubview:_btnLeft];
        [_dialogView addSubview:_pickerView];
        [_dialogView addSubview:_datePicker];
        
        self.hidden = YES;
        _isShowing = NO;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id) init {
    screenSize = [UIScreen mainScreen].bounds.size;
    return [self initWithFrame:CGRectMake(0, screenSize.height, screenSize.width, screenSize.height)];
}

#pragma mark - Action methods

- (void)didPressExit:(id)sender {
    [self didPressCancel:sender];
}

- (IBAction)didPressCancel:(id)sender {
    [self hidePicker];
}


- (IBAction)didPressDone:(id)sender {
    [self hidePicker];
}

- (void) showPickerInView:(UIView *)view {
    [view addSubview:self];
    self.frame = CGRectMake(0, screenSize.height, self.frame.size.width, screenSize.height);
    self.hidden = NO;
    _isShowing = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, screenSize.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hidePicker{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = CGRectMake(0, screenSize.height, self.frame.size.width, screenSize.height);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _isShowing = NO;
        [self removeFromSuperview];
    }];
}

@end
