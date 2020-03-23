// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSStopWatch.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSStopWatchAttributes {
	__unsafe_unretained NSString *lapStartDate;
	__unsafe_unretained NSString *lapTime;
	__unsafe_unretained NSString *running;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *time;
} MYSStopWatchAttributes;

extern const struct MYSStopWatchRelationships {
	__unsafe_unretained NSString *laps;
} MYSStopWatchRelationships;

extern const struct MYSStopWatchFetchedProperties {
} MYSStopWatchFetchedProperties;

@class MYSLap;







@interface MYSStopWatchID : NSManagedObjectID {}
@end

@interface _MYSStopWatch : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSStopWatchID*)objectID;





@property (nonatomic, strong) NSDate* lapStartDate;



//- (BOOL)validateLapStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lapTime;



@property float lapTimeValue;
- (float)lapTimeValue;
- (void)setLapTimeValue:(float)value_;

//- (BOOL)validateLapTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* running;



@property BOOL runningValue;
- (BOOL)runningValue;
- (void)setRunningValue:(BOOL)value_;

//- (BOOL)validateRunning:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* time;



@property float timeValue;
- (float)timeValue;
- (void)setTimeValue:(float)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *laps;

- (NSMutableSet*)lapsSet;





@end

@interface _MYSStopWatch (CoreDataGeneratedAccessors)

- (void)addLaps:(NSSet*)value_;
- (void)removeLaps:(NSSet*)value_;
- (void)addLapsObject:(MYSLap*)value_;
- (void)removeLapsObject:(MYSLap*)value_;

@end

@interface _MYSStopWatch (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveLapStartDate;
- (void)setPrimitiveLapStartDate:(NSDate*)value;




- (NSNumber*)primitiveLapTime;
- (void)setPrimitiveLapTime:(NSNumber*)value;

- (float)primitiveLapTimeValue;
- (void)setPrimitiveLapTimeValue:(float)value_;




- (NSNumber*)primitiveRunning;
- (void)setPrimitiveRunning:(NSNumber*)value;

- (BOOL)primitiveRunningValue;
- (void)setPrimitiveRunningValue:(BOOL)value_;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (float)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(float)value_;





- (NSMutableSet*)primitiveLaps;
- (void)setPrimitiveLaps:(NSMutableSet*)value;


@end
