//
//  NSMutableDictionary+Utilities.h
//  LiveProject
//
//  Created by SmarterApps on 7/30/13.
//  Copyright (c) 2013 SmarterApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Utilities)

- (void)setObjectNotNull:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 Returns the array associated with a given key.
 @param aKey The aKey for which to return the corresponding array.
 @return The array associated with aKey, or nil if no array is associated with aKey.
 */
- (NSArray *) arrayForKey:(id) aKey;

@end
