// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSQualifyTime.m instead.

#import "_MYSQualifyTime.h"

const struct MYSQualifyTimeAttributes MYSQualifyTimeAttributes = {
	.gender = @"gender",
	.id = @"id",
	.name = @"name",
};

const struct MYSQualifyTimeRelationships MYSQualifyTimeRelationships = {
	.events = @"events",
	.meet = @"meet",
};

const struct MYSQualifyTimeFetchedProperties MYSQualifyTimeFetchedProperties = {
};

@implementation MYSQualifyTimeID
@end

@implementation _MYSQualifyTime

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSQualifyTime" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSQualifyTime";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSQualifyTime" inManagedObjectContext:moc_];
}

- (MYSQualifyTimeID*)objectID {
	return (MYSQualifyTimeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"genderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gender"];
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




@dynamic gender;



- (int16_t)genderValue {
	NSNumber *result = [self gender];
	return [result shortValue];
}

- (void)setGenderValue:(int16_t)value_ {
	[self setGender:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveGenderValue {
	NSNumber *result = [self primitiveGender];
	return [result shortValue];
}

- (void)setPrimitiveGenderValue:(int16_t)value_ {
	[self setPrimitiveGender:[NSNumber numberWithShort:value_]];
}





@dynamic id;



- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic events;

	
- (NSMutableSet*)eventsSet {
	[self willAccessValueForKey:@"events"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"events"];
  
	[self didAccessValueForKey:@"events"];
	return result;
}
	

@dynamic meet;

	






@end
