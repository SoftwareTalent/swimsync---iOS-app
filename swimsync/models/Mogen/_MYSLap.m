// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSLap.m instead.

#import "_MYSLap.h"

const struct MYSLapAttributes MYSLapAttributes = {
	.id = @"id",
	.lapNumber = @"lapNumber",
	.splitTime = @"splitTime",
};

const struct MYSLapRelationships MYSLapRelationships = {
	.stopwatch = @"stopwatch",
	.time = @"time",
};

const struct MYSLapFetchedProperties MYSLapFetchedProperties = {
};

@implementation MYSLapID
@end

@implementation _MYSLap

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSLap" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSLap";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSLap" inManagedObjectContext:moc_];
}

- (MYSLapID*)objectID {
	return (MYSLapID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lapNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lapNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"splitTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"splitTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;



- (int64_t)idValue {
	NSNumber *result = [self id];
	return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_ {
	[self setId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithLongLong:value_]];
}





@dynamic lapNumber;



- (int64_t)lapNumberValue {
	NSNumber *result = [self lapNumber];
	return [result longLongValue];
}

- (void)setLapNumberValue:(int64_t)value_ {
	[self setLapNumber:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveLapNumberValue {
	NSNumber *result = [self primitiveLapNumber];
	return [result longLongValue];
}

- (void)setPrimitiveLapNumberValue:(int64_t)value_ {
	[self setPrimitiveLapNumber:[NSNumber numberWithLongLong:value_]];
}





@dynamic splitTime;



- (int64_t)splitTimeValue {
	NSNumber *result = [self splitTime];
	return [result longLongValue];
}

- (void)setSplitTimeValue:(int64_t)value_ {
	[self setSplitTime:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveSplitTimeValue {
	NSNumber *result = [self primitiveSplitTime];
	return [result longLongValue];
}

- (void)setPrimitiveSplitTimeValue:(int64_t)value_ {
	[self setPrimitiveSplitTime:[NSNumber numberWithLongLong:value_]];
}





@dynamic stopwatch;

	

@dynamic time;

	






@end
