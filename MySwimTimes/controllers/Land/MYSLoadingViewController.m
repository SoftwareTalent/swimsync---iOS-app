//
//  MYSLoadingViewController.m
//  MySwimTimes
//
//  Created by hanjinghe on 9/21/14.
//  Copyright (c) 2014 Kerofrog. All rights reserved.
//

#import "MYSLoadingViewController.h"
#import "MYSLoginVC.h"

@interface MYSLoadingViewController ()

@property (nonatomic, assign) IBOutlet UIImageView *ivBack;

@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation MYSLoadingViewController {
    
    UIStoryboard *additionalStoryBoard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBackgroundImage];
    
    [self.activityView startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(moveoToMenuScreen) userInfo:nil repeats:NO];
}

- (void) setBackgroundImage
{
    CGSize size = self.view.frame.size;
    
    NSString *imageName = @"";
    if(size.height >= 1104)
    {
        imageName = @"Default55";
    }
    else if(size.height >= 667)
    {
        imageName = @"Default47";
    }
    else if(size.height >= 568)
    {
        imageName = @"Default@2x~568h";
    }
    else
    {
        imageName = @"Default";
    }
    
    self.ivBack.image = [UIImage imageNamed:imageName];
}

- (void) moveoToMenuScreen
{
//    [self performSegueWithIdentifier:@"menu" sender:nil];
    MYSLoginVC *loginVC = [self.storyboard
                           instantiateViewControllerWithIdentifier:@"MYSLoginVCID"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
