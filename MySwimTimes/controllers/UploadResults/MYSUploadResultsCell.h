//
//  MYSUploadResultsCell.h
//  swimsync
//
//  Created by Probir Chakraborty on 02/07/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSUploadResultsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *importBtn;
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *swimmerImgView;
@property (weak, nonatomic) IBOutlet UILabel *swimmerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *championShipLabel;
@property (weak, nonatomic) IBOutlet UILabel *championshipTypeLabel;

@end
