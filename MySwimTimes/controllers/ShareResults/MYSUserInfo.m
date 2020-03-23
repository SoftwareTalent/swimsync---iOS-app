//
//  MYSUserInfo.m
//  swimsync
//
//  Created by Probir Chakraborty on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSUserInfo.h"
#import "NSDictionary+ObjectNotNull.h"

@implementation MYSUserInfo

+(MYSUserInfo *)getUserInfoFrom:(NSDictionary*)data {
    
    MYSUserInfo *userItem = [[MYSUserInfo alloc] init];
    userItem.userID = [data objectForKeyNotNull:@"user_id" expectedObj:@""];
    userItem.userName = [data objectForKeyNotNull:@"user_name" expectedObj:@""];
    userItem.userEmail = [data objectForKeyNotNull:@"email" expectedObj:@""];
    
    return userItem;
}

@end
