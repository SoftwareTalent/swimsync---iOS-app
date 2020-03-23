//
//  MYSAppData.m
//  swimsync
//
//  Created by Krishna Kant Kaira on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSAppData.h"

@implementation MYSAppData

+ (MYSAppData *)sharedInstance {
    
    __strong static MYSAppData *_sharedLocalSystem = nil;
    
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedLocalSystem = [[self alloc] init];
    });
    return _sharedLocalSystem;
}

@end
