//
//  MYSValidateFields.h
//  MYS
//
//  Created by Probir Chakraborty on 6/23/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSValidateFields : NSObject


+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
+(BOOL)validateMobileNumber:(NSString *)mobileNumber;
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(BOOL)validateAddress:(NSString *)address;
+(BOOL)validateUsername:(NSString *)userName;
+(BOOL)validateName:(NSString *)name;

@end
