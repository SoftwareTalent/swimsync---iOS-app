// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSDistance.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSDistanceAttributes {
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *enteredDate;
} MYSDistanceAttributes;

extern const struct MYSDistanceRelationships {
} MYSDistanceRelationships;

extern const struct MYSDistanceFetchedProperties {
} MYSDistanceFetchedProperties;





@interface MYSDistanceID : NSManagedObjectID {}
@end

@interface _MYSDistance : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSDistanceID*)objectID;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* enteredDate;



//- (BOOL)validateEnteredDate:(id*)value_ error:(NSError**)error_;






@end

@interface _MYSDistance (CoreDataGeneratedAccessors)

@end

@interface _MYSDistance (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSDate*)primitiveEnteredDate;
- (void)setPrimitiveEnteredDate:(NSDate*)value;




@end
