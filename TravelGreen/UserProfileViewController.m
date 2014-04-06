//
//  UserProfileViewController.m
//  LoginPage
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AppDelegate.h"
#import "Route.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCals;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblWalked;
@property (weak, nonatomic) IBOutlet UILabel *lblCycled;
@property (weak, nonatomic) IBOutlet UILabel *lblDriven;
@property (weak, nonatomic) IBOutlet UILabel *lblTransit;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
//    self.scrollView.contentSize = CGSizeMake(320, 454);
//    self.view = self.scrollView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile:)] ;
    self.navigationItem.title = @"My Profile";
    
    
    if (appDelegate.user) {
        User *user = appDelegate.user;
        self.navigationItem.title = user.username;

        
        NSInteger cals = [Route walkCals:user.milesWalked] + [Route bikeCals:user.bikeMpg andDistance:user.milesBiked];
        self.lblCals.text = [NSString stringWithFormat:@"%d", cals];
        
        CGFloat money = [Route gasMoney:user.carMpg andDistance:(user.milesBiked + user.milesDriven)];
        self.lblMoney.text = [NSString stringWithFormat:@"$%.2f", money];
        
        self.lblWalked.text = [NSString stringWithFormat:@"%d Miles Walked", user.milesWalked];
        self.lblCycled.text = [NSString stringWithFormat:@"%d Miles Biked", user.milesBiked];
        self.lblDriven.text = [NSString stringWithFormat:@"%d Miles Driven", user.milesDriven];
        self.lblTransit.text = [NSString stringWithFormat:@"%d Miles on Public Transit", user.milesPt];
        
        
        
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
