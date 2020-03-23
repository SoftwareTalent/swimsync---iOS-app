//
//  MYSSelectMeetView.m
//  MySwimTimes
//
//  Created by SmarterApps on 4/10/14.
//  Copyright (c) 2014 SmarterApps. All rights reserved.
//

#import "MYSSelectMeetView.h"

@implementation MYSNewMeetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tfNewMeet = [[UITextField alloc] initWithFrame:CGRectZero];
        _tfNewMeet.font = self.textLabel.font;
        _tfNewMeet.placeholder = @"Tap to enter new Meet";
        [_tfNewMeet addTarget:self action:@selector(didEdittingMeetName:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_tfNewMeet];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize contentSize = self.contentView.frame.size;
    _tfNewMeet.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame),
                                  0,
                                  contentSize.width,
                                  contentSize.height);
}

- (IBAction)didEdittingMeetName:(id)sender {
    UITextField *tf = sender;
    if ([_delegate respondsToSelector:@selector(tableView:editingText:inCell:)]) {
        [_delegate tableView:_refTableView editingText:tf.text inCell:self];
    }
}

@end


@interface MYSSelectMeetView ()<UITableViewDataSource, UITableViewDelegate, MYSNewMeetCellDelegate> {
    UITableView *_tbvMeets;
    UIView *_containView;
    __weak NSArray *_datasource;
    
    UIButton *_btnClose;
    
    MYSMeet *tempMeet;
}

@property (nonatomic, copy) MYSSelectMeetViewSelectedBlock selectBlock;

@property (nonatomic, copy) MYSSelectMeetViewCancelBlock cancelBlock;

@end

@implementation MYSSelectMeetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnClose.backgroundColor = [UIColor blackColor];
        _btnClose.layer.opacity = 0.5f;
        [_btnClose addTarget:self action:@selector(didPressClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
        
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containView];
        
        _tbvMeets = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tbvMeets.delegate = self;
        _tbvMeets.dataSource = self;
        [_tbvMeets registerClass:[MYSNewMeetCell class] forCellReuseIdentifier:@"newMeetCell"];
        [_containView addSubview:_tbvMeets];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTitle.backgroundColor = [UIColor whiteColor];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        [_containView addSubview:_lbTitle];
        
//        self.backgroundColor = [UIColor lightGrayColor];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self superview].bounds.size;
    
    self.frame = CGRectMake(0,
                            0,
                            size.width,
                            size.height);
    
    _btnClose.frame = self.frame;
    
    CGSize containSize;
    containSize.width = size.width * 0.7f;
    containSize.height = size.height * 0.7f;
    
    _containView.frame = CGRectMake((size.width - containSize.width) / 2,
                                    70,
                                    containSize.width,
                                    containSize.height);
    
    _lbTitle.frame = CGRectMake(0,
                                0,
                                containSize.width,
                                44);
    
    _tbvMeets.frame = CGRectMake(0,
                                 CGRectGetMaxY(_lbTitle.frame),
                                 containSize.width,
                                 containSize.height - CGRectGetHeight(_lbTitle.frame));
}

#pragma mark - === UITableView Datasource ===
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_datasource count]) {
        static NSString * const cellID2 = @"newMeetCell";
        MYSNewMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        
        if (cell == nil) {
            cell = [[MYSNewMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        
        cell.tfNewMeet.text = @"";
        
        return cell;
    } else {
        static NSString * const cellID1 = @"CELLMEETID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        
        MYSMeet *meet = _datasource[indexPath.row];
        cell.textLabel.text = meet.title;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectBlock) {
        MYSMeet *meet = _datasource[indexPath.row];
        _selectBlock(self, meet, meet.title);
    }
    _selectBlock = nil;
    _cancelBlock = nil;
    
    [self removeFromSuperview];
}



- (void)showSelectMeetsInView:(UIView *)inView withMeets:(NSArray *)meets selectedBlock:(MYSSelectMeetViewSelectedBlock)mysSelectedBlock cancelBlock:(MYSSelectMeetViewCancelBlock)mysCancelBlock
{
    _lbTitle.text = @"Select Meet";
    
    _datasource = meets;
    
    _cancelBlock = mysCancelBlock;
    
    _selectBlock = mysSelectedBlock;
    
    [inView addSubview:self];
    
}

- (IBAction)didPressClose:(id)sender
{
    if (_cancelBlock) {
        _cancelBlock(self);
    }
    _selectBlock = nil;
    _cancelBlock = nil;
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
