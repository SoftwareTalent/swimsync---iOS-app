//
//  NSDictionary+ObjectNotNull.h
//
//  Created by Cliff Viegas on 12/12/12.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ObjectNotNull)

- (id) objectNotNullForKey:(id) key;

/**
 Returns the array associated with a given key.
 @param aKey The aKey for which to return the corresponding array.
 @return The array associated with aKey, or nil if no array is associated with aKey.
 */
- (NSArray *) arrayForKey:(id) aKey;



-(id)objectForKeyNotNull:(id)object expectedObj:(id)obj;

@end
