//
//  MYSGraphView.h
//  MySwimTimes
//
//  Created by hanjinghe on 10/11/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSGraphViewDelegate <NSObject>

- (void) selectTimeOnChart:(int) index isOwner:(BOOL)isOwner;

@end

@interface MYSGraphView : UIView

@property (nonatomic, assign) id<MYSGraphViewDelegate> delegate;

- (void) graphData:(NSMutableArray *)aryGraphDatas interval:(float)interval;

- (void) anotherGraphData:(NSMutableArray *)aryGraphDatas interval:(float)interval name:(NSString *)name;

@end
