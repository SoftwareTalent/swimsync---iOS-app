#import "_MYSLap.h"

@interface MYSLap : _MYSLap {}
// Custom logic goes here.

/**
 Get split time string
 @return split time string. Fotmat: 00:00.00
 */
- (NSString *) getSplitTimeString;

/**
 Get miliseconds from lap time string
 
 @param laptime lap time string. Format: 00:00.00
 
 @return miliseconds value
 */
+ (int64_t) milisecondsFromLapTime:(NSString *) laptime;

/**
 Get split time string from miliseconds
 
 @param miliseconds miliseconds value
 
 @param shouldShowMinimumFormat should show minimum format
 
 @return split time string with format 00:00.00
 */
+(NSString *)getSplitTimeStringFromMiliseconds:(int64_t)aMiliseconds withMinimumFormat:(BOOL) shouldShowMinimumFormat;
@end
