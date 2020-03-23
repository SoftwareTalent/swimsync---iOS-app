//
//  MYSCustomTF.h
//  SwimSync
//
//  Created by Probir Chakraborty on 16/03/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface MYSCustomTF : UITextField

-(void)setlefImageWithName:(NSString*)name;
-(void)setrightImageWithImage:(UIImage *)image;
-(void) addBorder:(UIColor *)newColor AndRadius:(float)radius;
@end
