// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSInstructorProfile.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSInstructorProfileAttributes {
	__unsafe_unretained NSString *currentProfile;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *instructorID;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *purchasedForShareResult;
	__unsafe_unretained NSString *purchasedToRemoveAds;
	__unsafe_unretained NSString *userName;
} MYSInstructorProfileAttributes;

extern const struct MYSInstructorProfileRelationships {
	__unsafe_unretained NSString *profile;
} MYSInstructorProfileRelationships;

extern const struct MYSInstructorProfileFetchedProperties {
} MYSInstructorProfileFetchedProperties;

@class MYSProfile;









@interface MYSInstructorProfileID : NSManagedObjectID {}
@end

@interface _MYSInstructorProfile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSInstructorProfileID*)objectID;





@property (nonatomic, strong) NSString* currentProfile;



//- (BOOL)validateCurrentProfile:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* instructorID;



//- (BOOL)validateInstructorID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* purchasedForShareResult;



@property BOOL purchasedForShareResultValue;
- (BOOL)purchasedForShareResultValue;
- (void)setPurchasedForShareResultValue:(BOOL)value_;

//- (BOOL)validatePurchasedForShareResult:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* purchasedToRemoveAds;



@property BOOL purchasedToRemoveAdsValue;
- (BOOL)purchasedToRemoveAdsValue;
- (void)setPurchasedToRemoveAdsValue:(BOOL)value_;

//- (BOOL)validatePurchasedToRemoveAds:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userName;



//- (BOOL)validateUserName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *profile;

- (NSMutableSet*)profileSet;





@end

@interface _MYSInstructorProfile (CoreDataGeneratedAccessors)

- (void)addProfile:(NSSet*)value_;
- (void)removeProfile:(NSSet*)value_;
- (void)addProfileObject:(MYSProfile*)value_;
- (void)removeProfileObject:(MYSProfile*)value_;

@end

@interface _MYSInstructorProfile (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCurrentProfile;
- (void)setPrimitiveCurrentProfile:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveInstructorID;
- (void)setPrimitiveInstructorID:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSNumber*)primitivePurchasedForShareResult;
- (void)setPrimitivePurchasedForShareResult:(NSNumber*)value;

- (BOOL)primitivePurchasedForShareResultValue;
- (void)setPrimitivePurchasedForShareResultValue:(BOOL)value_;




- (NSNumber*)primitivePurchasedToRemoveAds;
- (void)setPrimitivePurchasedToRemoveAds:(NSNumber*)value;

- (BOOL)primitivePurchasedToRemoveAdsValue;
- (void)setPrimitivePurchasedToRemoveAdsValue:(BOOL)value_;




- (NSString*)primitiveUserName;
- (void)setPrimitiveUserName:(NSString*)value;





- (NSMutableSet*)primitiveProfile;
- (void)setPrimitiveProfile:(NSMutableSet*)value;


@end
