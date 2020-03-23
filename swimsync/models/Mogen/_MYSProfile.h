// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSProfile.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSProfileAttributes {
	__unsafe_unretained NSString *birthday;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *nameSwimClub;
	__unsafe_unretained NSString *userid;
} MYSProfileAttributes;

extern const struct MYSProfileRelationships {
	__unsafe_unretained NSString *goaltime;
	__unsafe_unretained NSString *instructor;
	__unsafe_unretained NSString *time;
} MYSProfileRelationships;

extern const struct MYSProfileFetchedProperties {
} MYSProfileFetchedProperties;

@class MYSGoalTime;
@class MYSInstructorProfile;
@class MYSTime;










@interface MYSProfileID : NSManagedObjectID {}
@end

@interface _MYSProfile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSProfileID*)objectID;





@property (nonatomic, strong) NSDate* birthday;



//- (BOOL)validateBirthday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* gender;



@property int16_t genderValue;
- (int16_t)genderValue;
- (void)setGenderValue:(int16_t)value_;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nameSwimClub;



//- (BOOL)validateNameSwimClub:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userid;



@property int64_t useridValue;
- (int64_t)useridValue;
- (void)setUseridValue:(int64_t)value_;

//- (BOOL)validateUserid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *goaltime;

- (NSMutableSet*)goaltimeSet;




@property (nonatomic, strong) MYSInstructorProfile *instructor;

//- (BOOL)validateInstructor:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *time;

- (NSMutableSet*)timeSet;





@end

@interface _MYSProfile (CoreDataGeneratedAccessors)

- (void)addGoaltime:(NSSet*)value_;
- (void)removeGoaltime:(NSSet*)value_;
- (void)addGoaltimeObject:(MYSGoalTime*)value_;
- (void)removeGoaltimeObject:(MYSGoalTime*)value_;

- (void)addTime:(NSSet*)value_;
- (void)removeTime:(NSSet*)value_;
- (void)addTimeObject:(MYSTime*)value_;
- (void)removeTimeObject:(MYSTime*)value_;

@end

@interface _MYSProfile (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthday;
- (void)setPrimitiveBirthday:(NSDate*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSNumber*)primitiveGender;
- (void)setPrimitiveGender:(NSNumber*)value;

- (int16_t)primitiveGenderValue;
- (void)setPrimitiveGenderValue:(int16_t)value_;




- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveNameSwimClub;
- (void)setPrimitiveNameSwimClub:(NSString*)value;




- (NSNumber*)primitiveUserid;
- (void)setPrimitiveUserid:(NSNumber*)value;

- (int64_t)primitiveUseridValue;
- (void)setPrimitiveUseridValue:(int64_t)value_;





- (NSMutableSet*)primitiveGoaltime;
- (void)setPrimitiveGoaltime:(NSMutableSet*)value;



- (MYSInstructorProfile*)primitiveInstructor;
- (void)setPrimitiveInstructor:(MYSInstructorProfile*)value;



- (NSMutableSet*)primitiveTime;
- (void)setPrimitiveTime:(NSMutableSet*)value;


@end
