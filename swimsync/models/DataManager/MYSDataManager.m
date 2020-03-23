//
//  MYSDataManager.m
//  MySwimTimes
//
//  Created by SmarterApps on 3/7/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSDataManager.h"
#import "MYSBestTime.h"
#import "MYSGoalTimeInfo.h"

#import <UIKit/UIKit.h>

@implementation MYSDataManager

+ (MYSDataManager *)shared
{
    __strong static MYSDataManager *_sharedLocalSystem = nil;
    
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedLocalSystem = [[self alloc] initPrivate];
    });
    return _sharedLocalSystem;
    
}

- (id) initPrivate
{
    self = [super init];
    if(self)
    {
        // Init your data here
        _currentStopwatchLapsData = [NSMutableArray array];
        _allMeets = [NSMutableArray arrayWithArray:[self getAllMeets]];
    }
    return self;
}

- (id)init
{
    @throw @"Please use the singleton.";
}

#pragma mark - === Save ===

- (void) save {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context MR_saveToPersistentStoreAndWait];
}

+ (NSString *) getCourseTypeStringFromType:(MYSCourseType)courseType
{
    if(courseType == MYSCourseType_Short)
        return @"Short course";
    else if(courseType == MYSCourseType_Long)
        return @"Long course";
    
    return @"Open water";
}

+ (NSString *) numberStringWithCommna:(double) number
{
    NSNumber* number_ = [NSNumber numberWithDouble:number];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    NSString* commaString = [numberFormatter stringForObjectValue:number_];
    
    return commaString;
}

#pragma mark - === Lap ===

- (MYSLap *) saveLapWithTime:(NSString*)time{
    MYSLap *lap = [MYSLap MR_createEntity];
    lap.idValue = [MethodHelper generateTempID];
    
    lap.splitTimeValue = [MYSLap milisecondsFromLapTime:time];
    
    [self save];
    
    return lap;
}

-(MYSLap *)saveLapWithMiliseconds:(int64_t)miliseconds {
    MYSLap *lap = [MYSLap MR_createEntity];
    lap.idValue = [MethodHelper generateTempID];
    
    lap.splitTimeValue = miliseconds;
    
    [self save];
    
    return lap;
}

- (NSArray *)getAllLapsInDatabase{
    return [MYSLap MR_findAll];
}

- (NSArray *) getAllStopWatchLaps:(MYSStopWatch *) stopWatch {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:MYSLapAttributes.id ascending:YES];
    return [stopWatch.laps.allObjects sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (MYSLap *)getNextLapWithLapName:(NSString *)name{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MYSLapAttributes.id, name];
    MYSLap *lap = [MYSLap MR_findFirstWithPredicate:predicate];
    return lap;
}

- (void)deleteAllLapsWithTime:(MYSTime *)time{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MYSTimeAttributes.time, time.time];
    [MYSLap MR_deleteAllMatchingPredicate:nil];
}

- (NSArray *) getPreviousLapsWithLapId:(int64_t) lapID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K <= %lld", MYSLapAttributes.id, lapID];
    NSArray *previousLaps = [MYSLap MR_findAllWithPredicate:predicate];
    return previousLaps;
}

-(BOOL)deleteLap:(MYSLap *)lap {
    return [lap MR_deleteEntity];
}

#pragma mark - === StopWatch ===
-(MYSStopWatch *)getCurrentStopWatch {
    MYSStopWatch *stopWatch = nil;
    
    stopWatch = [MYSStopWatch MR_findFirst];
    if (stopWatch == nil) {
        stopWatch = [MYSStopWatch MR_createEntity];
    }
    
    return stopWatch;
}

#pragma mark - === Meets ===

- (MYSMeet *)insertMeetWithTitle:(NSString *)title location:(NSString *)location city:(NSString *)city startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate courseType:(int16_t)coursetype{
    
    // Create new meet
    MYSMeet *meet = [MYSMeet MR_createEntity];
    int64_t meetID = [MethodHelper generateTempID];
    meet.id = [NSNumber numberWithLongLong:meetID];
    meet.title = title;
    meet.location = location;
    meet.city = city;
    meet.startDate = startDate;
    meet.endDate = endDate;
    meet.courseType = [NSNumber numberWithInt:coursetype];
    
    // Save
    [self save];
    
    return meet;
}

- (NSArray *)getAllMeetsInDatabase{
    return [MYSMeet MR_findAll];
}

- (void)deleteMeet:(MYSMeet*)meet {
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", MYSMeetAttributes.id, meet.idValue];
    //    [MYSMeet MR_deleteAllMatchingPredicate:predicate];
    for (MYSQualifyTime *qualify in meet.qualifytimes) {
        for (MYSEvent *event in qualify.eventsSet) {
            [event MR_deleteEntity];
        }
        [qualify MR_deleteEntity];
    }
    [meet MR_deleteEntity];
    
    [[MYSDataManager shared] save];
}

- (MYSMeet *)getMeetWithID:(NSInteger)meetID{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", MYSMeetAttributes.id, meetID];
    return [MYSMeet MR_findFirstWithPredicate:predicate];
}

- (MYSMeet*)getMeetWithTitle:(NSString *)meetTitle
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MYSMeetAttributes.title, meetTitle];
    return [MYSMeet MR_findFirstWithPredicate:predicate];
}

-(NSFetchedResultsController *)fetchAllMeets {
    NSFetchedResultsController *fetchedAllMeets = [MYSMeet MR_fetchAllSortedBy:MYSMeetAttributes.title ascending:YES withPredicate:nil groupBy:nil delegate:nil];
    return fetchedAllMeets;
}

- (NSArray *) getAllMeets {
    return [MYSMeet MR_findAll];
}

- (MYSMeet *) getLastEnteredMeet {
    MYSMeet *meet = [MYSMeet MR_findFirstOrderedByAttribute:MYSMeetAttributes.enteredDate ascending:NO];
    
    return meet;
}


#pragma mark - === Profile ===

- (MYSProfile *)insertProfile:(MYSProfileInfo *)profile {
    
    // Create new profile
    MYSProfile* newProfile = [MYSProfile MR_createEntity];
    
    //    [[[MYSAppData sharedInstance] appInstructor] addProfileObject:newProfile];
    
    return [self saveProfile:newProfile fromProfileInfo:profile];
}

- (MYSProfile *)editProfile:(MYSProfile *)profile withProfileInfo:(MYSProfileInfo *)profileInfo {
    return [self saveProfile:profile fromProfileInfo:profileInfo];
}

- (MYSProfile *)saveProfile:(MYSProfile *)newProfile fromProfileInfo:(MYSProfileInfo *)profile {
    
    newProfile.userid = [NSNumber numberWithLong:profile.userId];
    newProfile.image = UIImagePNGRepresentation(profile.image);
    newProfile.name = profile.name;
    newProfile.birthday = [MethodHelper getDateFullMonth:profile.birthday];
    newProfile.gender = [NSNumber numberWithInt:profile.gender];
    newProfile.nameSwimClub = profile.nameSwimClub;
    newProfile.city = profile.city;
    newProfile.country = profile.country;
    
    NSMutableSet *arraySet = [[NSMutableSet alloc] init];
    for (MYSGoalTimeInfo *goalTimeInfo in profile.goalTimes) {
        MYSGoalTime *goalTime = [MYSGoalTime MR_createEntity];
        goalTime.time = [NSNumber numberWithLongLong:goalTimeInfo.time];
        goalTime.stroke = [NSNumber numberWithInt:goalTimeInfo.stroke];
        goalTime.distance = [NSNumber numberWithFloat:goalTimeInfo.distance];
        [arraySet addObject:goalTime];
    }
    
    newProfile.goaltime = [NSSet setWithSet:arraySet];
    
    // Save
    [self save];
    
    return newProfile;
}

- (MYSProfile *)getCurrentProfile {
    NSString* profileID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentProfile];
    //    NSString* profileID = [[[MYSAppData sharedInstance] appInstructor] currentProfile];
    return [self getProfileWithId:profileID];
}

- (MYSProfile *)getProfileWithId:(NSString*)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MYSProfileAttributes.userid, userId];
    MYSProfile *profile = [MYSProfile MR_findFirstWithPredicate:predicate];
    return profile;
}

- (NSArray *)getAllProfiles{
    return [MYSProfile MR_findAll];
}

- (BOOL)deleteProfile:(MYSProfile*)profile{
    NSString* curProfile = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentProfile];
    //    NSString* curProfile = [[[MYSAppData sharedInstance] appInstructor] currentProfile];
    
    NSString* deleteProfile = [NSString stringWithFormat:@"%@", profile.userid];
    
    BOOL rs = [profile MR_deleteEntity];
    
    if ([curProfile isEqualToString:deleteProfile]) {
        NSArray* array = [self getAllProfiles];
        NSString* str;
        if ([array count] != 0) {
            str = [NSString stringWithFormat:@"%@", ((MYSProfile*)array[0]).userid];
        } else {
            str = @"";
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:kCurrentProfile];
        //        [[[MYSAppData sharedInstance] appInstructor] setCurrentProfile:str];
    }
    
    return rs;
}

- (MYSGoalTime *) insertGoalTimeWithProfile:(MYSProfile *)profile time:(int64_t)time course:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(float)distance
{
    MYSGoalTime *goaltime = [MYSGoalTime MR_createEntity];
    
    goaltime.profile = profile;
    goaltime.distance = [NSNumber numberWithFloat:distance];
    goaltime.time = [NSNumber numberWithLongLong:time];
    goaltime.stroke = [NSNumber numberWithLongLong:stroke];
    goaltime.courseType = [NSNumber numberWithInt:courseType];
    
    [self save];
    
    return goaltime;
}

- (MYSGoalTime *)getGoalTimeOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(float)distance
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %f", @"stroke", stroke, @"distance", distance];
    
    NSArray *array = [MYSGoalTime MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    
    for (MYSGoalTime *goal in array) {
        if (goal.profile == profile && [goal.courseType intValue] == courseType) {
            return goal;
        }
    }
    return nil;
}

#pragma mark - === Distance ===
-(void)setLastEnteredDistance:(CGFloat)distance {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %f", MYSDistanceAttributes.distance, distance];
    MYSDistance *distanceObj = [MYSDistance MR_findFirstWithPredicate:predicate];
    if (distanceObj) {
        distanceObj.enteredDate = [NSDate date];
    } else {
        distanceObj = [MYSDistance MR_createEntity];
        distanceObj.distanceValue = distance;
        distanceObj.enteredDate = [NSDate date];
    }
}

-(CGFloat)getLastEnteredDistance {
    MYSDistance *distance = [MYSDistance MR_findFirstOrderedByAttribute:MYSDistanceAttributes.enteredDate ascending:YES];
    if (distance) {
        return distance.distanceValue;
    } else {
        return DISTANCE_DEFAULT_VALUE;
    }
}

#pragma mark - === Stroke ===
-(NSString *)getStrokeNameByType:(MYSStrokeTypes)strokeType {
    switch (strokeType) {
        case MYSStroke_FLY:
        {
            return MTLocalizedString(@"FLY");
        }
            break;
            
        case MYSStroke_IM:
        {
            return MTLocalizedString(@"IM");
        }
            break;
            
        case MYSStroke_BK:
        {
            return MTLocalizedString(@"BK");
        }
            break;
            
        case MYSStroke_BR:
        {
            return MTLocalizedString(@"BR");
        }
            break;
            
        case MYSStroke_FR:
        {
            return MTLocalizedString(@"FR");
        }
            break;
            
        default:
            return MTLocalizedString(@"Unknown");
            break;
    }
}

-(NSString *)getFullStrokeNameByType:(MYSStrokeTypes)strokeType {
    switch (strokeType) {
        case MYSStroke_FLY:
        {
            return MTLocalizedString(@"Butterfly");
        }
            break;
            
        case MYSStroke_IM:
        {
            return MTLocalizedString(@"Individual Medley");
        }
            break;
            
        case MYSStroke_BK:
        {
            return MTLocalizedString(@"Backstroke");
        }
            break;
            
        case MYSStroke_BR:
        {
            return MTLocalizedString(@"Breaststroke");
        }
            break;
            
        case MYSStroke_FR:
        {
            return MTLocalizedString(@"Freestyle");
        }
            break;
            
        default:
            return MTLocalizedString(@"Unknown");
            break;
    }
}

-(UIImage *)getStrokeIconByType:(MYSStrokeTypes)strokeType {
    NSString* iconName = @"";
    switch (strokeType) {
        case MYSStroke_FLY:
        {
            iconName = MTLocalizedString(@"icon-FLY-tap");
        }
            break;
            
        case MYSStroke_IM:
        {
            iconName = MTLocalizedString(@"icon-IM-tap");
        }
            break;
            
        case MYSStroke_BK:
        {
            iconName = MTLocalizedString(@"icon-BK-tap");
        }
            break;
            
        case MYSStroke_BR:
        {
            iconName = MTLocalizedString(@"icon-BR-tap");
        }
            break;
            
        case MYSStroke_FR:
        {
            iconName = MTLocalizedString(@"icon-FR-tap");
        }
            break;
            
        default:
            iconName = MTLocalizedString(@"Unknown");
            break;
    }
    
    UIImage* image = [UIImage imageNamed:iconName];
    return image;
}

-(UIImage *)getUnSelectStrokeIconByType:(MYSStrokeTypes)strokeType {
    NSString* iconName = @"";
    switch (strokeType) {
        case MYSStroke_FLY:
        {
            iconName = MTLocalizedString(@"icon-FLY");
        }
            break;
            
        case MYSStroke_IM:
        {
            iconName = MTLocalizedString(@"icon-IM");
        }
            break;
            
        case MYSStroke_BK:
        {
            iconName = MTLocalizedString(@"icon-BK");
        }
            break;
            
        case MYSStroke_BR:
        {
            iconName = MTLocalizedString(@"icon-BR");
        }
            break;
            
        case MYSStroke_FR:
        {
            iconName = MTLocalizedString(@"icon-FR");
        }
            break;
            
        default:
            iconName = MTLocalizedString(@"Unknown");
            break;
    }
    
    UIImage* image = [UIImage imageNamed:iconName];
    return image;
}


#pragma mark - === Time ===
-(MYSTime *)insertTimeWithMeet:(MYSMeet *)meet course:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke reactionTime:(int64_t)reactionTime time:(int64_t)milisecondTime date:(NSDate *)date{
    MYSTime *time = [MYSTime MR_createEntity];
    
    [time setMeet:meet];
    time.course = [NSNumber numberWithInt:courseType];
    time.distance = [NSNumber numberWithFloat:distance];
    time.reactionTime = [NSNumber numberWithLongLong:reactionTime];
    time.stroke = [NSNumber numberWithInt:stroke];
    time.time = [NSNumber numberWithLongLong:milisecondTime];
    time.date = date;
    
    time.profile = [self getCurrentProfile];
    
    MYSTime *pb = [self getLatestPersionalBestOfProfile:time.profile withCourse:courseType distance:distance stroke:stroke];
    if (pb == nil) {
        time.status = [NSNumber numberWithInt: MYSTimeStatusLatestPersionalBest];
    } else {
        if ([pb.time longLongValue] > milisecondTime) {
            time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
            pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
        } else {
            time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
        }
    }
    
    return time;
}

- (MYSTime *) insertTimeWithMeet:(MYSMeet *) meet swimmer:(MYSProfile *)swimmer course:(MYSCourseType) courseType distance:(CGFloat) distance stroke:(MYSStrokeTypes) stroke reactionTime:(int64_t) reactionTime time:(int64_t) milisecondTime stage:(int16_t)stage  date:(NSDate *) date
{
    MYSTime *time = [MYSTime MR_createEntity];
    
    [time setMeet:meet];
    time.course = [NSNumber numberWithInt:courseType];
    time.distance = [NSNumber numberWithFloat:distance];
    time.reactionTime = [NSNumber numberWithLongLong:reactionTime];
    time.stroke = [NSNumber numberWithInt:stroke];
    time.time = [NSNumber numberWithLongLong:milisecondTime];
    time.stage = [NSNumber numberWithInt:stage];
    time.date = date;
    
    time.profile = swimmer;
    
    MYSTime *pb = [self getLatestPersionalBestOfProfile:time.profile withCourse:courseType distance:distance stroke:stroke];
    if (pb == nil) {
        time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
    } else {
        
        int64_t pbtime = [pb.time longLongValue];
        
        if (pbtime > milisecondTime) {
            time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
            pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
        } else {
            time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
        }
    }
    
    return time;
}

- (BOOL) deleteTime:(MYSTime *)time
{
    BOOL result = [time MR_deleteEntity];
    
    if(result)
    {
        [self refreshTimeOf:time.profile withCourse:[time.course intValue] distance:[time.distance doubleValue] stroke:[time.stroke intValue]];
    }
    
    [self save];
    
    return result;
}

//<<<<<<< HEAD
//- (BOOL)isBestTime:(MYSProfile*)profile course:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke time:(int64_t)milisecondTime {
//
//    NSArray* arrayTimes = [profile.time allObjects];
//
//    for (MYSTime* time in arrayTimes) {
//        if (time.isBestTimeValue == TRUE && time.courseValue == courseType && time.distanceValue == distance && time.strokeValue == stroke && time.timeValue < milisecondTime) {
//            return FALSE;
//        }
//    }
//
//    return TRUE;
//}
//=======


- (MYSTime *)getLatestPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d && %K == %d && %K == %f", @"course", courseType, @"stroke", stroke, @"status", MYSTimeStatusLatestPersionalBest, @"distance", distance];
    
    NSArray *allResults = [MYSTime MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.profile == profile) {
            [results addObject:time];
        }
    }
    return [results firstObject];
}

- (MYSTime *)getPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke
{
    NSArray *allPersionalBest = [self getAllPersionalBestOfProfile:profile withCourse:courseType distance:distance stroke:stroke];
    if ([allPersionalBest count] > 0) {
        return [allPersionalBest firstObject];
    }
    return nil;
}

- (NSArray *)getAllPersionalBestOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d && %K == %d && %K == %f", @"course", courseType, @"stroke", stroke, @"status", MYSTimeStatusPersionalBest, @"distance", distance];
    
    NSArray *allResults = [MYSTime MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.profile == profile) {
            [results addObject:time];
        }
    }
    return results;
}

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withCourse:(MYSCourseType)courseType distance:(CGFloat)distance stroke:(MYSStrokeTypes)stroke
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d && %K == %f", @"course", courseType, @"stroke", stroke, @"distance", distance];
    
    NSArray *allResults = [MYSTime MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.profile == profile) {
            [results addObject:time];
        }
    }
    return results;
}

- (void) refreshTimeOf:(MYSProfile *)profile withCourse:(MYSCourseType) courseType distance:(CGFloat) distance stroke:(MYSStrokeTypes) stroke
{
    NSMutableArray *aryTimes = (NSMutableArray *)[self getAllTimeOfProfile:profile withCourse:courseType distance:distance stroke:stroke];
    
    MYSTime *pb = [self getLatestPersionalBestOfProfile:profile withCourse:courseType distance:distance stroke:stroke];
    
    if (pb != nil)
    {
        pb.status = [NSNumber numberWithInt:MYSTimeStatusNone];
    }
    
    for (MYSTime *time in aryTimes)
    {
        MYSTime *pb = [self getLatestPersionalBestOfProfile:profile withCourse:courseType distance:distance stroke:stroke];
        
        if (pb == nil)
        {
            time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
        }
        else
        {
            int64_t pbtime = [pb.time longLongValue];
            
            if (pbtime >= [time.time longLongValue])
            {
                time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
                pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
            } else
            {
                time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
            }
        }
    }
}

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withStroke:(MYSStrokeTypes)stroke
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"stroke", stroke];
    
    NSArray *allResults = [MYSTime MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.profile == profile) {
            [results addObject:time];
        }
    }
    return results;
}

- (NSArray *)getAllTimeOfMeet:(MYSMeet *)meet
{
    NSArray *allResults = [MYSTime MR_findAll];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.meet == meet) {
            [results addObject:time];
        }
    }
    
    return results;
}

- (void) updateAllTimesOfMeet:(MYSMeet *)meet
{
    NSMutableArray *aryTimes = (NSMutableArray *)[self getAllTimeOfMeet:meet];
    
    for (MYSTime *time in aryTimes) {
        
        MYSCourseType orginalCourseType = [time.course intValue];
        MYSCourseType newCourseType = [time.course intValue];
        
        time.course = meet.courseType;
        
        [self refreshTimeOf:time.profile withCourse:newCourseType distance:[time.distance longLongValue] stroke:[time.stroke intValue]];
        [self refreshTimeOf:time.profile withCourse:orginalCourseType  distance:[time.distance longLongValue] stroke:[time.stroke intValue]];
    }
    
    [self save];
}

- (NSArray *)getAllTimeOfProfile:(MYSProfile *)profile withMeet:(MYSMeet *)meet
{
    NSArray *allResults = [MYSTime MR_findAll];
    NSMutableArray *results = [NSMutableArray array];
    for (MYSTime *time in allResults) {
        if (time.meet == meet && time.profile == profile) {
            [results addObject:time];
        }
    }
    
    return results;
}

//>>>>>>> feature/time_detail

- (NSArray *)getAllTimesInDatabase {
    return [MYSTime MR_findAll];
}

- (NSArray *)getAllTimesOfProfile:(MYSProfile *)profile sortBy:(NSString *)column
{
    NSMutableArray *results = [NSMutableArray array];
    NSArray *allTime = [MYSTime MR_findAllSortedBy:column ascending:NO];
    for (MYSTime *time in allTime) {
        if (time.profile == profile) {
            [results addObject:time];
        }
    }
    return results;
}

- (NSMutableArray *)getBestTimes {
    NSArray* allTimes = [[self getCurrentProfile].time allObjects];
    
    // Group time by distance
    NSMutableArray* distanceArray = [[NSMutableArray alloc] init];
    
    for (MYSTime* time in allTimes) {
        BOOL isAdded = false;
        for (NSMutableArray* array in distanceArray) {
            MYSTime* oldTime = array[0];
            if ([time.distance floatValue] == [oldTime.distance floatValue]) {
                [array addObject:time];
                isAdded = TRUE;
                break;
            }
        }
        if (!isAdded) {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:time];
            [distanceArray addObject:array];
        }
    }
    
    // sort best time by stroke
    NSMutableArray* rsArray = [[NSMutableArray alloc] init];
    
    for (NSMutableArray* array in distanceArray) {
        NSMutableArray* bestTimeArray = [[NSMutableArray alloc] init];
        for (MYSTime *time in array) {
            BOOL isAdded = false;
            for (MYSBestTime* bestTime in bestTimeArray) {
                if ([bestTime isSameStroke:time]) {
                    [bestTime insertTime:time];
                    isAdded = TRUE;
                    break;
                }
            }
            if (!isAdded) {
                MYSBestTime* bestTime = [[MYSBestTime alloc] init];
                [bestTime insertTime:time];
                [bestTimeArray addObject:bestTime];
            }
        }
        [rsArray addObject:bestTimeArray];
    }
    
    for (int i = 0; i < [rsArray count]; i++) {
        for (int j = i + 1; j < [rsArray count]; j++) {
            NSMutableArray* array1 = rsArray[i];
            NSMutableArray* array2 = rsArray[j];
            MYSBestTime* bestTime1 = array1[0];
            MYSBestTime* bestTime2 = array2[0];
            
            if ([bestTime1 getDistance] > [bestTime2 getDistance]) {
                [rsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    return rsArray;
}

- (NSMutableArray *)getBestTime2 {
    NSArray* allTimes = [[self getCurrentProfile].time allObjects];
    NSMutableArray *result = [NSMutableArray array];
    for (MYSTime *time in allTimes) {
        if ([time.status integerValue]== MYSTimeStatusLatestPersionalBest) {
            BOOL needAdd = YES;
            for (MYSDistanceGroup *dg in result) {
                if (dg.distance == (int)[time.distance floatValue]) {
                    needAdd = NO;
                    [dg addTime:time];
                    break;
                }
            }
            if (needAdd) {
                MYSDistanceGroup *dg = [[MYSDistanceGroup alloc] init];
                dg.distance = (int)[time.distance floatValue];
                [dg addTime:time];
                [result addObject:dg];
            }
        }
    }
    for (int i = 0; i< [result count]; i++) {
        MYSDistanceGroup *dg = result[i];
        NSArray *sorted = [dg.items sortedArrayUsingComparator:^NSComparisonResult(MYSStrokeGroup *obj1, MYSStrokeGroup *obj2) {
            return obj1.stroke > obj2.stroke;
        }];
        dg.items = [NSMutableArray arrayWithArray:sorted];
        result[i] = dg;
    }
    
    return [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(MYSDistanceGroup *obj1, MYSDistanceGroup *obj2) {
        return obj1.distance > obj2.distance;
    }]];
}

#pragma mark - === Qualifying Time ===

- (void)insertQualifyingTimeWithGender:(NSInteger)gender name:(NSString *)name event:(MYSEvent *)event andMeet:(MYSMeet *)meet
{
    // Create new qualifying time
    MYSQualifyTime *qualifyTime = [MYSQualifyTime MR_createEntity];
    NSInteger qualifyTimeID = (NSInteger)[MethodHelper generateTempID];
    qualifyTime.idValue = (int32_t)qualifyTimeID;
    qualifyTime.genderValue = gender;
    qualifyTime.name = name;
    // Meet
    qualifyTime.meet = meet;
    // Event
    qualifyTime.events = [NSSet setWithObject:event];
    // Save
    [self save];
}

- (MYSQualifyTime *)insertQualifyingTimeWithGender:(NSInteger)gender name:(NSString *)name andMeet:(MYSMeet *)meet
{
    // Create new qualifying time
    MYSQualifyTime *qualifyTime = [MYSQualifyTime MR_createEntity];
    NSInteger qualifyTimeID = (NSInteger)[MethodHelper generateTempID];
    qualifyTime.idValue = (int32_t)qualifyTimeID;
    qualifyTime.genderValue = gender;
    qualifyTime.name = name;
    // Meet
    qualifyTime.meet = meet;
    // Save
    [self save];
    return qualifyTime;
}

- (MYSQualifyTime *)getQualifyTimeWithGender:(NSInteger)gender name:(NSString *)name
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %@", @"gender", gender, @"name", name];
    
    MYSQualifyTime *result = [MYSQualifyTime MR_findFirstWithPredicate:predicate];
    return result;
}

- (MYSQualifyTime *)getQualifyTimeWithGender:(NSInteger)gender name:(NSString *)name ofMeet:(MYSMeet *)meet
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %@", @"gender", gender, @"name", name];
    
    NSArray *array = [MYSQualifyTime MR_findAllWithPredicate:predicate];
    
    for (MYSQualifyTime *qualify in array) {
        if (meet == qualify.meet) {
            return qualify;
        }
    }
    
    return nil;
}

- (MYSEvent *)getEventWithStroke:(MYSStrokeTypes)stroke distance:(CGFloat)distance gender:(int)gender age:(NSString *)name ofMeet:(MYSMeet *)meet {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %f", @"stroke", stroke, @"distance", distance];
    
    NSArray *array = [MYSEvent MR_findAllWithPredicate:predicate];
    if (array) {
        for (MYSEvent *event in array) {
            if (event.qualifytime.genderValue == gender && event.qualifytime.meet.id == meet.id && [event.qualifytime.name isEqualToString:name]) {
                return event;
            }
        }
    }
    return nil;
    
}

- (NSFetchedResultsController *)fetchedAllQualifyingTimeGroupByGenderWithMeetID:(NSInteger)meetID{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"meet.id", meetID];
    
    NSFetchedResultsController *fetchedResuts = [MYSQualifyTime MR_fetchAllGroupedBy:@"gender" withPredicate:predicate sortedBy:MYSQualifyTimeAttributes.id ascending:NO];
    return fetchedResuts;
}

- (NSArray *)getAllQualifyingTimeGroupByGenderWithMeetID:(MYSMeet *)meet {
    
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MYSQualifyTimeRelationships.meet, meet];
    //    MYSMeet *meet = [[MYSMeet MR_findAllWithPredicate:predicate] firstObject];
    //    if (meet) {
    //        NSMutableArray *male, *female;
    //        male = [NSMutableArray array];
    //        female = [NSMutableArray array];
    //        for (MYSQualifyTime *qua in meet.qualifytimes) {
    //            if (qua.genderValue == ) {
    //                <#statements#>
    //            }
    //        }
    //    }
    //
    //    NSFetchedResultsController *fetchedResuts = [MYSQualifyTime MR_fetchAllGroupedBy:MYSQualifyTimeAttributes.gender withPredicate:predicate sortedBy:nil ascending:NO];
    //    NSError *error = nil;
    //    [fetchedResuts performFetch:&error];
    //
    //
    NSMutableArray *results = [NSMutableArray array];
    //    for (int i = 0; i < [[fetchedResuts sections] count]; i++) {
    //        // Get group
    //        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResuts sections] objectAtIndex:i];
    //        NSDictionary *dictionary = @{@"groupValue": [sectionInfo name],
    //                                     @"items": [sectionInfo objects]};
    //
    //        for (MYSQualifyTime *qua in [sectionInfo objects]) {
    //            DebugLog(@"%@, %@, %d", [sectionInfo name], qua.name, qua.genderValue)
    //        }
    //
    //        [results addObject:dictionary];
    //    }
    //
    //    for (MYSQualifyTime *qua in [fetchedResuts fetchedObjects]) {
    //        DebugLog(@"%@, %d", qua.name, qua.genderValue)
    //    }
    
    return results;
}

- (NSArray *)getAllQualifyingTimeWithMeetID:(NSInteger)meetID{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"meet.id", meetID];
    
    return [MYSQualifyTime MR_findAllWithPredicate:predicate];
}

#pragma mark - === Event ===

- (MYSEvent *)insertEventWithStroke:(MYSStrokeTypes)strokeType distance:(CGFloat)distance time:(NSInteger)time{
    
    // Create new event
    MYSEvent *event = [MYSEvent MR_createEntity];
    NSInteger eventID = (NSInteger)[MethodHelper generateTempID];
    event.idValue = eventID;
    event.strokeValue = strokeType;
    event.distanceValue = distance;
    event.timeValue = time;
    
    // Save
    [self save];
    
    return event;
}

- (NSArray *)getAllEventOfMeet:(MYSMeet *)meet
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *qualifies = [meet.qualifytimes allObjects];
    for (MYSQualifyTime *qualify in qualifies) {
        [result addObjectsFromArray:[qualify.events allObjects]];
    }
    return result;
}

- (MYSEvent *)getEventWithCourse:(MYSCourseType)courseType stroke:(MYSStrokeTypes)stroke distance:(CGFloat)distance gender:(int)gender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %f", @"stroke", stroke, @"distance", distance];
    
    NSArray *array = [MYSEvent MR_findAllSortedBy:@"time" ascending:YES withPredicate:predicate];
    if (array) {
        return [array firstObject];
    }
    return nil;
}

- (void) updateLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (MYSMeet *meet in self.allMeets)
    {
        if([meet.startDate compare:[NSDate date]] == NSOrderedDescending )
        {
            [self addLocationNotification:meet];
        }
    }
}

- (void) addLocationNotification:(MYSMeet *)meet
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if(localNotif == nil) return;
    
    //    NSDate *fireDate = [meet.startDate addTimeInterval:(- 3600)];
    NSDate *fireDate = [meet.startDate dateByAddingTimeInterval:(- 3600)];
    
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:@"%@ will be start after a hour", meet.title];
    localNotif.alertAction = @"OK";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    localNotif.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    localNotif = nil;
}

- (MYSInstructorProfile *) logInInstructorWithUserName : (NSString*)userName andPassword : (NSString*)password {
    
    NSArray *profileResult = [MYSInstructorProfile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"userName == %@ AND password == %@", userName,password]];
    
    if ([profileResult count] > 1) NSLog(@"REDUNDANCY OF PROFILE!!");
    
    if ([profileResult count] > 0) return [profileResult lastObject];
    else return nil;
}

- (MYSInstructorProfile *) getInstructorProfileWithID : (NSString*)instructoreID {
    
    NSArray *profileResult = [MYSInstructorProfile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"instructorID == %@", instructoreID]];
    
    if ([profileResult count] > 1) NSLog(@"REDUNDANCY OF PROFILE!!");
    
    if ([profileResult count] > 0) return [profileResult lastObject];
    else return nil;
}

- (MYSInstructorProfile *) getInstructorProfileWithData : (NSDictionary*)instructorInfo {
    
    NSArray *profileResult = [MYSInstructorProfile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"instructorID == %@", [instructorInfo valueForKey:@"user_id"]]];
    
    if ([profileResult count] > 1) NSLog(@"REDUNDANCY OF PROFILE!!");
    
    MYSInstructorProfile *instructorProfile;
    //if profile fetched, update it
    if ([profileResult count] > 0) instructorProfile = [profileResult firstObject];
    //if no profile found, create one
    else instructorProfile = [MYSInstructorProfile MR_createEntity];
    
    instructorProfile.instructorID = [NSString stringWithFormat:@"%@",[instructorInfo valueForKey:@"user_id"]];
    instructorProfile.email = [instructorInfo valueForKey:@"email"];
    instructorProfile.password = [instructorInfo valueForKey:@"password"];
    instructorProfile.purchasedForShareResult = [NSNumber numberWithBool:(([[instructorInfo valueForKey:@"share_result_purchase"] caseInsensitiveCompare:@"Yes"] == NSOrderedSame) ? YES : NO)];
    instructorProfile.purchasedToRemoveAds = [NSNumber numberWithBool:(([[instructorInfo valueForKey:@"ads_purchase"] caseInsensitiveCompare:@"Yes"] == NSOrderedSame) ? YES : NO)];
    instructorProfile.userName = [instructorInfo valueForKey:@"user_name"];
    
//#warning - Dev purpose only
//    instructorProfile.purchasedForShareResult = [NSNumber numberWithBool:YES];
    
    [self save];
    return instructorProfile;
}

-(void) checkAndAddAllExistingSwimmersToInstructor : (MYSInstructorProfile*) instructor {
    
    BOOL swimmersAdded = [[NSUserDefaults standardUserDefaults] boolForKey:@"swimmersAdded"];
    
    if (swimmersAdded == NO) {
        
        NSMutableSet *arraySet = [[NSMutableSet alloc] init];
        NSArray *swimmerData = [MYSProfile MR_findAll];
        for (MYSProfile *swimmer in swimmerData) {
            if (swimmer.instructor == nil)
                [arraySet addObject:swimmer];
        }
        
        instructor.profile = [NSSet setWithSet:arraySet];
        
        [self save];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"swimmersAdded"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) saveAllSwimSyncResult : (NSDictionary*)resultData {
    
    MYSProfile *swimmmer = [self getProfileWithData:[resultData objectForKey:@"swimmerInfo"]];
    
//    NSMutableSet *arraySet;
//    if (swimmmer.goaltime != nil)
//        arraySet = [NSMutableSet setWithSet:swimmmer.goaltime];
//    else
//        arraySet = [[NSMutableSet alloc] init];
    for (NSDictionary *goalTimeInfo in [resultData objectForKey:@"goalInfo"]) {
        MYSGoalTime *goalTime = [MYSGoalTime MR_createEntity];
        goalTime.timeValue = [[goalTimeInfo objectForKey:@"time"] longLongValue];
        goalTime.strokeValue = [[goalTimeInfo objectForKey:@"stroke"] intValue];
        goalTime.distanceValue = [[goalTimeInfo objectForKey:@"distance"] longLongValue];
        goalTime.courseTypeValue = [[goalTimeInfo objectForKey:@"courseType"] intValue];
        
        goalTime.profile = swimmmer;
//        [arraySet addObject:goalTime];
        [swimmmer addGoaltimeObject:goalTime];
    }
//    swimmmer.goaltime = [NSSet setWithSet:arraySet];
    
    NSMutableDictionary *temp_meetInfo = [NSMutableDictionary dictionary];
//    NSMutableSet *arrayTimeSet;
    //    if (swimmmer.time != nil)
    //        arrayTimeSet = [NSMutableSet setWithSet:swimmmer.time];
    //    else
    //        arrayTimeSet = [[NSMutableSet alloc] init];
    for (NSDictionary*timeItem in [resultData objectForKey:@"timesInfo"]) {
        
        MYSTime *time = [MYSTime MR_createEntity];
        time.courseValue = [[timeItem objectForKey:@"course"] intValue];
        time.date = [NSDate dateWithTimeIntervalSince1970:[[timeItem objectForKey:@"date"] doubleValue]];
        time.distanceValue = [[timeItem objectForKey:@"distance"] floatValue];
        time.reactionTimeValue = [[timeItem objectForKey:@"reactionTime"] longLongValue];
        time.stageValue = [[timeItem objectForKey:@"stage"] intValue];
        time.statusValue = [[timeItem objectForKey:@"status"] intValue];
        time.strokeValue = [[timeItem objectForKey:@"stroke"] intValue];
        time.timeValue = [[timeItem objectForKey:@"time"] longLongValue];
        
        //Updating 'status' value for 'time' for this swmmer
        MYSTime *pb = [self getLatestPersionalBestOfProfile:swimmmer withCourse:time.courseValue distance:time.distanceValue stroke:time.strokeValue];
        if (pb == nil) {
            time.status = [NSNumber numberWithInt: MYSTimeStatusLatestPersionalBest];
        } else {
            if ([pb.time longLongValue] > time.timeValue) {
                time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
                pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
            } else {
                time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
            }
        }
        
        //        NSMutableSet *arrayLapSet = [[NSMutableSet alloc] init];
        for (NSDictionary*lapItem in [timeItem objectForKey:@"lapInfo"]) {
            
//            MYSLap *lap = [MYSLap MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %lld", MYSLapAttributes.id, [[lapItem objectForKey:@"id"] longLongValue]]];
//            
//            if (lap == nil) {
                MYSLap *lap = [MYSLap MR_createEntity];
                lap.idValue = [[lapItem objectForKey:@"id"] longLongValue];
                [time addLapsObject:lap];
//            }
            lap.lapNumberValue = [[lapItem objectForKey:@"lapNumber"] longLongValue];
            lap.splitTimeValue = [[lapItem objectForKey:@"splitTime"] longLongValue];
            
            lap.time = time;
            
            //            [arrayLapSet addObject:lap];
        }
        //        time.laps = [NSSet setWithSet:arrayLapSet];
        time.profile = swimmmer;
        
        NSString *temp_meetID = [timeItem objectForKey:@"meetidValue"];
        if (temp_meetID) {
            NSMutableDictionary *temp_meetDict = [temp_meetInfo objectForKey:temp_meetID];
            if (temp_meetDict) {
                NSMutableArray *aryTimes = [temp_meetDict objectForKey:@"times"];
                [aryTimes addObject:time];
            }
            else {
                [temp_meetInfo setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys: [NSMutableArray arrayWithObject:time], @"times", nil] forKey:temp_meetID];
            }
        }
        
        [swimmmer addTimeObject:time];
        //        [arrayTimeSet addObject:time];
    }
    
    //    swimmmer.time = [NSSet setWithSet:arrayTimeSet];
    
    NSDictionary *dict_meetInfo = [resultData objectForKey:@"meetInfo"];
    for (NSString*meetID in [temp_meetInfo allKeys]) {
        
        MYSMeet *newMeetObj = [self getMeetWithData:[dict_meetInfo objectForKey:meetID]];
        
        //        NSMutableSet *timeSet;
        //        if (newMeetObj.times != nil)
        //            timeSet = [NSMutableSet setWithSet:newMeetObj.times];
        //        else
        //            timeSet = [[NSMutableSet alloc] init];
        
        for (MYSTime *timeItem in [[temp_meetInfo objectForKey:meetID] objectForKey:@"times"]) {
            timeItem.meet = newMeetObj;
            [newMeetObj addTimesObject:timeItem];
            //            [timeSet addObject:timeItem];
        }
        //        newMeetObj.times = [NSSet setWithSet:timeSet];
    }
    
    [self save];
}

- (void) saveAllPBTimesResult : (NSDictionary*)resultData {
    
    MYSProfile *swimmmer = [self getProfileWithData:[resultData objectForKey:@"swimmerInfo"]];
    
    NSMutableDictionary *temp_meetInfo = [NSMutableDictionary dictionary];
    //    NSMutableSet *arrayTimeSet;
    //    if (swimmmer.time != nil)
    //        arrayTimeSet = [NSMutableSet setWithSet:swimmmer.time];
    //    else
    //        arrayTimeSet = [[NSMutableSet alloc] init];
    
    for (NSDictionary*timeItem in [resultData objectForKey:@"pbTimesInfo"]) {
        
        MYSTime *time = [MYSTime MR_createEntity];
        time.courseValue = [[timeItem objectForKey:@"course"] intValue];
        time.date = [NSDate dateWithTimeIntervalSince1970:[[timeItem objectForKey:@"date"] doubleValue]];
        time.distanceValue = [[timeItem objectForKey:@"distance"] floatValue];
        time.reactionTimeValue = [[timeItem objectForKey:@"reactionTime"] longLongValue];
        time.stageValue = [[timeItem objectForKey:@"stage"] intValue];
        time.statusValue = [[timeItem objectForKey:@"status"] intValue];
        time.strokeValue = [[timeItem objectForKey:@"stroke"] intValue];
        time.timeValue = [[timeItem objectForKey:@"time"] longLongValue];
        
        //Updating 'status' value for 'time' for this swmmer
        MYSTime *pb = [self getLatestPersionalBestOfProfile:swimmmer withCourse:time.courseValue distance:time.distanceValue stroke:time.strokeValue];
        if (pb == nil) {
            time.status = [NSNumber numberWithInt: MYSTimeStatusLatestPersionalBest];
        } else {
            if ([pb.time longLongValue] > time.timeValue) {
                time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
                pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
            } else {
                time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
            }
        }

        
        //        NSMutableSet *arrayLapSet = [[NSMutableSet alloc] init];
        for (NSDictionary*lapItem in [timeItem objectForKey:@"lapInfo"]) {
            
//            MYSLap *lap = [MYSLap MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %lld", MYSLapAttributes.id, [[lapItem objectForKey:@"id"] longLongValue]]];
//            
//            if (lap == nil) {
                MYSLap *lap = [MYSLap MR_createEntity];
                lap.idValue = [[lapItem objectForKey:@"id"] longLongValue];
                [time addLapsObject:lap];
//            }
            lap.lapNumberValue = [[lapItem objectForKey:@"lapNumber"] longLongValue];
            lap.splitTimeValue = [[lapItem objectForKey:@"splitTime"] longLongValue];
            lap.time = time;
            
            //            [arrayLapSet addObject:lap];
        }
        //        time.laps = [NSSet setWithSet:arrayLapSet];
        
        time.profile = swimmmer;
        [swimmmer addTimeObject:time];
        //        [arrayTimeSet addObject:time];
        
        
        NSString *temp_meetID = [timeItem objectForKey:@"meetidValue"];
        if (temp_meetID) {
            NSMutableDictionary *temp_meetDict = [temp_meetInfo objectForKey:temp_meetID];
            if (temp_meetDict) {
                NSMutableArray *aryTimes = [temp_meetDict objectForKey:@"times"];
                [aryTimes addObject:time];
            }
            else {
                [temp_meetInfo setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys: [NSMutableArray arrayWithObject:time], @"times", nil] forKey:temp_meetID];
            }
        }
    }
    
    NSDictionary *dict_meetInfo = [resultData objectForKey:@"meetInfo"];
    for (NSString*meetID in [temp_meetInfo allKeys]) {
        
        MYSMeet *newMeetObj = [self getMeetWithData:[dict_meetInfo objectForKey:meetID]];
        
        //        NSMutableSet *timeSet;
        //        if (newMeetObj.times != nil)
        //            timeSet = [NSMutableSet setWithSet:newMeetObj.times];
        //        else
        //            timeSet = [[NSMutableSet alloc] init];
        
        for (MYSTime *timeItem in [[temp_meetInfo objectForKey:meetID] objectForKey:@"times"]) {
            timeItem.meet = newMeetObj;
            [newMeetObj addTimesObject:timeItem];
            //            [timeSet addObject:timeItem];
        }
        //        newMeetObj.times = [NSSet setWithSet:timeSet];
    }
    
    //    swimmmer.time = [NSSet setWithSet:arrayTimeSet];
    [self save];
}

- (void) saveAllMeetResult : (NSDictionary*)resultData {
    
    MYSMeet *meetObj = [self getMeetWithData:[resultData objectForKey:@"meetData"]];
    //    NSMutableSet *arrayTimeMeetSet;
    //    if (meetObj.times != nil)
    //        arrayTimeMeetSet = [NSMutableSet setWithSet:meetObj.times];
    //    else
    //        arrayTimeMeetSet = [[NSMutableSet alloc] init];
    for (NSDictionary *meetItem in [resultData objectForKey:@"meetInfo"]) {
        
        MYSProfile *swimmmer = [self getProfileWithData:[meetItem objectForKey:@"swimmerInfo"]];
        
        //        NSMutableSet *arrayTimeSet = [[NSMutableSet alloc] init];
        for (NSDictionary *timeItem in [meetItem objectForKey:@"timeInfo"]) {
            
            MYSTime *time = [MYSTime MR_createEntity];
            time.courseValue = [[timeItem objectForKey:@"course"] intValue];
            time.date = [NSDate dateWithTimeIntervalSince1970:[[timeItem objectForKey:@"date"] doubleValue]];
            time.distanceValue = [[timeItem objectForKey:@"distance"] floatValue];
            time.reactionTimeValue = [[timeItem objectForKey:@"reactionTime"] longLongValue];
            time.stageValue = [[timeItem objectForKey:@"stage"] intValue];
            time.statusValue = [[timeItem objectForKey:@"status"] intValue];
            time.strokeValue = [[timeItem objectForKey:@"stroke"] intValue];
            time.timeValue = [[timeItem objectForKey:@"time"] longLongValue];
            
            //Updating 'status' value for 'time' for this swmmer
            MYSTime *pb = [self getLatestPersionalBestOfProfile:swimmmer withCourse:time.courseValue distance:time.distanceValue stroke:time.strokeValue];
            if (pb == nil) {
                time.status = [NSNumber numberWithInt: MYSTimeStatusLatestPersionalBest];
            } else {
                if ([pb.time longLongValue] > time.timeValue) {
                    time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
                    pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
                } else {
                    time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
                }
            }
            
            time.profile = swimmmer;
            time.meet = meetObj;
            //            [arrayTimeSet addObject:time];
            //            [arrayTimeMeetSet addObject:time];
            
            [meetObj addTimesObject:time];
            [swimmmer addTimeObject:time];
        }
        
        //        swimmmer.time = [NSSet setWithSet:arrayTimeSet];
    }
    
    //    meetObj.times = [NSSet setWithSet:arrayTimeMeetSet];
    
    [self save];
}

- (void) saveOtherTimesResult : (NSDictionary*)resultData {
    
    MYSProfile *swimmmer = [self getProfileWithData:[resultData objectForKey:@"swimmerInfo"]];
    
    NSDictionary *timeItem = [resultData objectForKey:@"timeInfo"];
    MYSTime *time = [MYSTime MR_createEntity];
    time.courseValue = [[timeItem objectForKey:@"course"] intValue];
    time.date = [NSDate dateWithTimeIntervalSince1970:[[timeItem objectForKey:@"date"] doubleValue]];
    time.distanceValue = [[timeItem objectForKey:@"distance"] floatValue];
    time.reactionTimeValue = [[timeItem objectForKey:@"reactionTime"] longLongValue];
    time.stageValue = [[timeItem objectForKey:@"stage"] intValue];
    time.statusValue = [[timeItem objectForKey:@"status"] intValue];
    time.strokeValue = [[timeItem objectForKey:@"stroke"] intValue];
    time.timeValue = [[timeItem objectForKey:@"time"] longLongValue];
    
    //Updating 'status' value for 'time' for this swmmer
    MYSTime *pb = [self getLatestPersionalBestOfProfile:swimmmer withCourse:time.courseValue distance:time.distanceValue stroke:time.strokeValue];
    if (pb == nil) {
        time.status = [NSNumber numberWithInt: MYSTimeStatusLatestPersionalBest];
    } else {
        if ([pb.time longLongValue] > time.timeValue) {
            time.status = [NSNumber numberWithInt:MYSTimeStatusLatestPersionalBest];
            pb.status = [NSNumber numberWithInt:MYSTimeStatusPersionalBest];
        } else {
            time.status = [NSNumber numberWithInt:MYSTimeStatusNone];
        }
    }

    
    time.profile = swimmmer;
    
    MYSMeet *meet = [self getMeetWithData:[resultData objectForKey:@"meetInfo"]];
    
    //    NSMutableSet *arrayLapSet = [[NSMutableSet alloc] init];
    for (NSDictionary*lapItem in [resultData objectForKey:@"lapInfo"]) {
        
//        MYSLap *lap = [MYSLap MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %lld", MYSLapAttributes.id, [[lapItem objectForKey:@"id"] longLongValue]]];
//        
//        if (lap == nil) {
            MYSLap *lap = [MYSLap MR_createEntity];
            lap.idValue = [[lapItem objectForKey:@"id"] longLongValue];
            [time addLapsObject:lap];
//        }
        lap.lapNumberValue = [[lapItem objectForKey:@"lapNumber"] longLongValue];
        lap.splitTimeValue = [[lapItem objectForKey:@"splitTime"] longLongValue];
        
        lap.time = time;
        
        //        [arrayLapSet addObject:lap];
    }
    //    time.laps = [NSSet setWithSet:arrayLapSet];
    
    [meet addTimesObject:time];
    [self save];
}

- (MYSProfile*) getProfileWithData : (NSDictionary*)data {
    
    NSDate *dob = [MethodHelper getDateFullMonth:[data objectForKey:@"birthday"]];
    
    NSPredicate *predicate;
    if (dob) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@) OR (%K == %@ AND %K == %@)", MYSProfileAttributes.userid, [data objectForKey:@"swimmerID"], MYSProfileAttributes.birthday, dob, MYSProfileAttributes.name, [data objectForKey:@"swimmerName"]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@) OR %K == %@", MYSProfileAttributes.userid, [data objectForKey:@"swimmerID"], MYSProfileAttributes.name, [data objectForKey:@"swimmerName"]];
    }
    
    MYSProfile *swimmer = [MYSProfile MR_findFirstWithPredicate:predicate];
    
    if (swimmer == nil) {
        
        swimmer = [MYSProfile MR_createEntity];
        swimmer.useridValue = [[data objectForKey:@"swimmerID"] longLongValue];
        swimmer.birthday = dob;
        swimmer.city = [data objectForKey:@"city"];
        swimmer.country = [data objectForKey:@"country"];
        swimmer.genderValue = [[data objectForKey:@"gender"] intValue];
        NSString *imageStr = [data objectForKey:@"profileImage"];
        if (imageStr.length > 0) {
            NSData* imageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (imageData)
                swimmer.image = imageData;
        }
        if (swimmer.image == nil)
            swimmer.image = UIImagePNGRepresentation([UIImage imageNamed:@"no_image.jpeg"]);
        
        swimmer.nameSwimClub = [data objectForKey:@"club"];
        swimmer.name = [data objectForKey:@"swimmerName"];
    }
    
    return swimmer;
}

- (MYSMeet*) getMeetWithData : (NSDictionary *)data {
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"startDate"] doubleValue]];
    NSString *city = [data objectForKey:@"city"];
    NSString *location = [data objectForKey:@"location"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %lld", MYSMeetAttributes.id, [[data objectForKey:@"id"] longLongValue]];
    if ((startDate!= nil) && (city.length>0) && (location.length>0)) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %lld) OR (%K == %@ AND %K == %@ AND %K == %@)", MYSMeetAttributes.id, [[data objectForKey:@"id"] longLongValue], MYSMeetAttributes.startDate, startDate, MYSMeetAttributes.city, city,MYSMeetAttributes.location,location];
    }
    else if ((startDate!= nil) && (city.length>0)) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %lld) OR (%K == %@ AND %K == %@)", MYSMeetAttributes.id, [[data objectForKey:@"id"] longLongValue], MYSMeetAttributes.startDate, startDate, MYSMeetAttributes.city, city];
    }
    else if ((startDate!= nil) && (location.length>0)) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %lld) OR (%K == %@ AND %K == %@ )", MYSMeetAttributes.id, [[data objectForKey:@"id"] longLongValue], MYSMeetAttributes.startDate, startDate,MYSMeetAttributes.location,location];
    }
    
    MYSMeet *meet = [MYSMeet MR_findFirstWithPredicate:predicate];
    
    if (meet == nil){
        meet = [MYSMeet MR_createEntity];
        meet.idValue = [[data objectForKey:@"id"] longLongValue];
        meet.title = [data objectForKey:@"title"];
    }
    
    meet.city = city;
    meet.location = location;
    meet.courseTypeValue = [[data objectForKey:@"courseType"] intValue];
    meet.endDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"endDate"] doubleValue]];
    meet.enteredDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"enteredDate"] doubleValue]];
    meet.startDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"startDate"] doubleValue]];
    
    //    NSMutableSet *arrayTimeSet;
    //    if (meet.qualifytimes != nil)
    //        arrayTimeSet = [NSMutableSet setWithSet:meet.qualifytimes];
    //    else
    //        arrayTimeSet = [[NSMutableSet alloc] init];
    for (NSDictionary *timeItem in [data objectForKey:@"qualifyTimesInfo"]) {
        
        MYSQualifyTime *time = [MYSQualifyTime MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %d", MYSQualifyTimeAttributes.id, [[timeItem objectForKey:@"id"] intValue]]];
        if (time == nil) {
            time = [MYSQualifyTime MR_createEntity];
            time.idValue = [[timeItem objectForKey:@"id"] intValue];
            [meet addQualifytimesObject:time];
        }
        time.genderValue = [[timeItem objectForKey:@"gender"] intValue];
        time.name = [timeItem objectForKey:@"name"];
        
        //        NSMutableSet *arrayEventSet = [[NSMutableSet alloc] init];
        //        if (time.events != nil)
        //            arrayEventSet = [NSMutableSet setWithSet:time.events];
        //        else
        //            arrayEventSet = [[NSMutableSet alloc] init];
        for (NSDictionary *eventItem in [timeItem objectForKey:@"eventsInfo"]) {
            
            MYSEvent *event = [MYSEvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %lld", MYSEventAttributes.id, [[eventItem objectForKey:@"id"] longLongValue]]];
            if (event == nil) {
                event = [MYSEvent MR_createEntity];
                event.idValue = [[timeItem objectForKey:@"id"] longLongValue];
                [time addEventsObject:event];
            }
            event.distanceValue = [[eventItem objectForKey:@"distance"] floatValue];
            event.strokeValue = [[eventItem objectForKey:@"stroke"] intValue];
            event.timeValue = [[eventItem objectForKey:@"time"] longLongValue];
            event.qualifytime = time;
            
            //            [arrayEventSet addObject:event];
        }
        
        //        time.events = [NSSet setWithSet:arrayEventSet];
        time.meet = meet;
        
        //        [arrayTimeSet addObject:time];
    }
    
    //    meet.qualifytimes = [NSSet setWithSet:arrayTimeSet];
    
    return meet;
}

- (NSInteger) getCountOfInstructor {
    return [MYSInstructorProfile MR_countOfEntities];
}

- (void) removePreviousInstructroIfAny {
    if([MYSInstructorProfile MR_countOfEntities] > 0) {
        [MYSInstructorProfile MR_truncateAll];
    }
}

@end
