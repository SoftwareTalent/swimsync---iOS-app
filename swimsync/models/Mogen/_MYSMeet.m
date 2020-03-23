// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSMeet.m instead.

#import "_MYSMeet.h"

const struct MYSMeetAttributes MYSMeetAttributes = {
	.city = @"city",
	.courseType = @"courseType",
	.endDate = @"endDate",
	.enteredDate = @"enteredDate",
	.id = @"id",
	.location = @"location",
	.startDate = @"startDate",
	.title = @"title",
};

const struct MYSMeetRelationships MYSMeetRelationships = {
	.qualifytimes = @"qualifytimes",
	.times = @"times",
};

const struct MYSMeetFetchedProperties MYSMeetFetchedProperties = {
};

@implementation MYSMeetID
@end

@implementation _MYSMeet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSMeet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSMeet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSMeet" inManagedObjectContext:moc_];
}

- (MYSMeetID*)objectID {
	return (MYSMeetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"courseTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"courseType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic city;






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





@dynamic endDate;






@dynamic enteredDate;






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





@dynamic location;






@dynamic startDate;






@dynamic title;






@dynamic qualifytimes;

	
- (NSMutableSet*)qualifytimesSet {
	[self willAccessValueForKey:@"qualifytimes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"qualifytimes"];
  
	[self didAccessValueForKey:@"qualifytimes"];
	return result;
}
	

@dynamic times;

	
- (NSMutableSet*)timesSet {
	[self willAccessValueForKey:@"times"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"times"];
  
	[self didAccessValueForKey:@"times"];
	return result;
}
	






@end
