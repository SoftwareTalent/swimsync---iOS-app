// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSTime.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSTimeAttributes {
	__unsafe_unretained NSString *course;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *reactionTime;
	__unsafe_unretained NSString *stage;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *stroke;
	__unsafe_unretained NSString *time;
} MYSTimeAttributes;

extern const struct MYSTimeRelationships {
	__unsafe_unretained NSString *laps;
	__unsafe_unretained NSString *meet;
	__unsafe_unretained NSString *profile;
} MYSTimeRelationships;

extern const struct MYSTimeFetchedProperties {
} MYSTimeFetchedProperties;

@class MYSLap;
@class MYSMeet;
@class MYSProfile;










@interface MYSTimeID : NSManagedObjectID {}
@end

@interface _MYSTime : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSTimeID*)objectID;





@property (nonatomic, strong) NSNumber* course;



@property int32_t courseValue;
- (int32_t)courseValue;
- (void)setCourseValue:(int32_t)value_;

//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* reactionTime;



@property int64_t reactionTimeValue;
- (int64_t)reactionTimeValue;
- (void)setReactionTimeValue:(int64_t)value_;

//- (BOOL)validateReactionTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* stage;



@property int16_t stageValue;
- (int16_t)stageValue;
- (void)setStageValue:(int16_t)value_;

//- (BOOL)validateStage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* stroke;



@property int32_t strokeValue;
- (int32_t)strokeValue;
- (void)setStrokeValue:(int32_t)value_;

//- (BOOL)validateStroke:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* time;



@property int64_t timeValue;
- (int64_t)timeValue;
- (void)setTimeValue:(int64_t)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *laps;

- (NSMutableSet*)lapsSet;




@property (nonatomic, strong) MYSMeet *meet;

//- (BOOL)validateMeet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) MYSProfile *profile;

//- (BOOL)validateProfile:(id*)value_ error:(NSError**)error_;





@end

@interface _MYSTime (CoreDataGeneratedAccessors)

- (void)addLaps:(NSSet*)value_;
- (void)removeLaps:(NSSet*)value_;
- (void)addLapsObject:(MYSLap*)value_;
- (void)removeLapsObject:(MYSLap*)value_;

@end

@interface _MYSTime (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCourse;
- (void)setPrimitiveCourse:(NSNumber*)value;

- (int32_t)primitiveCourseValue;
- (void)setPrimitiveCourseValue:(int32_t)value_;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSNumber*)primitiveReactionTime;
- (void)setPrimitiveReactionTime:(NSNumber*)value;

- (int64_t)primitiveReactionTimeValue;
- (void)setPrimitiveReactionTimeValue:(int64_t)value_;




- (NSNumber*)primitiveStage;
- (void)setPrimitiveStage:(NSNumber*)value;

- (int16_t)primitiveStageValue;
- (void)setPrimitiveStageValue:(int16_t)value_;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSNumber*)primitiveStroke;
- (void)setPrimitiveStroke:(NSNumber*)value;

- (int32_t)primitiveStrokeValue;
- (void)setPrimitiveStrokeValue:(int32_t)value_;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (int64_t)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(int64_t)value_;





- (NSMutableSet*)primitiveLaps;
- (void)setPrimitiveLaps:(NSMutableSet*)value;



- (MYSMeet*)primitiveMeet;
- (void)setPrimitiveMeet:(MYSMeet*)value;



- (MYSProfile*)primitiveProfile;
- (void)setPrimitiveProfile:(MYSProfile*)value;


@end
