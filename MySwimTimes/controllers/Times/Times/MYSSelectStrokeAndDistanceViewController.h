//
//  MYSSelectStrokeAndDistanceViewController.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/1/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSSelectStrokeAndDistanceViewControllerDelegate <NSObject>

- (void) doneSelectDistanceAndStroke:(float) distance stroke:(int)stroke;

@end

@interface MYSSelectStrokeAndDistanceViewController : UIViewController

@property (nonatomic, assign) id<MYSSelectStrokeAndDistanceViewControllerDelegate> delegate;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) int strokeIndex;

@property (nonatomic, assign) BOOL isStaticStroke;

@end
