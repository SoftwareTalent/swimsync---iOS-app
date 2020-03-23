//
//  MYSSettingCell.h
//  swimsync
//
//  Created by Probir Chakraborty on 01/07/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end
