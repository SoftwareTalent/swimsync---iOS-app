// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MYSMeet.h instead.

#import <CoreData/CoreData.h>


extern const struct MYSMeetAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *courseType;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *enteredDate;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *title;
} MYSMeetAttributes;

extern const struct MYSMeetRelationships {
	__unsafe_unretained NSString *qualifytimes;
	__unsafe_unretained NSString *times;
} MYSMeetRelationships;

extern const struct MYSMeetFetchedProperties {
} MYSMeetFetchedProperties;

@class MYSQualifyTime;
@class MYSTime;










@interface MYSMeetID : NSManagedObjectID {}
@end

@interface _MYSMeet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MYSMeetID*)objectID;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* courseType;



@property int16_t courseTypeValue;
- (int16_t)courseTypeValue;
- (void)setCourseTypeValue:(int16_t)value_;

//- (BOOL)validateCourseType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* enteredDate;



//- (BOOL)validateEnteredDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *qualifytimes;

- (NSMutableSet*)qualifytimesSet;




@property (nonatomic, strong) NSSet *times;

- (NSMutableSet*)timesSet;





@end

@interface _MYSMeet (CoreDataGeneratedAccessors)

- (void)addQualifytimes:(NSSet*)value_;
- (void)removeQualifytimes:(NSSet*)value_;
- (void)addQualifytimesObject:(MYSQualifyTime*)value_;
- (void)removeQualifytimesObject:(MYSQualifyTime*)value_;

- (void)addTimes:(NSSet*)value_;
- (void)removeTimes:(NSSet*)value_;
- (void)addTimesObject:(MYSTime*)value_;
- (void)removeTimesObject:(MYSTime*)value_;

@end

@interface _MYSMeet (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSNumber*)primitiveCourseType;
- (void)setPrimitiveCourseType:(NSNumber*)value;

- (int16_t)primitiveCourseTypeValue;
- (void)setPrimitiveCourseTypeValue:(int16_t)value_;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveEnteredDate;
- (void)setPrimitiveEnteredDate:(NSDate*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitiveQualifytimes;
- (void)setPrimitiveQualifytimes:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTimes;
- (void)setPrimitiveTimes:(NSMutableSet*)value;


@end
