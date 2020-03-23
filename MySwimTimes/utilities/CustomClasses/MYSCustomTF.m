//
//  MYSCustomTF.m
//  SwimSync
//
//  Created by Probir Chakraborty on 16/03/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSCustomTF.h"

@implementation MYSCustomTF


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:KAppBlackColor , NSFontAttributeName: IS_IPHONE == YES ? CandaraRegularFont(16) : CandaraRegularFont(18)}];
        self.textColor = [UIColor blackColor];
        [self setBackgroundColor:KAppTextBgColor];
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = KAppTextBorderColor.CGColor;
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        self.font = IS_IPHONE == YES ? CandaraRegularFont(16) : CandaraRegularFont(20);
    }
    return self;
}

-(void)setlefImageWithName:(NSString*)name{
    //setting left view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,IS_IPHONE == YES ? 30 : 40, IS_IPHONE == YES ? self.frame.size.height : self.frame.size.height+10)];
    UIImage *img = [UIImage imageNamed:name];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,IS_IPHONE == YES ? 7 : 12,IS_IPHONE == YES ? 20 : 30,IS_IPHONE == YES ? 20 : 30)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgView];
    [self setLeftView:view];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

-(void)setrightImageWithImage:(UIImage *)image{
    //setting left view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100, self.frame.size.height)];
    //    UIImage *img = image;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3,50.f, 40.f)];
    [imgView setImage:image];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgView];
    
    UIImage *plusImg = [UIImage imageNamed:@"orangeadd_icon"];
    UIImageView *plusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(53, 7,30.f, 30.f)];
    [plusImgView setImage:plusImg];
    [plusImgView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:plusImgView];
    
    [self setRightView:view];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    bounds.size.width = bounds.size.width-60;
    
    return CGRectOffset( CGRectMake(IS_IPHONE == YES ? bounds.origin.x : bounds.origin.x+5,IS_IPHONE == YES ? bounds.origin.y+2 :bounds.origin.y+4, bounds.size.width-60, bounds.size.height), 40, 0 );
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return [self rectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.size.width = bounds.size.width-60;
//    return CGRectOffset( bounds, 40, 0);
    return CGRectOffset( CGRectMake(IS_IPHONE == YES ? bounds.origin.x : bounds.origin.x+5,IS_IPHONE == YES ? bounds.origin.y+2 :bounds.origin.y+3, bounds.size.width-60, bounds.size.height), 40, 0 );
}

- (CGRect)rectForBounds:(CGRect)bounds {
    bounds.size.width = bounds.size.width;
//    return CGRectInset(bounds, 40, 0);
    return CGRectOffset( CGRectMake(IS_IPHONE == YES ? bounds.origin.x : bounds.origin.x+5,IS_IPHONE == YES ? bounds.origin.y+2 :bounds.origin.y+3, bounds.size.width-60, bounds.size.height), 40, 0 );
}

-(void) addBorder:(UIColor *)newColor AndRadius:(float)radius
{
    self.layer.borderWidth=0.5;
    self.layer.cornerRadius=radius;
    self.layer.borderColor=newColor.CGColor;
}

@end
