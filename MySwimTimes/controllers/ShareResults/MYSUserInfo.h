//
//  MYSUserInfo.h
//  swimsync
//
//  Created by Probir Chakraborty on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSUserInfo : NSObject

@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *userEmail;

+(MYSUserInfo *)getUserInfoFrom:(NSDictionary*)data;

@end
