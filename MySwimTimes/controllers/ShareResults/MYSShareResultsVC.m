//
//  MYSShareResultsVC.m
//  swimsync
//
//  Created by Probir Chakraborty on 03/07/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MYSShareResultsVC.h"
#import "MYSShareResultCell.h"
#import "MYSUserInfo.h"
#import "MYSCustomTF.h"

@interface MYSShareResultsVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NetworkingClientDelegate> {
    NetworkingClient *networkingClient;
    NSMutableArray  * searchResults;
    BOOL isSearchInProgress;
}

@property (nonatomic, strong) NSString *selectedUserID;
@property (strong, nonatomic) IBOutlet UITableView *tblViewSearch;
@property (strong, nonatomic) NSMutableArray *arrayForUser;
@property (weak, nonatomic) IBOutlet MYSCustomTF *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareResultBtn;


- (IBAction)shareResultBtnAction:(UIButton *)sender;

@end

@implementation MYSShareResultsVC

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.shareResultBtn setEnabled:NO];

    _arrayForUser = [NSMutableArray array];
    searchResults = [NSMutableArray array];
    self.shareResultBtn.layer.cornerRadius = 3.0f;
    isSearchInProgress = NO;
    [_searchTextField setlefImageWithName:@"user_icon.png"];
    [[self getNetworkingClient] requestServerForMethod:APIMethodType_UserList withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", nil] controller:self forHTTPMethod:HTTPMethod_POST];
    self.tblViewSearch.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tblViewSearch.layer.borderWidth = 1.0f;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Event Controllers Method

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.tblViewSearch.hidden = YES;
    [self.tblViewSearch reloadData];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MYSShareResultCellID";
    MYSShareResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        
        cell = [[MYSShareResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MYSUserInfo *userObj = [searchResults objectAtIndex:indexPath.row];
    cell.usernameLabel.text = userObj.userName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYSUserInfo *userObj = [searchResults objectAtIndex:indexPath.row];
    self.searchTextField.text = userObj.userName;
    self.selectedUserID = userObj.userID;
    
    [self.view endEditing:YES];
    isSearchInProgress = NO;
    self.tblViewSearch.hidden = YES;
//    [searchResults removeAllObjects];
}

#pragma mark - TextField Delegate Method
-(void)refreshSearchedDataForText:(NSString*)text {
    
    isSearchInProgress = [text length];
    
    searchResults = [NSMutableArray arrayWithArray:[self.arrayForUser filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.userName CONTAINS[c] %@",text]]];
    
//    if ([text length] == 0)
//        searchResults = self.arrayForUser;
    
    self.tblViewSearch.hidden = NO;
    
    CGRect tablerect = self.tblViewSearch.frame;
    tablerect.size.height = MIN(88.0, searchResults.count * 44.0);
    [self.tblViewSearch setFrame:tablerect];
    
    [self.tblViewSearch reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self refreshSearchedDataForText:textField.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newTextToBe = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [self refreshSearchedDataForText:newTextToBe];

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.tblViewSearch.hidden = YES;
    return YES;
}

#pragma  mark - Button Action Methods
- (IBAction)shareResultBtnAction:(UIButton *)sender {
    
    if (self.selectedUserID == nil) {
        for (MYSUserInfo *userObj in self.arrayForUser) {
            if ([self.searchTextField.text caseInsensitiveCompare:userObj.userName] == NSOrderedSame) {
                self.selectedUserID = userObj.userID;
                break;
            }
        }
    }
    
    if (self.selectedUserID) {
        [[self getNetworkingClient] requestServerForMethod:APIMethodType_ShareReport withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"uid_sender", self.selectedUserID, @"uid_receiver", self.string_resultData, @"result", nil] controller:self forHTTPMethod:HTTPMethod_POST];
    }
    else {
        [MethodHelper showAlertViewWithTitle:nil andMessage:@"Please select a user to share results." andButtonTitle:NSLocalizedString(@"OK", nil)];
    }
}

#pragma mark - * * * * Networking Methods * * * *
-(NetworkingClient*)getNetworkingClient {
    if (!networkingClient) networkingClient = [[NetworkingClient alloc] init];
    
    [networkingClient setClientDelegate:self];
    return networkingClient;
}

-(void)didRecieveResponse:(id)response withError:(NSString*)errMessage errorCode:(NSInteger)code forMethod:(APIMethodType)methodType {
    
    if (errMessage) {
        [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString(errMessage, nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
    }
    else {
        switch (methodType) {
            case APIMethodType_UserList: {

                [self.arrayForUser removeAllObjects];
                
                NSArray *array_temp = [response valueForKey:@"userList"];
                
                for (NSDictionary*userItem in array_temp)
                    [self.arrayForUser addObject:[MYSUserInfo getUserInfoFrom:userItem]];
                
                [self.tblViewSearch reloadData];
            }
                break;
                
            case APIMethodType_ShareReport: {
                
                [MethodHelper showAlertViewWithTitle:nil andMessage:NSLocalizedString([response valueForKey:@"responseMessage"], nil) andButtonTitle:NSLocalizedString(@"OK", nil)];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    [self.shareResultBtn setEnabled:(self.arrayForUser.count > 0)];
}

@end
