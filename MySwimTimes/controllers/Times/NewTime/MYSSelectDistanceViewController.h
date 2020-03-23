//
//  MYSSelectDistanceViewController.h
//  MySwimTimes
//
//  Created by hanjinghe on 11/2/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSSelectDistanceViewControllerDelegate <NSObject>

- (void) selectDistance:(double)distance;

@end

@interface MYSSelectDistanceViewController : UIViewController

@property (nonatomic, assign) id<MYSSelectDistanceViewControllerDelegate> delegate;

@property (nonatomic, assign) double distance;

@end
