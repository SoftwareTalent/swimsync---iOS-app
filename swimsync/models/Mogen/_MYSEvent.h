// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSEventAttributes {
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *stroke;
	__unsafe_unretained NSString *time;
} MYSEventAttributes;

extern const struct MYSEventRelationships {
	__unsafe_unretained NSString *qualifytime;
} MYSEventRelationships;

extern const struct MYSEventFetchedProperties {
} MYSEventFetchedProperties;

@class MYSQualifyTime;






@interface MYSEventID : NSManagedObjectID {}
@end

@interface _MYSEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSEventID*)objectID;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* stroke;



@property int16_t strokeValue;
- (int16_t)strokeValue;
- (void)setStrokeValue:(int16_t)value_;

//- (BOOL)validateStroke:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* time;



@property int64_t timeValue;
- (int64_t)timeValue;
- (void)setTimeValue:(int64_t)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MYSQualifyTime *qualifytime;

//- (BOOL)validateQualifytime:(id*)value_ error:(NSError**)error_;





@end

@interface _MYSEvent (CoreDataGeneratedAccessors)

@end

@interface _MYSEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveStroke;
- (void)setPrimitiveStroke:(NSNumber*)value;

- (int16_t)primitiveStrokeValue;
- (void)setPrimitiveStrokeValue:(int16_t)value_;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (int64_t)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(int64_t)value_;





- (MYSQualifyTime*)primitiveQualifytime;
- (void)setPrimitiveQualifytime:(MYSQualifyTime*)value;


@end
