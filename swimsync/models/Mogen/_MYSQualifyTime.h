// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSQualifyTime.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSQualifyTimeAttributes {
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} MYSQualifyTimeAttributes;

extern const struct MYSQualifyTimeRelationships {
	__unsafe_unretained NSString *events;
	__unsafe_unretained NSString *meet;
} MYSQualifyTimeRelationships;

extern const struct MYSQualifyTimeFetchedProperties {
} MYSQualifyTimeFetchedProperties;

@class MYSEvent;
@class MYSMeet;





@interface MYSQualifyTimeID : NSManagedObjectID {}
@end

@interface _MYSQualifyTime : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSQualifyTimeID*)objectID;





@property (nonatomic, strong) NSNumber* gender;



@property int16_t genderValue;
- (int16_t)genderValue;
- (void)setGenderValue:(int16_t)value_;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *events;

- (NSMutableSet*)eventsSet;




@property (nonatomic, strong) MYSMeet *meet;

//- (BOOL)validateMeet:(id*)value_ error:(NSError**)error_;





@end

@interface _MYSQualifyTime (CoreDataGeneratedAccessors)

- (void)addEvents:(NSSet*)value_;
- (void)removeEvents:(NSSet*)value_;
- (void)addEventsObject:(MYSEvent*)value_;
- (void)removeEventsObject:(MYSEvent*)value_;

@end

@interface _MYSQualifyTime (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveGender;
- (void)setPrimitiveGender:(NSNumber*)value;

- (int16_t)primitiveGenderValue;
- (void)setPrimitiveGenderValue:(int16_t)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveEvents;
- (void)setPrimitiveEvents:(NSMutableSet*)value;



- (MYSMeet*)primitiveMeet;
- (void)setPrimitiveMeet:(MYSMeet*)value;


@end
