//
//  MYSUploadVC.m
//  swimsync
//
//  Created by Probir Chakraborty on 02/07/15.
//  Copyright (c) 2015 Kerofrog. All rights reserved.
//

#import "MYSUploadVC.h"
#import "MYSUploadResultsCell.h"
#import "MYSShareReportInfo.h"
#import "MSRAccountController.h"

@interface MYSUploadVC () <NetworkingClientDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDataSource> {
    NetworkingClient *networkingClient;
    NSInteger selectedIndex;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView_report;
@property (nonatomic, strong) NSMutableArray *array_report;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MYSUploadVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = -1;
    
    //add refresh control for PullDownToRefresh function
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshScreenData) forControlEvents:UIControlEventValueChanged];
    [self.tableView_report addSubview:self.refreshControl];
    
    self.array_report = [NSMutableArray array];
    [[self getNetworkingClient] requestServerForMethod:APIMethodType_GetSharedReport withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", nil] controller:self forHTTPMethod:HTTPMethod_POST];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods

-(void)refreshScreenData {
    
    [self.refreshControl endRefreshing];

    [[self getNetworkingClient] requestServerForMethod:APIMethodType_GetSharedReport withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", nil] controller:self forHTTPMethod:HTTPMethod_POST];
}

- (IBAction)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            MYSShareReportInfo *reportItem = [self.array_report objectAtIndex:selectedIndex];
            //save data to local DB
            switch (reportItem.resultType) {
                    
                case MYSResultType_AllResult: {
                    [[MYSDataManager shared] saveAllSwimSyncResult:reportItem.reportData];
                }
                    break;
                    
                case MYSResultType_AllPBs: {
                    [[MYSDataManager shared] saveAllPBTimesResult:reportItem.reportData];
                }
                    break;
                    
                case MYSResultType_AllMeets: {
                    [[MYSDataManager shared] saveAllMeetResult:reportItem.reportData];
                }
                    break;
                    
                case MYSResultType_Other: {
                    [[MYSDataManager shared] saveOtherTimesResult:reportItem.reportData];
                }
                    break;
                    
                default:
                    break;
            }
            
            [MethodHelper showAlertViewWithTitle:@"Success!" andMessage:@"The swim result have been imported into your swimsync app" andButtonTitle:NSLocalizedString(@"OK", nil)];
            
            //after saving the data, call API APIMethodType_ReportDownloaded
            [[self getNetworkingClient] requestServerForMethod:APIMethodType_ReportDownloaded withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:reportItem.reportID, @"report_id", nil] controller:self forHTTPMethod:HTTPMethod_POST];
        }
    }
    else if (alertView.tag == 101) {
        if (self && self.delegate && [self.delegate respondsToSelector:@selector(shouldBuySharingFunction)]) {
            [self.delegate shouldBuySharingFunction];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//-(void)importBtnAction:(UIButton*)sender {
//
//    selectedIndex = [sender tag];
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to import these result into your swimsync app?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
//    [alert show];
//}

#pragma mark - === UITableView Datasource ===
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array_report.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MYSUploadResultsCellID";
    
    MYSUploadResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        
        cell = [[MYSUploadResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    [cell.importBtn addTarget:self action:@selector(importBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.importBtn setUserInteractionEnabled:NO];
    
    cell.importBtn.tag = indexPath.row;
    
    MYSShareReportInfo *reportItem = [self.array_report objectAtIndex:indexPath.row];

    cell.coachNameLabel.text = [NSString stringWithFormat:@"%@ sent you:",reportItem.senderName];

    cell.swimmerImgView.image = reportItem.swimmerImage;
    cell.swimmerNameLabel.text = reportItem.swimmerName;
    cell.championShipLabel.text = reportItem.resultTitle;
    cell.championshipTypeLabel.text = reportItem.resultSubTitle;
    
    if ((reportItem.resultType == MYSResultType_AllResult) || (reportItem.resultType == MYSResultType_AllPBs)) {
        cell.championShipLabel.textColor = [UIColor blackColor];
        cell.championshipTypeLabel.hidden = YES;
    }
    else {
        cell.championShipLabel.textColor = [UIColor lightGrayColor];
        cell.championshipTypeLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    selectedIndex = indexPath.row;
    
    if ([[[MYSAppData sharedInstance] appInstructor] purchasedForShareResultValue]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Would you like to import these result into your swimsync app?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 100;
        [alert show];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"To import these results you must purchase the sharing function" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 101;
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 80.0);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [UIAlertView alertViewWithTitle:nil message:@"Do you want to delete this result?" cancelButtonTitle:@"No" otherButtonTitles:[NSArray arrayWithObject:@"Yes"] onDismiss:^(int buttonIndex) {
            
            selectedIndex = indexPath.row;
            MYSShareReportInfo *reportItem = [self.array_report objectAtIndex:selectedIndex];
            [[self getNetworkingClient] requestServerForMethod:APIMethodType_DeleteShareResult withParameter:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[[MYSAppData sharedInstance] appInstructor] instructorID], @"userID", reportItem.reportID, @"resultID", nil] controller:self forHTTPMethod:HTTPMethod_POST];
        } onCancel:^{
        }];
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
            case APIMethodType_GetSharedReport: {
                [self.array_report removeAllObjects];
                
                NSArray *array_temp = [response objectForKey:@"getShareResult"];
                
                for (NSDictionary*item in array_temp)
                    [self.array_report addObject:[MYSShareReportInfo getShareReportFrom:item]];
                
                [self.tableView_report reloadData];
            }
                break;
                
            case APIMethodType_ReportDownloaded: {
                
                [self.array_report removeObjectAtIndex:selectedIndex];
                [self.tableView_report deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                selectedIndex = -1;
            }
                break;
                
            case APIMethodType_DeleteShareResult:{
                [self.array_report removeObjectAtIndex:selectedIndex];
                [self.tableView_report deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                selectedIndex = -1;
            }
                break;
                
            default:
                break;
        }
    }
}


@end
