//
//  MYSDataManager.h
//  MySwimTimes
//
//  Created by SmarterApps on 3/7/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This class is used for storing data which is shared when app is run
 */

#import <Foundation/Foundation.h>
#import "MYSLap.h"
#import "MYSTime.h"
#import "MYSStopWatch.h"
#import "MYSMeet.h"
#import "MYSDistance.h"
#import "MYSQualifyTime.h"
#import "MYSEvent.h"
#import "MYSProfile.h"
#import "MYSProfileInfo.h"
#import "MYSGoalTime.h"

#import "MYSLapInfo.h"
#import "MYSInstructorProfile.h"

typedef NS_ENUM (NSInteger, MYSTimeStatus) {
    MYSTimeStatusNone = 0,
    MYSTimeStatusPersionalBest = 1 << 1,
    MYSTimeStatusLatestPersionalBest = 1 << 2,
};

@interface MYSDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *currentStopwatchLapsData;
@property (nonatomic, strong) NSMutableArray *allMeets;

@property (nonatomic, strong) NSString *lastSelectedMeet;
@property (nonatomic) float *lastDistance;

@property (nonatomic, strong) MYSProfile *lastSelectedSwimmer;

+ (MYSDataManager*)shared;


- (void) save;

+ (NSString *) getCourseTypeStringFromType:(MYSCourseType)courseType;

+ (NSString *) numberStringWithCommna:(double) number;

#pragma mark - === StopWatch ===
/**
 Get current stop watch in db
 
 @return stop watch model
 */
- (MYSStopWatch *) getCurrentStopWatch;

#pragma mark - === Lap ===

/**
 Save Lap
 
 @param split time need to save for stopwatch
 */
- (MYSLap *) saveLapWithTime:(NSString*)time;

/**
 Save lap with specific time
 
 @param miliseconds miliseconds time of this lap
 @return lap object
 */
- (MYSLap *) saveLapWithMiliseconds:(int64_t) miliseconds;

/**
 Get all laps in database
 @return laps array
 */
- (NSArray *)getAllLapsInDatabase;

/**
 Get next lap in database
 @param name of lap
 @return lap object
 */
- (MYSLap *)getNextLapWithLapName:(NSString*)name;

/**
 Get previous laps in database
 
 @param lapID id of lap
 @return list of laps have lap id less than or equal lapID
 */
- (NSArray *) getPreviousLapsWithLapId:(int64_t) lapID;

/**
 Delete all laps
 @param time object
 */
- (void)deleteAllLapsWithTime:(MYSTime*)time;

/**
 Delete lap
 @param lap lap object will be deleted
 @return status delete
 */
- (BOOL) deleteLap:(MYSLap *) lap;

#pragma mark - === Meets ===

/**
 Insert new meet
 @param meet object
 */
- (MYSMeet *)insertMeetWithTitle:(NSString *)title location:(NSString *)location city:(NSString *)city startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate courseType:(int16_t)coursetype;

/**
 Get all meets in database
 @return meets array
 */
- (NSArray *)getAllMeetsInDatabase;

/**
 Delete meet in database
 @param meet object
 */
- (void)deleteMeet:(MYSMeet*)meet;

/**
 Get meet object
 @param meet id
 @return meet object
 */
- (MYSMeet*)getMeetWithID:(NSInteger)meetID;


- (MYSMeet*)getMeetWithTitle:(NSString *)meetTitle;
/**
 Fetch all meets in database
 
 @return fectched results controller contains all meet data
 */
- (NSFetchedResultsController *) fetchAllMeets;

/**
 Get all meets in database
 
 @return all meets data in database
 */
- (NSArray *) getAllMeets;

/**
 Get last entered meet
 
 @return last entered meet
 */
- (MYSMeet *) getLastEnteredMeet;

#pragma mark - === Profile ===
- (MYSProfile *)getCurrentProfile;
- (MYSProfile *)insertProfile:(MYSProfileInfo *)profile;
- (MYSProfile *)editProfile:(MYSProfile *)profile withProfileInfo:(MYSProfileInfo *)profileInfo;
- (MYSProfile *)getProfileWithId:(NSString*)userId;
- (NSArray *)getAllProfiles;
- (BOOL)deleteProfile:(MYSProfile*)profile;

#pragma mark - === Goal Time ===

- (MYSGoalTime *) insertGoalTimeWithProfile:(MYSProfile *)profile time:(int64_t)time course:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(float)distance;

- (MYSGoalTime *)getGoalTimeOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(float)distance;

#pragma mark - === Distance ===
/**
 Save last entered distance value
 
 @param distance distance value
 */
- (void) setLastEnteredDistance:(CGFloat) distance;

/**
 Get last entered distance value
 
 @return last entered distance value
 */
- (CGFloat) getLastEnteredDistance;

#pragma mark - === Stroke ===
/**
 Get stroke name by type
 
 @param strokeType stroke type. See MYSStrokeTypes
 
 @return stroke name corresponding with stroke type
 */
- (NSString *) getStrokeNameByType:(MYSStrokeTypes) strokeType;
- (NSString *) getFullStrokeNameByType:(MYSStrokeTypes) strokeType;
- (UIImage *) getStrokeIconByType:(MYSStrokeTypes) strokeType;
- (UIImage *)getUnSelectStrokeIconByType:(MYSStrokeTypes)strokeType;

#pragma mark - === Time ===

/**
 Insert new time
 
 @param meet meet info
 
 @param course course of this time. See MYSCourseType
 
 @param distance distance of swim
 
 @param stroke stroke type. See MYSStrokeTypes
 
 @param reactionTime reaction time date
 
 @param milisecondTime miliseconds time for this times
 
 @param date date of times was created
 
 @return a time object
 */
- (MYSTime *) insertTimeWithMeet:(MYSMeet *) meet course:(MYSCourseType) courseType distance:(CGFloat) distance stroke:(MYSStrokeTypes) stroke reactionTime:(int64_t) reactionTime time:(int64_t) milisecondTime date:(NSDate *) date;

- (MYSTime *) insertTimeWithMeet:(MYSMeet *) meet swimmer:(MYSProfile *)swimmer course:(MYSCourseType) courseType distance:(CGFloat) distance stroke:(MYSStrokeTypes) stroke reactionTime:(int64_t) reactionTime time:(int64_t) milisecondTime stage:(int16_t)stage date:(NSDate *) date;

- (BOOL) deleteTime:(MYSTime *)time;

/**
 Get all times in database
 
 @return all times data in database
 */
- (NSArray *)getAllTimesInDatabase;
- (NSMutableArray *)getBestTimes;
- (NSMutableArray *)getBestTime2;
- (MYSTime *)getPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke;

- (NSArray *)getAllPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke;

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke;

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withStroke:(MYSStrokeTypes)stroke;

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withMeet:(MYSMeet *)meet;

- (NSArray *)getAllTimeOfMeet:(MYSMeet *)meet;

- (void) updateAllTimesOfMeet:(MYSMeet *)meet;

#pragma mark - === Qualifying Time ===

/**
 Insert new qualifying time
 @param qualifying time object
 */
- (void)insertQualifyingTimeWithGender:(NSInteger)gender name:(NSString*)name event:(MYSEvent*)event andMeet:(MYSMeet*)meet;

- (MYSQualifyTime *)insertQualifyingTimeWithGender:(NSInteger)gender name:(NSString *)name andMeet:(MYSMeet *)meet;

- (MYSQualifyTime *)getQualifyTimeWithGender:(NSInteger)gender name:(NSString *)name;

- (MYSQualifyTime *)getQualifyTimeWithGender:(NSInteger)gender name:(NSString *)name ofMeet:(MYSMeet *)meet;

/**
 Get fetched all qualifying time group by gender
 
 @param meet id of meet need to get all qualifying time
 
 @return Fetched results controller object which contains the results returned from a Core Data fetch request
 */
- (NSFetchedResultsController*)fetchedAllQualifyingTimeGroupByGenderWithMeetID:(NSInteger)meetID;
- (NSArray *)getAllQualifyingTimeGroupByGenderWithMeetID:(MYSMeet *)meet;

#pragma mark - === Event ===

/**
 Insert new event
 @param event data
 @return event object
 */
- (MYSEvent*)insertEventWithStroke:(MYSStrokeTypes)strokeType distance:(CGFloat)distance time:(NSInteger)time;

- (NSArray *)getAllEventOfMeet:(MYSMeet *)meet;

- (MYSEvent *)getEventWithCourse:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(CGFloat)distance gender:(int)gender;

- (MYSEvent *)getEventWithStroke:(MYSStrokeTypes)stroke distance:(CGFloat)distance gender:(int)gender age:(NSString *)name ofMeet:(MYSMeet *)meet;

- (MYSTime *)getLatestPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke;

- (void) updateLocalNotifications;



- (MYSInstructorProfile *) logInInstructorWithUserName : (NSString*)userName andPassword : (NSString*)password ;
- (MYSInstructorProfile *) getInstructorProfileWithID : (NSString*)instructoreID;
- (MYSInstructorProfile *) getInstructorProfileWithData : (NSDictionary*)instructorInfo;
- (void) checkAndAddAllExistingSwimmersToInstructor : (MYSInstructorProfile*) instructor;
- (void) saveAllSwimSyncResult : (NSDictionary*)resultData;
- (void) saveAllPBTimesResult : (NSDictionary*)resultData;
- (void) saveAllMeetResult : (NSDictionary*)resultData;
- (void) saveOtherTimesResult : (NSDictionary*)resultData;
- (NSInteger) getCountOfInstructor;
- (void) removePreviousInstructroIfAny;
@end
