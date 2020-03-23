//
//  MYSSwimmerView.m
//  MySwimTimes
//
//  Created by SmarterApps on 8/11/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSSwimmerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MYSSwimmerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _swimmmerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _swimmmerImage.contentMode = UIViewContentModeScaleAspectFill;
//        _swimmmerImage.backgroundColor = [UIColor blackColor];
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbName.font = [UIFont boldSystemFontOfSize:20.0f];
        
        _lbClub = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbClub.font = [UIFont systemFontOfSize:18.0f];
        
        _lbCountry = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbCountry.font = [UIFont systemFontOfSize:12.0f];
        
        _lbYearOld = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbYearOld.font = [UIFont systemFontOfSize:18.0f];
        
        [self addSubview:_swimmmerImage];
        [self addSubview:_lbName];
        [self addSubview:_lbClub];
        [self addSubview:_lbCountry];
        [self addSubview:_lbYearOld];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _swimmmerImage.frame = CGRectMake(12, 8, 50, 50);
    
    [_lbName sizeToFit];
    float width = CGRectGetWidth(_lbName.frame);
    if (width > 195) {
        width = 195;
    }
    _lbName.frame = CGRectMake(70, 12, width, CGRectGetHeight(_lbName.frame));
    
    [_lbClub sizeToFit];
    width = CGRectGetWidth(_lbClub.frame);
    if (width > 195) {
        width = 195;
    }
    _lbClub.frame = CGRectMake(70, 33, width, CGRectGetHeight(_lbClub.frame));
    
    [_lbYearOld sizeToFit];
    _lbYearOld.frame = CGRectMake(CGRectGetWidth(self.frame) - 10 - CGRectGetWidth(_lbYearOld.frame),
                                  (CGRectGetHeight(self.frame) - CGRectGetHeight(_lbYearOld.frame)) / 2,
                                  CGRectGetWidth(_lbYearOld.frame),
                                  CGRectGetHeight(_lbYearOld.frame));
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = 320.0f;
    selfFrame.size.height = 66.0f;
    self.frame = selfFrame;
}

- (void)showSwimmerInfo:(MYSProfile *)profile mode:(MYSSwimmerViewMode) viewMode {
    self.lbYearOld.hidden = YES;
    
    _swimmmerImage.image = [UIImage imageWithData:profile.image];
    CALayer * l = [_swimmmerImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:kCornerRadius];
    
    self.lbName.text = profile.name;
    self.lbClub.text = profile.nameSwimClub;
    
    self.lbYearOld.text = [NSString stringWithFormat:@"%.02f",[MethodHelper countYearOld2:profile.birthday]];
    if (viewMode == MYSSwimmerViewModeNormal) {

        if (profile.birthday == nil) {
            self.lbYearOld.hidden = YES;
        } else {
            self.lbYearOld.hidden = NO;
        }

    } else {
        
    }
    
    [self setNeedsLayout];
}
@end
