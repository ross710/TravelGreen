//
//  LoginViewController.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *_txtPassword;

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation LoginViewController



- (IBAction)onLogin:(id)sender {
    [self initNetworkCommunication];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"response data - %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    [self parseData];
}

- (void)parseData
{
    //NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.responseData];
    NSError *jsonError = nil;
    id jsonResult = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&jsonError];
    
    if(jsonResult != nil)
    {
        
        //update model using json result
        NSDictionary *dict = jsonResult;
        User *user = [[User alloc] init];
        
        user.userId = [dict objectForKey:@"user_Id"];
        user.username = [dict objectForKey:@"username"];
        user.weight = [[dict objectForKey:@"weight"] intValue];
        user.sex = [dict objectForKey:@"sex"];
        user.carbonEmission = [[dict objectForKey:@"carbon_emission"] intValue];
        user.milesBiked = [[dict objectForKey:@"miles_biked"] intValue];
        user.milesWalked = [[dict objectForKey:@"miles_walked"] intValue];
        user.milesDriven = [[dict objectForKey:@"miles_driven"] intValue];
        user.milesPt = [[dict objectForKey:@"miles_pt"] intValue];
        user.carMpg = [[dict objectForKey:@"car_mpg"] intValue];
        user.bikeMpg = [[dict objectForKey:@"bike_speed"] intValue];
        
        NSLog(@"%@", user.userId);
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.user = user;
        
        //GOTO USER PROFILE
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UITabBarController *vc = [storyboard instantiateInitialViewController];
        vc.selectedIndex = 1;
        
        AppDelegate* appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController = vc;

    }
}

- (void)initNetworkCommunication {
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://localhost/Hackathon/login.php"]];
    
    NSString *format = [NSString stringWithFormat:@"username=%@&password=%@", self._txtUsername.text, self._txtPassword.text];
    NSString *params = [[NSString alloc] initWithFormat:format];//@"username=bess&password=bess"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        // Release the receivedData object.
        NSLog(@"connection failed");
        
        // Inform the user that the connection failed.
    }
    
}



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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
