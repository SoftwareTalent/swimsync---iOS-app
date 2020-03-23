//
//  UIImage+FixOrientation.h
//  LiveProject
//
//  Created by SmarterApps on 2/17/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)
- (UIImage *)fixOrientation;
-(UIImage*)scaleToSize:(CGSize)size;

@end
