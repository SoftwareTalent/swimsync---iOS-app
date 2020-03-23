// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSGoalTime.m instead.

#import "_MYSGoalTime.h"

const struct MYSGoalTimeAttributes MYSGoalTimeAttributes = {
	.courseType = @"courseType",
	.distance = @"distance",
	.stroke = @"stroke",
	.time = @"time",
};

const struct MYSGoalTimeRelationships MYSGoalTimeRelationships = {
	.profile = @"profile",
};

const struct MYSGoalTimeFetchedProperties MYSGoalTimeFetchedProperties = {
};

@implementation MYSGoalTimeID
@end

@implementation _MYSGoalTime

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSGoalTime" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSGoalTime";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSGoalTime" inManagedObjectContext:moc_];
}

- (MYSGoalTimeID*)objectID {
	return (MYSGoalTimeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"courseTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"courseType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"strokeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stroke"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic courseType;



- (int16_t)courseTypeValue {
	NSNumber *result = [self courseType];
	return [result shortValue];
}

- (void)setCourseTypeValue:(int16_t)value_ {
	[self setCourseType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCourseTypeValue {
	NSNumber *result = [self primitiveCourseType];
	return [result shortValue];
}

- (void)setPrimitiveCourseTypeValue:(int16_t)value_ {
	[self setPrimitiveCourseType:[NSNumber numberWithShort:value_]];
}





@dynamic distance;



- (int64_t)distanceValue {
	NSNumber *result = [self distance];
	return [result longLongValue];
}

- (void)setDistanceValue:(int64_t)value_ {
	[self setDistance:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result longLongValue];
}

- (void)setPrimitiveDistanceValue:(int64_t)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithLongLong:value_]];
}





@dynamic stroke;



- (int32_t)strokeValue {
	NSNumber *result = [self stroke];
	return [result intValue];
}

- (void)setStrokeValue:(int32_t)value_ {
	[self setStroke:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStrokeValue {
	NSNumber *result = [self primitiveStroke];
	return [result intValue];
}

- (void)setPrimitiveStrokeValue:(int32_t)value_ {
	[self setPrimitiveStroke:[NSNumber numberWithInt:value_]];
}





@dynamic time;



- (int64_t)timeValue {
	NSNumber *result = [self time];
	return [result longLongValue];
}

- (void)setTimeValue:(int64_t)value_ {
	[self setTime:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result longLongValue];
}

- (void)setPrimitiveTimeValue:(int64_t)value_ {
	[self setPrimitiveTime:[NSNumber numberWithLongLong:value_]];
}





@dynamic profile;

	






@end
