// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSDistance.m instead.

#import "_MYSDistance.h"

const struct MYSDistanceAttributes MYSDistanceAttributes = {
	.distance = @"distance",
	.enteredDate = @"enteredDate",
};

const struct MYSDistanceRelationships MYSDistanceRelationships = {
};

const struct MYSDistanceFetchedProperties MYSDistanceFetchedProperties = {
};

@implementation MYSDistanceID
@end

@implementation _MYSDistance

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSDistance" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSDistance";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSDistance" inManagedObjectContext:moc_];
}

- (MYSDistanceID*)objectID {
	return (MYSDistanceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic distance;



- (float)distanceValue {
	NSNumber *result = [self distance];
	return [result floatValue];
}

- (void)setDistanceValue:(float)value_ {
	[self setDistance:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result floatValue];
}

- (void)setPrimitiveDistanceValue:(float)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithFloat:value_]];
}





@dynamic enteredDate;











@end
