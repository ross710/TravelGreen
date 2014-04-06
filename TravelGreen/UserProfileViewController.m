//
//  UserProfileViewController.m
//  LoginPage
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCals;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblWalked;
@property (weak, nonatomic) IBOutlet UILabel *lblCycled;
@property (weak, nonatomic) IBOutlet UILabel *lblDriven;
@property (weak, nonatomic) IBOutlet UILabel *lblTransit;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile:)] ;
    self.navigationItem.title = @"My Profile";
    if (appDelegate.user) {
        self.navigationItem.title = appDelegate.user.username;

        
        
        
    } else {
        NSLog(@"No user");
    }
    
    [self.lblMoney.layer setCornerRadius:68];
    [self.lblMoney setBackgroundColor:[UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:0.9]];
    
    

    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)editProfile:(id)sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
