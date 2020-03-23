//
//  MYSLapViewController.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/12/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This controller is used for entering time values such as in lap time, goal time and qualifying time.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MYSEnterTimeControllerStyle) {
    MYSEnterTimeControllerStyleAddLap = 0,
    MYSEnterTimeControllerStyleEditLap,
    MYSEnterTimeControllerStyleSetTime,
    MYSEnterTimeControllerStyleEditTime,
};


@class WTReTextField;

typedef void(^TimeValueChanged)(int64_t timeValue);
typedef void(^AddNewTimeBlock)(int64_t milisecondsValue);

@interface MYSLapViewController : UIViewController

@property (nonatomic) MYSEnterTimeControllerStyle style;
/**
 Time value
 */
@property (nonatomic, assign) int64_t timeValue;

@property (nonatomic, getter = isAddNewTime) BOOL addNewTime;

@property (nonatomic) BOOL isEnterTime;

// Text view lap time
//@property (weak, nonatomic) IBOutlet WTReTextField *tvLapTime;

@property (nonatomic, assign) IBOutlet UITextField *txtHours;
@property (nonatomic, assign) IBOutlet UITextField *txtMins;
@property (nonatomic, assign) IBOutlet UITextField *txtSeconds;
@property (nonatomic, assign) IBOutlet UITextField *txtMiliSeconds;



/**
 Set time value changed block
 */
- (void) setTimeValueChangedBlock:(TimeValueChanged) timeValueChangeBlock;

/**
 Set add new time block. Called when user tapped on new time block
 */
- (void) setAddNewTimeBlock:(AddNewTimeBlock) addNewTimeBlock;

@end
