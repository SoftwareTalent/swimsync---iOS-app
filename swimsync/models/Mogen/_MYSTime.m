// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSTime.m instead.

#import "_MYSTime.h"

const struct MYSTimeAttributes MYSTimeAttributes = {
	.course = @"course",
	.date = @"date",
	.distance = @"distance",
	.reactionTime = @"reactionTime",
	.stage = @"stage",
	.status = @"status",
	.stroke = @"stroke",
	.time = @"time",
};

const struct MYSTimeRelationships MYSTimeRelationships = {
	.laps = @"laps",
	.meet = @"meet",
	.profile = @"profile",
};

const struct MYSTimeFetchedProperties MYSTimeFetchedProperties = {
};

@implementation MYSTimeID
@end

@implementation _MYSTime

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSTime" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSTime";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSTime" inManagedObjectContext:moc_];
}

- (MYSTimeID*)objectID {
	return (MYSTimeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"courseValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"course"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"reactionTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"reactionTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
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




@dynamic course;



- (int32_t)courseValue {
	NSNumber *result = [self course];
	return [result intValue];
}

- (void)setCourseValue:(int32_t)value_ {
	[self setCourse:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCourseValue {
	NSNumber *result = [self primitiveCourse];
	return [result intValue];
}

- (void)setPrimitiveCourseValue:(int32_t)value_ {
	[self setPrimitiveCourse:[NSNumber numberWithInt:value_]];
}





@dynamic date;






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





@dynamic reactionTime;



- (int64_t)reactionTimeValue {
	NSNumber *result = [self reactionTime];
	return [result longLongValue];
}

- (void)setReactionTimeValue:(int64_t)value_ {
	[self setReactionTime:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveReactionTimeValue {
	NSNumber *result = [self primitiveReactionTime];
	return [result longLongValue];
}

- (void)setPrimitiveReactionTimeValue:(int64_t)value_ {
	[self setPrimitiveReactionTime:[NSNumber numberWithLongLong:value_]];
}





@dynamic stage;



- (int16_t)stageValue {
	NSNumber *result = [self stage];
	return [result shortValue];
}

- (void)setStageValue:(int16_t)value_ {
	[self setStage:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStageValue {
	NSNumber *result = [self primitiveStage];
	return [result shortValue];
}

- (void)setPrimitiveStageValue:(int16_t)value_ {
	[self setPrimitiveStage:[NSNumber numberWithShort:value_]];
}





@dynamic status;



- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
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





@dynamic laps;

	
- (NSMutableSet*)lapsSet {
	[self willAccessValueForKey:@"laps"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"laps"];
  
	[self didAccessValueForKey:@"laps"];
	return result;
}
	

@dynamic meet;

	

@dynamic profile;

	






@end
