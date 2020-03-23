//
//  MYSGraphFilterViewController.m
//  MySwimTimes
//
//  Created by Tran Thanh Nhan on 4/17/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSGraphFilterViewController.h"

@interface MYSGraphFilterViewController () <UITableViewDataSource, UITableViewDelegate, MYSOptionsTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tbvOptions;

- (IBAction)didPressDoneButton:(id)sender;
@end

@implementation MYSGraphFilterViewController {
    NSString *_stroke;
    NSString *_course;
    NSString *_numberOfTimes;
    NSString *_distance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_tbvOptions registerClass:[MYSOptionsTableViewCell class] forCellReuseIdentifier:MYSOptionsTableViewCellID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setDatasource:(NSMutableArray *)datasource
{
    _datasource = datasource;
    for (MYSOptionsCellData *data in _datasource) {
        switch (data.cellType) {
            case MYSOptionsTableViewRowTypeNone: {
                break;
            }
            case MYSOptionsTableViewRowTypeCourse:{
                _course = data.cellValue;
                break;
            }
            case MYSOptionsTableViewRowTypeStroke:{
                _stroke = data.cellValue;
                break;
            }
            case MYSOptionsTableViewRowTypeInputNumber:{
                _numberOfTimes = data.cellValue;
                break;
            }
            case MYSOptionsTableViewRowTypeDistance:{
                _distance = data.cellValue;
                break;
            }
            default:
                break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYSOptionsTableViewCellID];
    if (cell == nil) {
        cell = [[MYSOptionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MYSOptionsTableViewCellID];
    }
    cell.delegate = self;
    cell.refTableView = tableView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MYSOptionsCellData *data = _datasource[indexPath.row];
    cell.cellName.text = data.cellTitle;
    cell.style = data.cellType;
    
    
    cell.cellValue.userInteractionEnabled = NO;
    switch (data.cellType) {
        case MYSOptionsTableViewRowTypeStroke: {
            [cell setSelectedStroke:[data.cellValue integerValue]];
            break;
        }
        case MYSOptionsTableViewRowTypeCourse: {
            [cell setSelectedCourse:[data.cellValue intValue]];
            break;
        }
        case MYSOptionsTableViewRowTypeDistance:
        case MYSOptionsTableViewRowTypeInputNumber:
            cell.cellValue.userInteractionEnabled = NO;
            cell.cellValue.text = data.cellValue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.cellValue.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSOptionsCellData *data = _datasource[indexPath.row];
    MYSOptionsTableViewCell *cell = (MYSOptionsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (data.cellType) {
        case MYSOptionsTableViewRowTypeStroke:
            
            break;
        case MYSOptionsTableViewRowTypeDistance:
        case MYSOptionsTableViewRowTypeInputNumber: {
            cell.cellValue.userInteractionEnabled = YES;
            [cell.cellValue becomeFirstResponder];
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - === Custom cell delegate ===
- (void)tableView:(UITableView *)tableView didChangeValue:(NSString *)value ofTextField:(UITextField *)textField inCell:(MYSOptionsTableViewCell *)mysCell
{
    NSIndexPath *indexPath = [tableView indexPathForCell:mysCell];
    MYSOptionsCellData *data = _datasource[indexPath.row];
    
    switch (data.cellType) {
        case MYSOptionsTableViewRowTypeDistance: {
            _distance = value;
            break;
        }
        case MYSOptionsTableViewRowTypeInputNumber: {
            _numberOfTimes = value;
            if ([value intValue] > 30) {
                textField.text = [NSString stringWithFormat:@"%d", 30];
                _numberOfTimes = [NSString stringWithFormat:@"%d", 30];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectStroke:(int)strokeID inCell:(MYSOptionsTableViewCell *)mysCell
{
    
    _stroke = [NSString stringWithFormat:@"%d", strokeID];
    
}

- (void)tableView:(UITableView *)tableView didSelectCourse:(int)courseID inCell:(MYSOptionsTableViewCell *)mysCell
{

    _course = [NSString stringWithFormat:@"%d", courseID];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - === Actions ===
- (IBAction)didPressDoneButton:(id)sender
{
    for (MYSOptionsCellData *data in _datasource) {
        switch (data.cellType) {
            case MYSOptionsTableViewRowTypeNone: {
                break;
            }
            case MYSOptionsTableViewRowTypeCourse:{
                data.cellValue = _course;
                break;
            }
            case MYSOptionsTableViewRowTypeStroke:{
                data.cellValue = _stroke;
                break;
            }
            case MYSOptionsTableViewRowTypeInputNumber:{
                data.cellValue = _numberOfTimes;
                break;
            }
            case MYSOptionsTableViewRowTypeDistance:{
                data.cellValue = _distance;
                break;
            }
            default:
                break;
        }
    }
    
    if ([_delegate respondsToSelector:@selector(MYSGraphFilterViewController:didPressDoneButton:withData:)]) {
        [_delegate MYSGraphFilterViewController:self didPressDoneButton:sender withData:_datasource];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end


@implementation MYSOptionsCellData



@end

#pragma mark - === Cell Implement ===
/// Cell
static float const kLeftPadding = 15.0f;
static CGSize const kStrokeButtonSize = {35.0f, 30.0f};
static CGSize const kCourseSize = {120.0f, 30.0f};


@implementation MYSOptionsTableViewCell {
    NSMutableArray *_btnStrokes;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _cellName = [[UILabel alloc] initWithFrame:CGRectZero];
        _cellName.backgroundColor = [UIColor clearColor];
        _cellName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellName];
        
        _cellValue = [[UITextField alloc] initWithFrame:CGRectZero];
        _cellValue.borderStyle = UITextBorderStyleNone;
        _cellValue.textAlignment = NSTextAlignmentRight;
        _cellValue.delegate = self;
        [_cellValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_cellValue];
        
        _strokeGroup = [[UIView alloc] initWithFrame:CGRectZero];
//        _strokeGroup.backgroundColor = [UIColor greenColor];
        _btnStrokes = [NSMutableArray array];
        for (int i = 0; i < kTotalStroke; i++) {
            UIButton *stroke = [UIButton buttonWithType:UIButtonTypeCustom];
            stroke.layer.borderColor = [[UIColor blueColor] CGColor];
            stroke.layer.borderWidth = 1.0;
            stroke.layer.cornerRadius = 2.0f;
            [stroke setTitle:[[MYSDataManager shared] getStrokeNameByType:i] forState:UIControlStateNormal];
            [stroke setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            stroke.tag = i;
            [stroke addTarget:self action:@selector(didSelectStroke:) forControlEvents:UIControlEventTouchUpInside];
            
            [_strokeGroup addSubview:stroke];
            [_btnStrokes addObject:stroke];
        }
        
        [self.contentView addSubview:_strokeGroup];
        
        _course = [[UISegmentedControl alloc] initWithItems:@[MTLocalizedString(@"Short"), MTLocalizedString(@"Long")]];
        [_course addTarget:self action:@selector(didChangeValueOfSegment:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_course];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.bounds.size;
    _cellValue.hidden = YES;
    _strokeGroup.hidden = YES;
    _course.hidden = YES;
    
    [_cellName sizeToFit];
    _cellName.frame = CGRectMake(kLeftPadding,
                                 (contentSize.height - CGRectGetHeight(_cellName.frame)) / 2,
                                 CGRectGetWidth(_cellName.frame),
                                 CGRectGetHeight(_cellName.frame));
    
    switch (_style) {
        case MYSOptionsTableViewRowTypeNone: {
            break;
        }
        case MYSOptionsTableViewRowTypeDistance:
        case MYSOptionsTableViewRowTypeInputNumber: {
            _cellValue.hidden = NO;
            _cellValue.frame = CGRectMake(CGRectGetMaxX(_cellName.frame),
                                          0,
                                          contentSize.width - CGRectGetMaxX(_cellName.frame) - kLeftPadding,
                                          contentSize.height);
            break;
        }
            
        case MYSOptionsTableViewRowTypeStroke: {
            _strokeGroup.hidden = NO;
            
            __weak UIButton *button;
            for (int i = 0; i < kTotalStroke; i++) {
                button = _btnStrokes[i];
                button.frame = CGRectMake(i * 10 + kStrokeButtonSize.width * i,
                                          (contentSize.height - kStrokeButtonSize.height) / 2,
                                          kStrokeButtonSize.width,
                                          kStrokeButtonSize.height);
            }
            
            _strokeGroup.frame = CGRectMake(contentSize.width - kLeftPadding - CGRectGetMaxX(button.frame),
                                            0,
                                            CGRectGetMaxX(button.frame),
                                            contentSize.height);
            break;
        }
            
        case MYSOptionsTableViewRowTypeCourse: {
            _course.hidden = NO;
            
            _course.frame = CGRectMake(contentSize.width - kLeftPadding - kCourseSize.width,
                                       (contentSize.height - kCourseSize.height) / 2,
                                       kCourseSize.width,
                                       kCourseSize.height);
            break;
        }
            
        default:
            break;
    }
    
    
}
- (void)setSelectedStroke:(int)stroke
{
    for (UIButton *button in _btnStrokes) {
        if (button.tag == stroke) {
            [self didSelectStroke:button];
            break;
        }
    }
}

- (void)setSelectedCourse:(int)course
{
    [_course setSelectedSegmentIndex:course];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.userInteractionEnabled = NO;
}

- (IBAction)textFieldDidChange:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tableView:didChangeValue:ofTextField:inCell:)]) {
        UITextField *textField = sender;
        [_delegate tableView:_refTableView didChangeValue:textField.text ofTextField:textField inCell:self];
    }
}

- (IBAction)didSelectStroke:(id)sender {
    for (UIButton *button in _btnStrokes) {
        if (sender == button) {
            button.backgroundColor = [UIColor greenColor];
        } else {
            button.backgroundColor = [UIColor clearColor];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(tableView:didSelectStroke:inCell:)]) {
        [_delegate tableView:_refTableView didSelectStroke:((UIButton *)sender).tag inCell:self];
    }
}

- (IBAction)didChangeValueOfSegment:(id)sender
{
    UISegmentedControl *seg = sender;
    if ([_delegate respondsToSelector:@selector(tableView:didSelectCourse:inCell:)]) {
        [_delegate tableView:_refTableView didSelectCourse:seg.selectedSegmentIndex inCell:self];
    }
}
@end