//
//  MYSShareReportInfo.m
//  swimsync
//
//  Created by Krishna Kant Kaira on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSShareReportInfo.h"

@implementation MYSShareReportInfo

+(MYSShareReportInfo*)getShareReportFrom:(NSDictionary*)dict {
    
    MYSShareReportInfo *reportItem = [[MYSShareReportInfo alloc] init];
    reportItem.reportID = [dict objectForKey:@"userID"];
    reportItem.reportID = [dict objectForKey:@"resultID"];
    reportItem.senderID = [dict objectForKey:@"senderID"];
    reportItem.senderName = [dict objectForKey:@"senderName"];
    
    NSError *err;
    NSData *data_report = [[reportItem stringByRemovingControlCharacters:[dict objectForKey:@"result"]] dataUsingEncoding:NSUTF8StringEncoding];
    reportItem.reportData = [NSJSONSerialization JSONObjectWithData:data_report options:kNilOptions error:&err];
    
    if (reportItem.reportData && [reportItem.reportData isKindOfClass:[NSDictionary class]]) {
        
        reportItem.resultType = [[reportItem.reportData objectForKey:@"reportType"] integerValue];
        reportItem.resultTitle = [reportItem.reportData objectForKey:@"reportTitle"];
        reportItem.resultSubTitle = [reportItem.reportData objectForKey:@"reportSubTitle"];
        
        NSDictionary *swimmerInfo;
        
        if (reportItem.resultType == MYSResultType_AllMeets) {
            NSArray *meetArray = [reportItem.reportData objectForKey:@"meetInfo"];
            if ([meetArray isKindOfClass:[NSArray class]])
                swimmerInfo = [[meetArray firstObject] objectForKey:@"swimmerInfo"];
        }
        else
            swimmerInfo = [reportItem.reportData objectForKey:@"swimmerInfo"];
        
        if (swimmerInfo && [swimmerInfo isKindOfClass:[NSDictionary class]]) {
            NSString *imageStr =[swimmerInfo objectForKey:@"profileImage"];
            if ([imageStr length] > 0) {
                NSData* imageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:0];
                if (imageData)
                    reportItem.swimmerImage = [UIImage imageWithData:imageData];
            }
        }
        reportItem.swimmerName = [swimmerInfo objectForKey:@"swimmerName"];
        
        if (!reportItem.swimmerImage)
            reportItem.swimmerImage = [UIImage imageNamed:@"no_image.jpeg"];
    }
    
    return reportItem;
}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    return [[inputString componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]] componentsJoinedByString:@""];
}

@end
