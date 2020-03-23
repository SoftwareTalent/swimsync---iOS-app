// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSGoalTime.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSGoalTimeAttributes {
	__unsafe_unretained NSString *courseType;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *stroke;
	__unsafe_unretained NSString *time;
} MYSGoalTimeAttributes;

extern const struct MYSGoalTimeRelationships {
	__unsafe_unretained NSString *profile;
} MYSGoalTimeRelationships;

extern const struct MYSGoalTimeFetchedProperties {
} MYSGoalTimeFetchedProperties;

@class MYSProfile;






@interface MYSGoalTimeID : NSManagedObjectID {}
@end

@interface _MYSGoalTime : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSGoalTimeID*)objectID;





@property (nonatomic, strong) NSNumber* courseType;



@property int16_t courseTypeValue;
- (int16_t)courseTypeValue;
- (void)setCourseTypeValue:(int16_t)value_;

//- (BOOL)validateCourseType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property int64_t distanceValue;
- (int64_t)distanceValue;
- (void)setDistanceValue:(int64_t)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) MYSProfile *profile;

//- (BOOL)validateProfile:(id*)value_ error:(NSError**)error_;





@end

@interface _MYSGoalTime (CoreDataGeneratedAccessors)

@end

@interface _MYSGoalTime (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCourseType;
- (void)setPrimitiveCourseType:(NSNumber*)value;

- (int16_t)primitiveCourseTypeValue;
- (void)setPrimitiveCourseTypeValue:(int16_t)value_;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (int64_t)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(int64_t)value_;




- (NSNumber*)primitiveStroke;
- (void)setPrimitiveStroke:(NSNumber*)value;

- (int32_t)primitiveStrokeValue;
- (void)setPrimitiveStrokeValue:(int32_t)value_;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (int64_t)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(int64_t)value_;





- (MYSProfile*)primitiveProfile;
- (void)setPrimitiveProfile:(MYSProfile*)value;


@end
