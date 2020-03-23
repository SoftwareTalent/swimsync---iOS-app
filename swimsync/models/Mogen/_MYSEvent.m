// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSEvent.m instead.

#import "_MYSEvent.h"

const struct MYSEventAttributes MYSEventAttributes = {
	.distance = @"distance",
	.id = @"id",
	.stroke = @"stroke",
	.time = @"time",
};

const struct MYSEventRelationships MYSEventRelationships = {
	.qualifytime = @"qualifytime",
};

const struct MYSEventFetchedProperties MYSEventFetchedProperties = {
};

@implementation MYSEventID
@end

@implementation _MYSEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSEvent" inManagedObjectContext:moc_];
}

- (MYSEventID*)objectID {
	return (MYSEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
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





@dynamic stroke;



- (int16_t)strokeValue {
	NSNumber *result = [self stroke];
	return [result shortValue];
}

- (void)setStrokeValue:(int16_t)value_ {
	[self setStroke:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStrokeValue {
	NSNumber *result = [self primitiveStroke];
	return [result shortValue];
}

- (void)setPrimitiveStrokeValue:(int16_t)value_ {
	[self setPrimitiveStroke:[NSNumber numberWithShort:value_]];
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





@dynamic qualifytime;

	






@end
