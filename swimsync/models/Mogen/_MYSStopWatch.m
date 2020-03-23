// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSStopWatch.m instead.

#import "_MYSStopWatch.h"

const struct MYSStopWatchAttributes MYSStopWatchAttributes = {
	.lapStartDate = @"lapStartDate",
	.lapTime = @"lapTime",
	.running = @"running",
	.startDate = @"startDate",
	.time = @"time",
};

const struct MYSStopWatchRelationships MYSStopWatchRelationships = {
	.laps = @"laps",
};

const struct MYSStopWatchFetchedProperties MYSStopWatchFetchedProperties = {
};

@implementation MYSStopWatchID
@end

@implementation _MYSStopWatch

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSStopWatch" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSStopWatch";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSStopWatch" inManagedObjectContext:moc_];
}

- (MYSStopWatchID*)objectID {
	return (MYSStopWatchID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"lapTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lapTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"runningValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"running"];
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




@dynamic lapStartDate;






@dynamic lapTime;



- (float)lapTimeValue {
	NSNumber *result = [self lapTime];
	return [result floatValue];
}

- (void)setLapTimeValue:(float)value_ {
	[self setLapTime:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLapTimeValue {
	NSNumber *result = [self primitiveLapTime];
	return [result floatValue];
}

- (void)setPrimitiveLapTimeValue:(float)value_ {
	[self setPrimitiveLapTime:[NSNumber numberWithFloat:value_]];
}





@dynamic running;



- (BOOL)runningValue {
	NSNumber *result = [self running];
	return [result boolValue];
}

- (void)setRunningValue:(BOOL)value_ {
	[self setRunning:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRunningValue {
	NSNumber *result = [self primitiveRunning];
	return [result boolValue];
}

- (void)setPrimitiveRunningValue:(BOOL)value_ {
	[self setPrimitiveRunning:[NSNumber numberWithBool:value_]];
}





@dynamic startDate;






@dynamic time;



- (float)timeValue {
	NSNumber *result = [self time];
	return [result floatValue];
}

- (void)setTimeValue:(float)value_ {
	[self setTime:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result floatValue];
}

- (void)setPrimitiveTimeValue:(float)value_ {
	[self setPrimitiveTime:[NSNumber numberWithFloat:value_]];
}





@dynamic laps;

	
- (NSMutableSet*)lapsSet {
	[self willAccessValueForKey:@"laps"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"laps"];
  
	[self didAccessValueForKey:@"laps"];
	return result;
}
	






@end
