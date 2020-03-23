//
//  MYSUploadVC.h
//  swimsync
//
//  Created by Probir Chakraborty on 02/07/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UploadDelegate <NSObject>

-(void)shouldBuySharingFunction;

@end

@interface MYSUploadVC : UIViewController

@property (nonatomic, assign) id<UploadDelegate> delegate;


@end
