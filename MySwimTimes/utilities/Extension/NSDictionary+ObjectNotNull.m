//
//  NSDictionary+ObjectNotNull.m
//
//  Created by Cliff Viegas on 12/12/12.
//

#import "NSDictionary+ObjectNotNull.h"

@implementation NSDictionary (ObjectNotNull)

-(id)objectNotNullForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return obj;
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


-(id)objectForKeyNotNull:(id)key expectedObj:(id)obj {
    
    id object = [self objectForKey:key];
    
    if ((object == nil) || (object == [NSNull null])) return obj;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        CFNumberType numberType = CFNumberGetType((CFNumberRef)object);
        if (numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type)
            return [NSString stringWithFormat:@"%f",[object floatValue]];
        else
            return [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
    }
    
    return object;
}

@end
