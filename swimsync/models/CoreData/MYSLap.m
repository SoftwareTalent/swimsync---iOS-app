#import "MYSLap.h"

#define MSEC_PER_SEC    1000L
#define SEC_PER_MIN     60
#define MIN_PER_HOUR    60
#define HOUR_PER_DAY    24

@interface MYSLap ()

// Private interface goes here.

@end


@implementation MYSLap

// Custom logic goes here.

-(NSString *)getSplitTimeString {
    // Get split time value
    [self willAccessValueForKey:MYSLapAttributes.splitTime];
    int64_t splitTimeValue = self.splitTimeValue;
    [self didAccessValueForKey:MYSLapAttributes.splitTime];
    
    NSString *splitTimeString = nil;
    
    splitTimeString = [MYSLap getSplitTimeStringFromMiliseconds:splitTimeValue withMinimumFormat:NO];
    
    return splitTimeString;
}

+(int64_t)milisecondsFromLapTime:(NSString *)laptime {
    int64_t miliseconds = 0;
    
    @try {
        // Lap time string
        NSArray* parts = [laptime componentsSeparatedByString: @":"];
        
        if (parts.count == 4) {
            // Format: dd:HH:mm:ss.SS
            NSTimeInterval days = [parts[0] integerValue];
            NSTimeInterval hours = [parts[1] integerValue];
            NSTimeInterval minutes = [[parts objectAtIndex: 2] integerValue];
            NSTimeInterval seconds = [[parts objectAtIndex: 3] doubleValue];
            NSTimeInterval result = days * HOUR_PER_DAY * MIN_PER_HOUR * SEC_PER_MIN + hours * MIN_PER_HOUR * SEC_PER_MIN + minutes * SEC_PER_MIN + seconds;
            
            miliseconds = result * MSEC_PER_SEC;
        } else
            if (parts.count == 3) {
                // Format: HH:mm:ss.SS
                NSTimeInterval hours = [parts[0] integerValue];
                NSTimeInterval minutes = [[parts objectAtIndex: 1] integerValue];
                NSTimeInterval seconds = [[parts objectAtIndex: 2] doubleValue];
                NSTimeInterval result = hours * MIN_PER_HOUR * SEC_PER_MIN + minutes * SEC_PER_MIN + seconds;
                
                miliseconds = result * MSEC_PER_SEC;
            } else if (parts.count == 2) {
                // Format: mm:ss.SS
                NSTimeInterval minutes = [[parts objectAtIndex: 0] intValue];
                NSTimeInterval seconds = [[parts objectAtIndex: 1] doubleValue];
                NSTimeInterval result = minutes * SEC_PER_MIN + seconds;
                
                miliseconds = result * MSEC_PER_SEC;
            } else {
                // Format: ss.SS
                NSTimeInterval seconds = [[parts objectAtIndex: 0] intValue];
                
                NSTimeInterval result = seconds;
                
                miliseconds = result * MSEC_PER_SEC;
            }
        
    }
    @catch (NSException *exception) {
        
    }
    
    return miliseconds;
}

+(NSString *)getSplitTimeStringFromMiliseconds:(int64_t)aMiliseconds withMinimumFormat:(BOOL) shouldShowMinimumFormat{
    NSString *splitTimeString = nil;
    if (aMiliseconds == 0) {
        splitTimeString = @"0";//@"00:00.00";
    } else {
        
        int64_t minutes = 0, seconds = 0, hours = 0, days = 0;
        int64_t milisenconds = 0;
        
        int64_t aDay = HOUR_PER_DAY * MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC;
        int64_t aHour = MIN_PER_HOUR * SEC_PER_MIN * MSEC_PER_SEC;
        int64_t aMin = SEC_PER_MIN * MSEC_PER_SEC;
        int64_t aSec = MSEC_PER_SEC;
        
        days = aMiliseconds / aDay;
        hours = (aMiliseconds - days * aDay) / (aHour);
        minutes = (aMiliseconds - days * aDay - hours * aHour) / (aMin);
        seconds = (aMiliseconds - minutes * aMin - hours * aHour - days * aDay) / aSec;
        milisenconds = aMiliseconds - seconds * aSec - minutes * aMin - hours * aHour - days * aDay;
        
        milisenconds /= 10;
        
        if (days > 0) {
            splitTimeString = [NSString stringWithFormat:@"%lld:%.2lld:%.2lld:%.2lld.%.2lld", days, hours, minutes, seconds, milisenconds];
        } else
            if (hours > 0) {
                splitTimeString = [NSString stringWithFormat:@"%lld:%.2lld:%.2lld.%.2lld", hours, minutes, seconds, milisenconds];
            } else {
                if (shouldShowMinimumFormat == NO) {
                    splitTimeString = [NSString stringWithFormat:@"%lld:%.2lld.%.2lld", minutes, seconds, milisenconds];
                } else {
                    if (minutes > 0) {
                        splitTimeString = [NSString stringWithFormat:@"%lld:%.2lld.%.2lld", minutes, seconds, milisenconds];
                    } else {
                        splitTimeString = [NSString stringWithFormat:@"%lld.%.2lld", seconds, milisenconds];
                    }
                }
            }
    }
    return splitTimeString;
}

@end
