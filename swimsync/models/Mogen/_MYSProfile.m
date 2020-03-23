// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSProfile.m instead.

#import "_MYSProfile.h"

const struct MYSProfileAttributes MYSProfileAttributes = {
	.birthday = @"birthday",
	.city = @"city",
	.country = @"country",
	.gender = @"gender",
	.image = @"image",
	.name = @"name",
	.nameSwimClub = @"nameSwimClub",
	.userid = @"userid",
};

const struct MYSProfileRelationships MYSProfileRelationships = {
	.goaltime = @"goaltime",
	.instructor = @"instructor",
	.time = @"time",
};

const struct MYSProfileFetchedProperties MYSProfileFetchedProperties = {
};

@implementation MYSProfileID
@end

@implementation _MYSProfile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSProfile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSProfile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSProfile" inManagedObjectContext:moc_];
}

- (MYSProfileID*)objectID {
	return (MYSProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"genderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gender"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"useridValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic birthday;






@dynamic city;






@dynamic country;






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





@dynamic image;






@dynamic name;






@dynamic nameSwimClub;






@dynamic userid;



- (int64_t)useridValue {
	NSNumber *result = [self userid];
	return [result longLongValue];
}

- (void)setUseridValue:(int64_t)value_ {
	[self setUserid:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUseridValue {
	NSNumber *result = [self primitiveUserid];
	return [result longLongValue];
}

- (void)setPrimitiveUseridValue:(int64_t)value_ {
	[self setPrimitiveUserid:[NSNumber numberWithLongLong:value_]];
}





@dynamic goaltime;

	
- (NSMutableSet*)goaltimeSet {
	[self willAccessValueForKey:@"goaltime"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"goaltime"];
  
	[self didAccessValueForKey:@"goaltime"];
	return result;
}
	

@dynamic instructor;

	

@dynamic time;

	
- (NSMutableSet*)timeSet {
	[self willAccessValueForKey:@"time"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"time"];
  
	[self didAccessValueForKey:@"time"];
	return result;
}
	






@end
