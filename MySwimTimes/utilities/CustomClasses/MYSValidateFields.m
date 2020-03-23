//
//  MYSValidateFields.m
//  MYS
//
//  Created by Probir Chakraborty on 6/23/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSValidateFields.h"

@implementation MYSValidateFields
+(BOOL)isStringVerified:(NSString*)string withPattern:(NSString*)pattern {
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateUsername:(NSString *)userName {
    
    NSString *exprs = @"^[A-Za-z][A-Za-z0-9]*$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:userName options:0 range:NSMakeRange(0, [userName length])];
    
    return (match ? FALSE : TRUE);}

+(BOOL)validateName:(NSString *)name {
    
    NSString *exprs =@"^[a-zA-Z\\s]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:name options:0 range:NSMakeRange(0, [name length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
    
    NSString *exprs =@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:emailAddress options:0 range:NSMakeRange(0, [emailAddress length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateFirstName:(NSString *)firstName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:firstName options:0 range:NSMakeRange(0, [firstName length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateLastName:(NSString *)lastName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:lastName options:0 range:NSMakeRange(0, [lastName length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateAddress:(NSString *)address {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber {
    
    NSString *exprs =@"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:mobileNumber options:0 range:NSMakeRange(0, [mobileNumber length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    
    NSString *exprs = @"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateSetBeingLate:(NSString *)lateTime {
    
    NSString *exprs = @"^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:lateTime options:0 range:NSMakeRange(0, [lateTime length])];
    
return (match ? FALSE : TRUE);
    
    }

@end