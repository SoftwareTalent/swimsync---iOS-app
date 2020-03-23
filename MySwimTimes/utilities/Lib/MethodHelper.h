//
//  MethodHelper.h
//
//  Created by Cliff Viegas on 12/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

// Macro wrapper for NSLog only if debug mode has been enabled
#ifdef DEBUG
#define DebugLog(fmt,...) NSLog(@"%@",[NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
// If debug mode hasn't been enabled, don't do anything when the macro is called
#define DebugLog(...)
#endif

// Log using the same parameters above but include the function name and source code line number in the log statement
#ifdef DEBUG
#define DebugLogDetailed(fmt, ...) NSLog((@"Method: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DebugLogDetailed(...)
#endif

#define MTLocalizedString(str) NSLocalizedString(str, str)

#define mainAppDelegate ((ATAppDelegate *)[[UIApplication sharedApplication] delegate])

#define HEIGHT_IPHONE_5 568
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MethodHelper : NSObject{
 
}

#pragma mark Class Helper Methods

+ (UIAlertView *) showAlertInternetConnectionFailed;

/**
 Convenience method for dislaying an alert view to the user
 @param title the title to use for the Alert View
 @param message the message to use for the Alert View
 @param buttonTitle the title to use for the button that is displayed to the user that will close the Alert View
 */
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle;

#pragma mark AlertView with 2 button
/**
 Convenience method for dislaying an alert view to the user
 @param delegate
 @param title the title to use for the Alert View
 @param message the message to use for the Alert View
 @param cancelButtonTitle the title to use for the cancel button that is displayed to the user that will close the Alert View
 @param okButtonTitle the title to use for the OK button that is displayed to the user in Alert View
 */

+ (void)showAlertViewWithDelegate:(id<UIAlertViewDelegate>) delegate title:(NSString *)title andMessage:(NSString *)message andCancelButtonTitle:(NSString *)cancelButtonTitle andOkButtonTitle:(NSString *)okButtonTitle;

#pragma mark Show Dialog with Textfield

/**
 Convenience method for dislaying a dialog view to the user
 */
+ (void)showDialogOneTextfieldWithDelegate:(id<UIAlertViewDelegate>) delegate;

#pragma mark - String helper

/**
 Get substrings between character
 */
+ (NSArray *) getSubStringOfString:(NSString *) sourceString betweenCharacter:(NSString *) character;

/**
 Remove leading zero from passed phone number
 @param phoneNumber the phone number to update
 */
+ (NSString *)removeLeadingZeroFromPhoneNumber:(NSString *)phoneNumber;

#pragma mark - Date Helper Methods
+ (BOOL)isSameDay:(NSDate*)date1 andDate:(NSDate*)date2;
/**
 Converts the passed date into a string using the provided date format.
 @param date The date to convert.
 @param format The format to return the date as.
 @returns The NSString converted version of the date, based on the provided date format.
 */
+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString *)format;

/**
 Converts the passed date into a string value using the provided date formatter style.
 @param date The date to convert.
 @param style The NSDateFormatterStyle to return the date as.
 @returns The NSString converted version of the date, based on the provided date formatter style.
 */
+ (NSString *)stringFromDate:(NSDate *)date usingStyle:(NSDateFormatterStyle)style;

/**
 Converts the passed string into a date using the provided date format.
 @param dateString The string to convert into a date.
 @param format The format that this method is expecting when providing the date string.
 @returns The NSDate converted version of the date string.
 */
+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)format;

/**
 Returns the date from todays date using the modifier passed in.  A negative modifier
 will return a date that is x days in the past, while a positive modifier will return
 a date that is x days in the future.
 @param modifier The x days modifier to apply to the current date.
 @returns The date x days from today that we are after.
 */
+ (NSDate *)dateFromNowUsingModifier:(NSInteger)modifier;

/**
 Returns the string representation of the provided date using the modifier passed in.
 A negative modifier will return a date that is x days in the past, while a positive
 modifier will return a date that is x days in the future.
 @param modifier The x days modifier to apply to the current date.
 @param style The NSDateFormatterStyle that we wish to return the date as.
 @returns The string representation of the date that is x days from today, formatted
 in the specified date formatter style.
 */
+ (NSString *)stringDateFromNowUsingModifier:(NSInteger)modifier andStyle:(NSDateFormatterStyle)style;

/**
 Returns the string representation of todays date, but then modified using the modifier passed in.
 A negative modifier will return a date that is x days in the past, while a positive
 modifier will return a date that is x days in the future.
 @param modifier The x days modifier to apply to the current date.
 @param format The format to return the string representation of the date as.
 @returns The string representation of the date that is x days from today, formatted
 in the specified date format.
 */
+ (NSString *)stringDateFromNowUsingModifier:(NSInteger)modifier andFormat:(NSString *)format;

/**
 Returns the string representation of the provided date using the modifier passed in.
 A negative modifier will return a date that is x days in the past, while a positive
 modifier will return a date that is x days in the future.
 @param date The date to apply the modifier to.
 @param modifier The x days modifier to apply to the passed date.
 @param format The format to return the string representation of the date as.
 @returns The string representation of the date that is x days from the passed date, formatted in the specified date format.
 */
+ (NSString *)stringDateFrom:(NSDate *)date usingModifier:(NSInteger)modifier andFormat:(NSString *)format;

/**
 Returns the date from the date using the modifier passed in.  A negative months
 will return a date that is x months in the past, while a positive months will return
 a date that is x months in the future.
 @param date The date to apply the x months
 @param monthsToAdd The x months to apply to the date.
 @return The date x months from today that we are after.
 */
+ (NSDate *) dateFromDate:(NSDate *) date byAddingMonths: (NSInteger) monthsToAdd;

/**
 Returns the date from the date using the modifier passed in.  A negative modifier
 will return a date that is x days in the past, while a positive modifier will return
 a date that is x days in the future.
 @param modifier The x days modifier to apply to the current date.
 @return The date x days from the day that we are after.
 */
+ (NSDate *)dateFrom:(NSDate *)date usingModifier:(NSInteger)modifier;

/**
 Returns the day component from date
 @param date the date you want to get day component
 @return the day of date
 */
+ (NSInteger) dayComponentFromDate:(NSDate *) date;

/**
 Returns the month component from date
 @param date the date you want to get month component
 @return the month of date
 */
+ (NSInteger) monthComponentFromDate:(NSDate *) date;

/**
 Returns the year component from date
 @param date the date you want to get month component
 @return the year of date
 */
+ (NSInteger) yearComponentFromDate:(NSDate *) date;

/**
 Returns the current date
 @return the current date
 */
+ (NSString *) getDateNow;

/**
 Returns hour with am or pm
 @return the hours
 */
+ (NSString *) convertHour:(NSString *) hour;

/**
 Convert string date from date format to new format
 @param dateString the date string need convert
 @param fromFormat current format of date string
 @param toFormat destination format of date string
 @return the date string of destination format
 */
+ (NSString *) stringDate:(NSString *) dateString fromFormat:(NSString *) fromFormat toFormat:(NSString *) toFormat;

/**
 Convert string date from UTC to local time zone
 @param utcDate the utc date string
 @param fromFormat the format of utc date string
 @param toFormat the format of local date string needed
 @return local time zone date string
 */
+ (NSString *) dateStringLocalTimeZoneFromUTC:(NSString *) utcDateString withFormat:(NSString *) fromFormat toFormat:(NSString *) toFormat;

/**
 Returns full month
 @return full month
 **/
+ (NSString *) convertFullMonth:(NSDate *) date;
+ (NSDate *) getDateFullMonth:(NSString *)string;
+ (NSString *) convertMeetDate:(NSDate *) startDate endDate:(NSDate *)endDate;
/**
 Returns full date text
 @return full date
 **/
+ (NSString *) convertFullDate:(NSDate *) date;

/**
 Returns date text
 @param date
 **/
+ (NSString *) convertDate:(NSDate *) date;

/**
 Return time logged
 @return time logged
 **/
+ (NSString *) convertForTimeLoggedWithMinutes:(NSInteger) minutes;

+ (NSString *) convertTimeLoggedToTimeFormat:(NSInteger) minutes;

+ (NSDate *) getDeviceLocalTimeFromGMTTimeString:(NSString *) timeString;

+ (NSDate *) getDeviceLocalDateTimeFromServerDateTime:(NSString *) timeString;

+ (NSString *) getServiceDateTimeFromLocalDateTime:(NSDate *) date;

//+ (NSDate *) getDeviceLocalDateTimeFromServerDate:(NSDate *) date;

+ (NSDate *) date:(NSDate *)date byAddingDay:(NSInteger)day;

/**
 Return date after add day
 @return date
 **/
+ (NSString *) addDayWithDate:(NSString*) date andNumberOfDay:(NSInteger)day;

/**
 Return date after sutract day
 **/
+ (NSString *) subtractDate:(NSDate*) date andDay:(NSInteger)day;

/**
 Return Hours
 @return Hours
 **/
+ (NSInteger) minutesWithTime:(NSString *) time;

+ (NSInteger)countYearOld:(NSDate *)date;

#pragma mark - Phone Formatter Methods

/**
 Phone format
 @param mobileNumber the string of phone must follow the standard US format
 @return mobileNumber String after changed to US format
 */
+ (NSString*)formatNumber:(NSString*)mobileNumber;

/**
 Convert String to phone format
 @param phone the string need convert to standard US format phone
 @return phone String after changed to US format
 */
+ (NSString*)convertStringToPhoneFormat:(NSString*)phone;

/**
 Convert phone format to string number
 @param phone the string need convert
 @return phone only contain number 
 */
+ (NSString*)convertPhoneFormatToString:(NSString*)phone;

/**
 Check phone number is valid
 @param phone number the string of phone need to check
 @return YES if phone number is valid, otherwise return NO
 */
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;

#pragma mark - Check Validate Methods

/**
 Check email is valid
 @param checkString the string of email need to check
 @return YES if email is valid, otherwise return NO
 */
+ (BOOL)isValidEmail:(NSString *)checkString;

/**
 Check date is valid
 @param checkStringDate the string of date need to check
 @return YES if date is valid, otherwise return NO
 */
+ (BOOL)isValidDate:(NSString *)checkStringDate;

/**
 Check birthday must be greater than 18 year old
 @param checkStringDate the string of date need to check
 @return YES if date is valid, otherwise return NO
 */
+ (BOOL)checkBirthdayOfUser:(NSString *)checkStringDate;

/**
 Remove whitespace at start and last of string
 @param checkString the string need remove whitespace
 @return result the string removed whitespace at start and last
 */
+ (NSString *)removeWhiteSpaceAtStartAndLastWithString:(NSString *) checkString;

/**
 Convert to RGB color from hex color
 @param str which is hex color string
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

/**
 Get string with phone format style from number string
 @param numberString
 @returns phone formatted string
 */
+ (NSString *)getPhoneStringFromString:(NSString *)numberString;

#pragma mark Check Network Connection

/**
 Check internet connection
 @returns YES if internet connection is valid, otherwise return NO
 */
+ (BOOL)connectedToInternet;

#pragma mark Check version of device

/**
 Check version of device
 @param minRequirement which is device version
 @returns YES if current device version lesser than minRequirement version, otherwise return NO
 */
+(BOOL)doesSystemVersionMeetRequirement:(NSString *)minRequirement;

/**
 Start direction with latitude and longitude
 @param fromLat the from latitude
 @param fromLng the from longitude
 @param toLat the to latitude
 @param toLng the to longitude
 */
+ (void)startDirectionFromLat:(CGFloat )fromLat
                      fromLng:(CGFloat )fromLng
                        toLat:(CGFloat )toLat
                        toLng:(CGFloat )toLng;

/**
 Open facebook fan page
 @param fanPage the string fanPageID to open facebook fan page
 */
+ (void) openFacebookFanPage:(NSString *) fanPage;

#pragma mark - === Check iOS 7 ===

/**
 Check iOS 7
 @returns YES if system version greater than or equal to 7.0, otherwise return NO
 */
+ (BOOL) isiOS7;

#pragma mark - === Check network connection ===
/**
 Check internet conenction using Reachability
 @return Internet connection available is YES, No Internet connection is NO
 */
+ (BOOL) checkInternetConnection;

#pragma mark - === Loading view ===
/**
 Show loading view
 */
+ (void)showLoadingView:(UIView*)view;

/**
 Hide loading view
 */
+ (void)hideLoadingView:(UIView*)view;

#pragma mark - === Get text day ===

+ (NSString*)getTextWithDate:(NSString*)date;

#pragma mark - === Check string is number ===

+ (BOOL) isNumber: (NSString*)input;

#pragma mark - === Save/Get file in document folder ===
+ (NSString *) getPathFileFromDocumentsFolderWithName:(NSString*)name andType:(NSString*)type;
+ (NSString *) saveAttachmentWithPhoto:(UIImage*)image andFileName:(NSString*)name;
+ (BOOL) checkExistingFileInDocumentsWithName:(NSString*)name;
+ (void) removeFileInDocumentFolderWithWithName:(NSString*)name;

#pragma mark - === Generate Temp ID ===
+ (int64_t) generateTempID;

+ (float)countYearOld2:(NSDate *)date;

#pragma mark - Navigation Bar Buttons
UIBarButtonItem* backButtonForController(id controller);
@end
