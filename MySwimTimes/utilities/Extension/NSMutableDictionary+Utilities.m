//
//  NSMutableDictionary+Utilities.m
//  LiveProject
//
//  Created by SmarterApps on 7/30/13.
//  Copyright (c) 2013 SmarterApps. All rights reserved.
//

#import "NSMutableDictionary+Utilities.h"

@implementation NSMutableDictionary (Utilities)

-(void)setObjectNotNull:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    } else {
        [self setObject:@"" forKey:aKey];
    }
}

-(NSArray *)arrayForKey:(id)aKey {
    id obj = [self objectForKey:aKey];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}

@end
