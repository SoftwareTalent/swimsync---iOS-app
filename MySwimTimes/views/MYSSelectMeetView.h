//
//  MYSSelectMeetView.h
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

/**
 This view is used for showing meets which are created. This view is shown as popup in "New Time" view controller.
 */

#import <UIKit/UIKit.h>

@protocol MYSNewMeetCellDelegate;
@interface MYSNewMeetCell : UITableViewCell

@property (nonatomic, weak) UITableView *refTableView;
@property (nonatomic, weak) NSObject<MYSNewMeetCellDelegate> *delegate;
@property (nonatomic, strong) UITextField *tfNewMeet;
@end

@protocol MYSNewMeetCellDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView editingText:(NSString *)text inCell:(MYSNewMeetCell *)cell;
@end

@class MYSSelectMeetView;

typedef void(^MYSSelectMeetViewSelectedBlock)(MYSSelectMeetView *view, MYSMeet *meet, NSString *meetTitle);
typedef void(^MYSSelectMeetViewCancelBlock)(MYSSelectMeetView *view);

@interface MYSSelectMeetView : UIView

@property (nonatomic, strong) UILabel *lbTitle;

- (void)showSelectMeetsInView:(UIView *)inView withMeets:(NSArray *)meets selectedBlock:(MYSSelectMeetViewSelectedBlock)mysSelectedBlock cancelBlock:(MYSSelectMeetViewCancelBlock)mysCancelBlock;
@end
