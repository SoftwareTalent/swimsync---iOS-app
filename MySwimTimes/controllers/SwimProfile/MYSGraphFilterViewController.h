//
//  MYSGraphFilterViewController.h
//  MySwimTimes
//
//  Created by Tran Thanh Nhan on 4/17/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MYSOptionsTableViewRowType) {
    MYSOptionsTableViewRowTypeNone = 0,
    MYSOptionsTableViewRowTypeDistance,
    MYSOptionsTableViewRowTypeCourse,
    MYSOptionsTableViewRowTypeStroke,
    MYSOptionsTableViewRowTypeInputNumber,
};

///
@interface MYSOptionsCellData : NSObject

@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic) MYSOptionsTableViewRowType cellType;
@property (nonatomic) NSString *cellValue;

@end

/// Cell Prototype

static NSString * const MYSOptionsTableViewCellID = @"MYSOptionsTableViewCell";
static int const kTotalStroke = 5;
@protocol MYSOptionsTableViewCellDelegate;
@interface MYSOptionsTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *cellName;
@property (nonatomic, strong) UITextField *cellValue;
@property (nonatomic, strong) UIView *strokeGroup;
@property (nonatomic, strong) UISegmentedControl *course;
@property (nonatomic, weak) UITableView *refTableView;
@property (nonatomic, weak) NSObject<MYSOptionsTableViewCellDelegate> *delegate;
@property (nonatomic) MYSOptionsTableViewRowType style;

- (void)setSelectedStroke:(int)stroke;
- (void)setSelectedCourse:(int)course;

@end

@protocol MYSOptionsTableViewCellDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView didChangeValue:(NSString *)value ofTextField:(UITextField *)textField inCell:(MYSOptionsTableViewCell *)mysCell;

- (void)tableView:(UITableView *)tableView didSelectStroke:(int)strokeID inCell:(MYSOptionsTableViewCell *)mysCell;
- (void)tableView:(UITableView *)tableView didSelectCourse:(int)courseID inCell:(MYSOptionsTableViewCell *)mysCell;

@end

/// View controller interface
@protocol MYSGraphFilterViewControllerDelegate;
@interface MYSGraphFilterViewController : UIViewController

@property (nonatomic, weak) NSMutableArray *datasource;
@property (nonatomic, weak) NSObject<MYSGraphFilterViewControllerDelegate> *delegate;

@end

@protocol MYSGraphFilterViewControllerDelegate <NSObject>

@optional
- (void)MYSGraphFilterViewController:(MYSGraphFilterViewController *)mysController didPressDoneButton:(UIButton *)doneButton withData:(NSArray *)data;


@end