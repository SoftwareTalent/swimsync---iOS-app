//
//  MYSViewController.m
//  MySwimTimes
///Users/tomorrow/Desktop/IOS_Code_SwimSync/Swimsync/MySwimTimes/controllers/UploadResults/MSRAccountController.m
//  Created by Kerofrog on 3/3/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *menuItems;
    NSArray *menuImages;
}
@end

@implementation MenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    menuItems = [[NSArray alloc] initWithObjects:@"Upload shared swimsync results",@"Import results from My Swim Results", nil];
    menuImages = [[NSArray alloc] initWithObjects:@"UploadIcon",@"SyncIcon", nil];
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - === UITableView Datasource ===
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.00;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [cell.textLabel setMinimumScaleFactor:0.5];
    [cell.imageView setImage:[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
                [self onUpload:nil];
            break;
            
        case 1:
            [self onImport:nil];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (IBAction)onBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onUpload:(id)sender {
    
    [self performSegueWithIdentifier:@"to_upload" sender:nil];
}

- (IBAction)onImport:(id)sender {

     [self performSegueWithIdentifier:@"to_import" sender:nil];
    
}

- (IBAction)to_help:(id)sender {
  
    [self performSegueWithIdentifier:@"to_help" sender:nil];
  }
@end
