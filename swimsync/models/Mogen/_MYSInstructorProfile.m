// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSInstructorProfile.m instead.

#import "_MYSInstructorProfile.h"

const struct MYSInstructorProfileAttributes MYSInstructorProfileAttributes = {
	.currentProfile = @"currentProfile",
	.email = @"email",
	.instructorID = @"instructorID",
	.password = @"password",
	.purchasedForShareResult = @"purchasedForShareResult",
	.purchasedToRemoveAds = @"purchasedToRemoveAds",
	.userName = @"userName",
};

const struct MYSInstructorProfileRelationships MYSInstructorProfileRelationships = {
	.profile = @"profile",
};

const struct MYSInstructorProfileFetchedProperties MYSInstructorProfileFetchedProperties = {
};

@implementation MYSInstructorProfileID
@end

@implementation _MYSInstructorProfile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MYSInstructorProfile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MYSInstructorProfile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MYSInstructorProfile" inManagedObjectContext:moc_];
}

- (MYSInstructorProfileID*)objectID {
	return (MYSInstructorProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"purchasedForShareResultValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"purchasedForShareResult"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"purchasedToRemoveAdsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"purchasedToRemoveAds"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic currentProfile;






@dynamic email;






@dynamic instructorID;






@dynamic password;






@dynamic purchasedForShareResult;



- (BOOL)purchasedForShareResultValue {
	NSNumber *result = [self purchasedForShareResult];
	return [result boolValue];
}

- (void)setPurchasedForShareResultValue:(BOOL)value_ {
	[self setPurchasedForShareResult:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePurchasedForShareResultValue {
	NSNumber *result = [self primitivePurchasedForShareResult];
	return [result boolValue];
}

- (void)setPrimitivePurchasedForShareResultValue:(BOOL)value_ {
	[self setPrimitivePurchasedForShareResult:[NSNumber numberWithBool:value_]];
}





@dynamic purchasedToRemoveAds;



- (BOOL)purchasedToRemoveAdsValue {
	NSNumber *result = [self purchasedToRemoveAds];
	return [result boolValue];
}

- (void)setPurchasedToRemoveAdsValue:(BOOL)value_ {
	[self setPurchasedToRemoveAds:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePurchasedToRemoveAdsValue {
	NSNumber *result = [self primitivePurchasedToRemoveAds];
	return [result boolValue];
}

- (void)setPrimitivePurchasedToRemoveAdsValue:(BOOL)value_ {
	[self setPrimitivePurchasedToRemoveAds:[NSNumber numberWithBool:value_]];
}





@dynamic userName;






@dynamic profile;

	
- (NSMutableSet*)profileSet {
	[self willAccessValueForKey:@"profile"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"profile"];
  
	[self didAccessValueForKey:@"profile"];
	return result;
}
	






@end
