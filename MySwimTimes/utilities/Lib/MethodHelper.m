//
//  MethodHelper.m
//
//  Created by Cliff Viegas on 12/12/12.
//

#import "MethodHelper.h"

// For check connection
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MapKit/MapKit.h>
#import "NSData+Base64.h"
#import "MBProgressHUD.h"
#import "UIImage+FixOrientation.h"

#define VALID_YEARS_OLD_FOR_REGISTER 18

@implementation MethodHelper{
    
}

#pragma mark - Class Helper Methods
+ (UIAlertView *)showAlertInternetConnectionFailed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertMessageInternetConnectionFailWhenRequesting", nil) message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    return alert;
}

// Show an alert view with specified parameters
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitle:(NSString *)buttonTitle {
	// Duplicate found, warn user and exit this method
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
														message: message
													   delegate: nil
											  cancelButtonTitle: buttonTitle
											  otherButtonTitles: nil];
	[alertView show];
    return alertView;
}

+ (void)showAlertViewWithDelegate:(id<UIAlertViewDelegate>)delegate title:(NSString *)title andMessage:(NSString *)message andCancelButtonTitle:(NSString *)cancelButtonTitle andOkButtonTitle:(NSString *)okButtonTitle{
    
    // Duplicate found, warn user and exit this method
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
														message: message
													   delegate: delegate
											  cancelButtonTitle: cancelButtonTitle
											  otherButtonTitles: okButtonTitle,nil];
	[alertView show];
    
}

#pragma mark Show Dialog With Textfield

+ (void)showDialogOneTextfieldWithDelegate:(id<UIAlertViewDelegate>) delegate{

    //Inint alert view
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enter your Yatango PIN" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert setDelegate:delegate];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //Init textfield with style
    UITextField *textField = nil;
    textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = YES;
    textField.placeholder = @"Your Yatango PIN ";
    
    //Show alert
    [alert show];
}

#pragma mark - String helper

+ (NSArray *) getSubStringOfString:(NSString *) sourceString betweenCharacter:(NSString *) character {
    NSMutableArray *target = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:sourceString];
    NSString *tmp;
    
    while ([scanner isAtEnd] == NO)
    {
        [scanner scanUpToString:character intoString:NULL];
        [scanner scanString:character intoString:NULL];
        [scanner scanUpToString:character intoString:&tmp];
        if ([scanner isAtEnd] == NO)
            [target addObject:tmp];
        [scanner scanString:character intoString:NULL];
    }
    
    return target;
}

+ (NSString *)removeLeadingZeroFromPhoneNumber:(NSString *)phoneNumber {
    if ([phoneNumber length] > 0) {
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"0" withString:@"" options:0 range:NSMakeRange(0, 1)];
    }
    
    return phoneNumber;
}

#pragma mark - Date Helper Methods
+ (BOOL)isSameDay:(NSDate*)date1 andDate:(NSDate*)date2 {
    NSString* str1 = [self convertDate:date1];
    NSString* str2 = [self convertDate:date2];
    if ([str1 isEqualToString:str2]) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString *)format {
    if (date == nil) {
        return nil;
    }
    
    // Convert date to string using specified format
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	
	NSString *dateString = [dateFormat stringFromDate:date];
	
	return dateString;
}

+ (NSString *)stringFromDate:(NSDate *)date usingStyle:(NSDateFormatterStyle)style {
    if (date == nil) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	// We don't want time to be returned, so set this to no style
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:style];
	
	NSString *stringDate = [dateFormatter stringFromDate:date];
	
	return stringDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString *)format {
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
    
	NSDate *date = [dateFormat dateFromString:dateString];
	
	return date;
}

+ (NSDate *)dateFromNowUsingModifier:(NSInteger)modifier {
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    
    [components setDay:([components day] + modifier)];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    return newDate;
}

+ (NSString *)stringDateFromNowUsingModifier:(NSInteger)modifier andStyle:(NSDateFormatterStyle)style {
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    
    [components setDay:([components day] + modifier)];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    NSString *stringDate = [MethodHelper stringFromDate:newDate usingStyle:style];
    
    return stringDate;
}

+ (NSString *)stringDateFromNowUsingModifier:(NSInteger)modifier andFormat:(NSString *)format {
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    
    [components setDay:([components day] + modifier)];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    NSString *stringDate = [MethodHelper stringFromDate:newDate usingFormat:format];
    
    return stringDate;
}

+ (NSString *)stringDateFrom:(NSDate *)date usingModifier:(NSInteger)modifier andFormat:(NSString *)format {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:date];
    
    [components setDay:([components day] + modifier)];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    NSString *stringDate = [MethodHelper stringFromDate:newDate usingFormat:format];
    
    return stringDate;
}

+ (NSDate *) dateFromDate:(NSDate *) date byAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: date options: 0];
}

+ (NSDate *)dateFrom:(NSDate *)date usingModifier:(NSInteger)modifier {
    NSDate *today = date;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    
    [components setDay:([components day] + modifier)];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    
    return newDate;
}

+ (NSInteger) dayComponentFromDate:(NSDate *) date {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd"];
    return [[f stringFromDate:date] integerValue];
}

+ (NSInteger) monthComponentFromDate:(NSDate *) date {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM"];
    return [[f stringFromDate:date] integerValue];
}

+ (NSInteger) yearComponentFromDate:(NSDate *) date {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy"];
    return [[f stringFromDate:date] integerValue];
}

+ (NSString *)getDateNow{
    // Get current date time

    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"EEEE, MMMM dd yyyy"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;
}

+ (NSString *)convertHour:(NSString *)hour{
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter3 setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [dateFormatter3 dateFromString:hour];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mma"];
    
    return [formatter stringFromDate:date1];
}

+(NSString *)stringDate:(NSString *)dateString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat {
    if ([fromFormat isEqualToString:toFormat]) {
        return dateString;
    }
    
    NSDate *date = [self dateFromString:dateString usingFormat:fromFormat];
    return [self stringFromDate:date usingFormat:toFormat];
}

+(NSString *)dateStringLocalTimeZoneFromUTC:(NSString *)utcDateString withFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat{
    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df_utc setDateFormat:fromFormat];
    NSDate *ts_utc = [df_utc dateFromString:utcDateString];
    
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:toFormat];
    
    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
    
    return ts_local_string;
}

/**
 Returns full month
 @return full month
 **/
+ (NSString *) convertFullMonth:(NSDate *) date{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLL dd, yyyy"];
    NSString *newDate = [dateFormat stringFromDate:date];
    
    return newDate;
}

+ (NSDate *) getDateFullMonth:(NSString *)string {
    return [self dateFromString:string usingFormat:@"LLL dd, yyyy"];
}

+ (NSString *) convertMeetDate:(NSDate *) startDate endDate:(NSDate *)endDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    if(startDate == nil && endDate == nil)
    {
        return @"-";
    }
    else if(startDate != nil && endDate == nil)
    {
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        NSString *startDate_ = [dateFormat stringFromDate:startDate];
        
        return [NSString stringWithFormat:@"%@ -", startDate_];
    }
    else if(startDate == nil && endDate != nil)
    {
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        NSString *endDate_ = [dateFormat stringFromDate:endDate];
        
        return [NSString stringWithFormat:@"- %@", endDate_];
    }
    else
    {
        NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
        if((int)timeInterval == 0)
        {
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            
            return [dateFormat stringFromDate:startDate];
        }
        else
        {
            [dateFormat setDateFormat:@"MMM"];
            
            NSString *startMonth = [dateFormat stringFromDate:startDate];
            NSString *endMonth = [dateFormat stringFromDate:endDate];
            
            [dateFormat setDateFormat:@"dd"];
            
            NSString *startDay = [dateFormat stringFromDate:startDate];
            NSString *endDay = [dateFormat stringFromDate:endDate];
            
            [dateFormat setDateFormat:@"yyyy"];
            
            NSString *startYear = [dateFormat stringFromDate:startDate];
            NSString *endYear = [dateFormat stringFromDate:endDate];
            
            NSString *final = @"-";
            if(![startYear isEqualToString:endYear])
            {
                final = [NSString stringWithFormat:@"%@ %@, %@-%@ %@, %@", startMonth, startDay, startYear, endMonth, endDay, endYear];
            }
            else
            {
                if(![startMonth isEqualToString:endMonth])
                {
                    final = [NSString stringWithFormat:@"%@ %@-%@ %@, %@", startMonth, startDay, endMonth, endDay, endYear];
                }
                else
                {
                    final = [NSString stringWithFormat:@"%@ %@-%@, %@", startMonth, startDay, endDay, endYear];
                }
            }
            
            return final;
        }
    }
    
    return @"-";
}

/**
 Returns full date text
 @return full date
 **/
+ (NSString *) convertFullDate:(NSDate *) date{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLL dd, yyyy 'at' hh:mm a"];
    NSString *newDate = [dateFormat stringFromDate:date];
    
    return newDate;
}

/**
 Returns date text
 @param date
 **/
+ (NSString *) convertDate:(NSDate *) date {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yy"];
    NSString *newDate = [dateFormat stringFromDate:date];
    
    return newDate;
}


/**
 Returns local date time base on device time zone
 @return local date
 **/
+ (NSDate *) getDeviceLocalTimeFromGMTTimeString:(NSString *) timeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'T'Z";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    return [dateFormatter dateFromString:timeString];
}

/**
 Returns local date time base on device time zone
 @return local date
 **/
+ (NSDate *) getDeviceLocalDateTimeFromServerDateTime:(NSString *) timeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    return [dateFormatter dateFromString:timeString];
}

//+ (NSDate *) getDeviceLocalDateTimeFromServerDate:(NSDate *) date {
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    
//    return [dateFormatter dateFromString:dateString];
//}

+ (NSString *) getServiceDateTimeFromLocalDateTime:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithName:@"London"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    return [dateFormatter stringFromDate:date];
}

/**
 Return time logged
 @return time logged
 **/
+ (NSString *) convertForTimeLoggedWithMinutes:(NSInteger) minutes{
    
    NSInteger num_seconds = minutes * 60;
    
    NSInteger days = num_seconds / (60 * 60 * 24);
    num_seconds -= days * (60 * 60 * 24);
    NSInteger forHours = num_seconds / (60 * 60);
    num_seconds -= forHours * (60 * 60);
    NSInteger forMinutes = num_seconds / 60;
    
    if(days > 0 && forHours == 0 && forMinutes == 0){
        return [NSString stringWithFormat:@"%lddays",(long)days];
    }else if (days > 0 && forHours != 0 && forMinutes != 0) {
        return [NSString stringWithFormat:@"%lddays %ldhours %ldminutes",(long)days ,(long)forHours, (long)forMinutes];
    }else if (days > 0 && forHours != 0 && forMinutes == 0){
        return [NSString stringWithFormat:@"%lddays %ldhours", (long)days, (long)forHours];
    }else if (days > 0 && forHours == 0 && forMinutes != 0){
        return [NSString stringWithFormat:@"%lddays %ldminutes", (long)days, (long)forMinutes];
    }else if (days == 0 && forHours != 0 && forMinutes != 0){
        return [NSString stringWithFormat:@"%ldhours %ldminutes", (long)forHours, (long)forMinutes];
    }else if (days == 0 && forHours != 0 && forMinutes == 0) {
        return [NSString stringWithFormat:@"%ldhours", (long)forHours];
    }else if (days == 0 && forHours == 0 && forMinutes != 0){
        return [NSString stringWithFormat:@"%ldminutes", (long)forMinutes];
    }else{
        return @"";
    }
}

/**
 Return string time with format hh:mm
 */
+ (NSString *) convertTimeLoggedToTimeFormat:(NSInteger)minutes{
    
    NSInteger forHours = minutes / 60;
    NSInteger remainder = minutes % 60;
    
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)forHours, (long)remainder];
}

+ (NSString *)addDayWithDate:(NSString *)date andNumberOfDay:(NSInteger)day{
    
    // Creating and configuring date formatter instance
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:date];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
//    NSLog(@"Original date: %@", [dateFormatter stringFromDate:dateFromString]);
//    NSLog(@"The first begin date: %@", [dateFormatter stringFromDate:newDate]);
    
    return [dateFormatter stringFromDate:newDate];
}

+ (NSString *)subtractDate:(NSDate *)date andDay:(NSInteger)day{
    // Creating and configuring date formatter instance
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateTimeFormatServer];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-day];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    return [dateFormatter stringFromDate:sevenDaysAgo];
}

+ (NSDate *) date:(NSDate *)date byAddingDay:(NSInteger)day {
    // Creating and configuring date formatter instance
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:kDateTimeFormatServer];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-day];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
}

+ (NSInteger)minutesWithTime:(NSString *)time{
    
    NSInteger minutes = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *offsetDate = [dateFormatter dateFromString:time];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:offsetDate];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    minutes = hour * 60 + minute;
    
    return minutes;
}

+ (NSInteger)countYearOld:(NSDate *)date {
    
//    NSTimeInterval bd = [date timeIntervalSinceNow];
    
    
    NSInteger yearOld;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];

    NSInteger birthdayYear = [components year];
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger nowYear = [components2 year];
    
    yearOld = nowYear - birthdayYear;
    
    return yearOld;
    
}

+ (float)countYearOld2:(NSDate *)date {
    
    NSTimeInterval bd = [date timeIntervalSinceNow];
    int age = (int)(fabs(bd) / 31556926);
    return age;
    
    NSInteger yearOld;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSInteger birthdayYear = [components year];
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger nowYear = [components2 year];
    
    yearOld = nowYear - birthdayYear;
    
    return yearOld;
    
}

#pragma mark - Implement Phone Formatter Methods
#pragma mark

+ (NSString *)formatNumber:(NSString *)mobileNumber{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    
    return mobileNumber;
}

+ (NSString *)convertStringToPhoneFormat:(NSString *)phone{
    
    NSArray *stringComponents = [NSArray arrayWithObjects:[phone substringWithRange:NSMakeRange(0, 3)],
                                 [phone substringWithRange:NSMakeRange(3, 3)],
                                 [phone substringWithRange:NSMakeRange(6, [phone length]-6)], nil];
    
    NSString *formattedString = [NSString stringWithFormat:@"(%@) %@ - %@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];

    return formattedString;
}

+ (NSString *)convertPhoneFormatToString:(NSString *)phone{
 
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    phone = [MethodHelper removeWhiteSpaceAtStartAndLastWithString:phone];
    
    return phone;

}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber{
    NSString *str = @"(([+]{1}|[0]{2}){0,1}+[1]{1}){0,1}+[ ]{0,1}+(?:[-( ]{0,1}[0-9]{3}[-) ]{0,1}){0,1}+[ ]{0,1}+[0-9]{2,3}+[0-9- ]{4,8}";
    NSPredicate *no = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [no evaluateWithObject:phoneNumber];
}

#pragma mark - Implement Check Validate Methods
#pragma mark

+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)isValidDate:(NSString *)checkStringDate{
    
    NSInteger getMonth = [[checkStringDate substringWithRange:NSMakeRange(0, 2)] intValue];
    
    //Check format mm/dd/yyyy
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm/dd/yyyy"];
    
    NSDate *date = [dateFormatter dateFromString:checkStringDate];
        
    if (!date || checkStringDate.length != 10 || getMonth > 12) {
        return NO;
    }
    NSDate *date1900 = [MethodHelper dateFromString:@"01-01-1900" usingFormat:@"dd-MM-yyyy"];
    if ([date compare:date1900] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkBirthdayOfUser:(NSString *)checkStringDate{
    //Check year can not greater than current year
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm/dd/yyyy"];
    NSDate *date = [dateFormatter dateFromString:checkStringDate];
    
    //Check 18 year old
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date toDate:now options:0];
    NSInteger age = [ageComponents year];
    
    if (age < VALID_YEARS_OLD_FOR_REGISTER) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)removeWhiteSpaceAtStartAndLastWithString:(NSString *)checkString{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [checkString stringByTrimmingCharactersInSet:whitespace];
    return trimmed;
}

#pragma mark - === Convert Color ===

+ (UIColor *)colorWithHexString:(NSString *)str{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self colorWithHex:(UInt32)x];
}

+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (NSString *)getPhoneStringFromString:(NSString *)numberString
{
    numberString = [numberString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    numberString = [numberString stringByReplacingOccurrencesOfString:@")" withString:@""];
    numberString = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
    numberString = [numberString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    numberString = [numberString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSNumber *number = [NSNumber numberWithLongLong:[numberString longLongValue]];
    
    int first4Digit = (int)(number.integerValue / 1000000);
    int second3Digit = (number.integerValue % 1000000) / 1000;
    int last3Digit = number.integerValue % 1000;
    
    // Do format number to match AAAA BBB CCC if first 4 digit are '1300' or '1800'
    if(first4Digit == 1300 || first4Digit == 1800) {
        return [NSString stringWithFormat:@"%d %d %d", first4Digit, second3Digit, last3Digit];
        
    } else {
        // Do format number to match AA BBBB CCCC
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"0000000000"];
        [formatter setGroupingSeparator:@" "];
        [formatter setGroupingSize:4];
        [formatter setUsesGroupingSeparator:YES];
        return [formatter stringFromNumber:number];
    }
    
}

+ (BOOL)connectedToInternet{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - === Check Device Of Version ===

+(BOOL)doesSystemVersionMeetRequirement:(NSString *)minRequirement{
    
    // eg  NSString *reqSysVer = @"4.0";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer compare:minRequirement options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    }else{
        return NO;
    }
}

+ (void)startDirectionFromLat:(CGFloat )fromLat
                      fromLng:(CGFloat )fromLng
                        toLat:(CGFloat )toLat
                        toLng:(CGFloat )toLng
{
    NSString *urlToOpen = @"";
    
    NSInteger defaultZoomLevelGoogleMap = 13;
    
    // Check user installed google map for ios
    urlToOpen = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&center=%f,%f&directionsmode=driving&zoom=%ld",
                 fromLat,
                 fromLng,
                 toLat,
                 toLng,
                 fromLat,
                 fromLng,
                 (long)defaultZoomLevelGoogleMap];
    
    NSURL *url = [NSURL URLWithString:urlToOpen];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        // Google Maps app
        [[UIApplication sharedApplication] openURL:url];
        
    } else {
        
        // Apple Maps app
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            
            CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(toLat, toLng);
            MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
            MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
            
            MKMapItem *beginItem = [MKMapItem mapItemForCurrentLocation];
            
            NSArray *mapItems = @[beginItem, endingItem];
            
            NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                      MKLaunchOptionsMapTypeKey:
                                          [NSNumber numberWithInteger:MKMapTypeStandard],
                                      MKLaunchOptionsShowsTrafficKey:@YES
                                      };
            
            [MKMapItem openMapsWithItems:mapItems launchOptions:options];
            
        } else {
            
            // Open Google Maps on web
            urlToOpen = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%.6f,%.6f&daddr=%.6f,%.6f",
                         fromLat,
                         fromLng,
                         toLat,
                         toLng];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
        }
    }
}

+ (void) openFacebookFanPage:(NSString *) fanPageID {
    NSString *urlString = [NSString stringWithFormat:@"fb://profile/%@", fanPageID];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@", fanPageID]]];
    }
}

+ (BOOL) isiOS7 {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isValidPassword:(NSString *)checkString {
    if ([checkString length] >= 6) {
        return YES;
    }
    return NO;
}

#pragma mark - === Loading view ===
/**
 Show loading view
 */
+ (void)showLoadingView:(UIView*)view {
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.labelText = MTLocalizedString(@"LOADING");
}

/**
 Hide loading view
 */
+ (void)hideLoadingView:(UIView*)view {
    
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark - === Check network connection ===
/**
 Check internet conenction using Reachability
 @return Internet connection available is YES, No Internet connection is NO
 */
+ (BOOL) checkInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    switch (networkStatus) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            return YES;
        }
            break;
            
        case NotReachable:
        {
            return NO;
        }
        default:
            return NO;
            break;
    }
}

#pragma mark - === Get text day ===

+ (NSString*)getTextWithDate:(NSString*)date{
    // Creating and configuring date formatter instance
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:date];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-1];
    
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSString *newDate = [MethodHelper stringFromDate:dateFromString usingFormat:@"yyyy-MM-dd"];
    NSString *today = [MethodHelper stringFromDate:[NSDate date] usingFormat:@"yyyy-MM-dd"];
    NSString *sYesterday = [MethodHelper stringFromDate:yesterday usingFormat:@"yyyy-MM-dd"];

    if ([newDate isEqualToString:today]) {
        return @"Today";
    }else if ([newDate isEqualToString:sYesterday]){
        return @"Yesterday";
    }else{
        return [dateFormatter stringFromDate:dateFromString];
    }
}

#pragma mark - === Check string is number ===

+ (BOOL) isNumber: (NSString*)input
{
    BOOL isNumber = [input doubleValue] != 0 || [input isEqualToString:@"0"] || [input isEqualToString:@"0.0"];
    return isNumber;
}

#pragma mark - === Save/Get file in document folder ===
+ (NSString *) getPathFileFromDocumentsFolderWithName:(NSString*)name andType:(NSString*)type{
    
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, type, name];
    
    return path;
}

+ (NSString *) saveAttachmentWithPhoto:(UIImage*)image andFileName:(NSString*)name{
    
    // Create folder in document folder
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folder = [NSString stringWithFormat:@"%@/comment-attachments", documentFolder];
    
    BOOL isDirectory = NO;
    BOOL isExisting = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDirectory];
    if (isExisting == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    image = [image fixOrientation];
    
    // Save origin file
    NSString *filePath = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, FILE_ORIGIN, name];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:UIImagePNGRepresentation(image) attributes:nil];
    
    // Save thumbnail file
    CGSize destinationSize = CGSizeMake(64, 64);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *thumbnailFilePath = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, FILE_THUMBNAIL, name];
    [[NSFileManager defaultManager] createFileAtPath:thumbnailFilePath contents:UIImagePNGRepresentation(thumbnail) attributes:nil];
    
    return thumbnailFilePath;
}

+ (BOOL)checkExistingFileInDocumentsWithName:(NSString *)name{
    
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, FILE_ORIGIN, name];
    
    BOOL isDirectory = NO;
    BOOL isExisting = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];

    if (isExisting == NO) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)removeFileInDocumentFolderWithWithName:(NSString *)name{
    
    // Create folder in document folder
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePathThumbnail = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, FILE_THUMBNAIL, name];
    NSString *filePathOrigin = [NSString stringWithFormat:@"%@/comment-attachments/%@-%@", documentFolder, FILE_ORIGIN, name];
    
    // Thumbnail
    BOOL isDirectory = NO;
    BOOL isExistingThumbnail = [[NSFileManager defaultManager] fileExistsAtPath:filePathThumbnail isDirectory:&isDirectory];
    if (isExistingThumbnail == YES) {
        // Delete file
        BOOL success = [fileManager removeItemAtPath:filePathThumbnail error:&error];
        if (!success) {
//            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    // Origin
    BOOL isExistingOrigin = [[NSFileManager defaultManager] fileExistsAtPath:filePathOrigin isDirectory:&isDirectory];
    if (isExistingOrigin == YES) {
        // Delete file
        BOOL success = [fileManager removeItemAtPath:filePathOrigin error:&error];
        if (!success) {
//            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
}

#pragma mark - === Generate Temp ID ===
+ (int64_t)generateTempID{
    long long miliseconds = [[NSDate date] timeIntervalSince1970];
    return miliseconds;
}

#pragma mark - Navigation Bar Buttons

UIBarButtonItem* backButtonForController(id controller){
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0.0, 0.0, 40, 24);
    [cancelButton.titleLabel setFont:CandaraRegularFont(16)];
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [cancelButton addTarget:controller action: @selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    return plusBarButtonItem;
}

-(void)backButtonAction:(id)sender{
    
}

@end
