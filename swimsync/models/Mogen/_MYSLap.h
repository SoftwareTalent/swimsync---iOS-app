// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSLap.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSLapAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *lapNumber;
	__unsafe_unretained NSString *splitTime;
} MYSLapAttributes;

extern const struct MYSLapRelationships {
	__unsafe_unretained NSString *stopwatch;
	__unsafe_unretained NSString *time;
} MYSLapRelationships;

extern const struct MYSLapFetchedProperties {
} MYSLapFetchedProperties;

@class MYSStopWatch;
@class MYSTime;





@interface MYSLapID : NSManagedObjectID {}
@end

@interface _MYSLap : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSLapID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lapNumber;



@property int64_t lapNumberValue;
- (int64_t)lapNumberValue;
- (void)setLapNumberValue:(int64_t)value_;

//- (BOOL)validateLapNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* splitTime;



@property int64_t splitTimeValue;
- (int64_t)splitTimeValue;
- (void)setSplitTimeValue:(int64_t)value_;

//- (BOOL)validateSplitTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MYSStopWatch *stopwatch;

//- (BOOL)validateStopwatch:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) MYSTime *time;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@end

@interface _MYSLap (CoreDataGeneratedAccessors)

@end

@interface _MYSLap (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSNumber*)primitiveLapNumber;
- (void)setPrimitiveLapNumber:(NSNumber*)value;

- (int64_t)primitiveLapNumberValue;
- (void)setPrimitiveLapNumberValue:(int64_t)value_;




- (NSNumber*)primitiveSplitTime;
- (void)setPrimitiveSplitTime:(NSNumber*)value;

- (int64_t)primitiveSplitTimeValue;
- (void)setPrimitiveSplitTimeValue:(int64_t)value_;





- (MYSStopWatch*)primitiveStopwatch;
- (void)setPrimitiveStopwatch:(MYSStopWatch*)value;



- (MYSTime*)primitiveTime;
- (void)setPrimitiveTime:(MYSTime*)value;


@end
