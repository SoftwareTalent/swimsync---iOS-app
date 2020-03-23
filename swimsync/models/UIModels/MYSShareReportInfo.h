//
//  MYSShareReportInfo.h
//  swimsync
//
//  Created by Krishna Kant Kaira on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

//************
// Course enum
//************
typedef NS_ENUM(NSInteger, MYSResultType) {
    MYSResultType_AllResult = 1,
    MYSResultType_AllPBs,
    MYSResultType_AllMeets,
    MYSResultType_Other
};

@interface MYSShareReportInfo : NSObject

@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, strong) NSString *receiverID;
@property (nonatomic, strong) NSString *reportID;
@property (nonatomic, strong) NSString *senderName;

@property (nonatomic, strong) NSString *swimmerName;
@property (nonatomic, strong) UIImage *swimmerImage;
@property (nonatomic, assign) MYSResultType resultType;
@property (nonatomic, strong) NSString *resultTitle;
@property (nonatomic, strong) NSString *resultSubTitle;

@property (nonatomic, strong) NSDictionary *reportData;

+(MYSShareReportInfo * ) getShareReportFrom : (NSDictionary * )dict;

@end
