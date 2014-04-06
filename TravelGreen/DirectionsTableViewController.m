//
//  DirectionsTableTableViewController.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "DirectionsTableViewController.h"
#import "Route.h"
#import "GoogleDirectionsService.h"
#import "AppDelegate.h"


@interface DirectionsTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *directionCell;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableData *responseData;


@end

@implementation DirectionsTableViewController {
    CLLocationCoordinate2D start_;
    CLLocationCoordinate2D end_;
    UIActivityIndicatorView *loadingView_;
    NSInteger count;
    NSInteger selectedRowIndex;

}

@synthesize dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedRowIndex = -1;
    count = 0;
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSInteger sideDimension = 64;
    
//    loadingView_ = [[UIActivityIndicatorView alloc]
//                    initWithFrame:CGRectMake(screenWidth/2 - sideDimension/2, screenHeight/2 - sideDimension/2, sideDimension, sideDimension)];
    loadingView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView_.frame = CGRectMake(screenWidth/2 - sideDimension/2, screenHeight/2 - sideDimension/2, sideDimension, sideDimension);
    [loadingView_.layer setCornerRadius:4.0];
    [loadingView_ startAnimating];
    [loadingView_ setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;

    [window addSubview: loadingView_];
    //this.tableView.cell.
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillDisappear:(BOOL)animated {
    [self hideLoadingView];
}
-(void) hideLoadingView {
    [loadingView_ stopAnimating];
    [loadingView_ removeFromSuperview];
    loadingView_ = nil;
}

-(void) viewDidAppear:(BOOL)animated {
    [self populateRoutes];
}

-(void) populateRoutes {
    
    if (start_.latitude == 0) {
        [self performSelector:@selector(populateRoutes) withObject:nil afterDelay:0.5];
    } else {
        GoogleDirectionsService *gds = [[GoogleDirectionsService alloc] init];

        [gds queryDirections:@"driving" withStart:start_ andEnd:end_ withSelector:@selector(addToList:) andDelegate:self];
        [gds queryDirections:@"walking" withStart:start_ andEnd:end_ withSelector:@selector(addToList:) andDelegate:self];
        [gds queryDirections:@"bicycling" withStart:start_ andEnd:end_ withSelector:@selector(addToList:) andDelegate:self];
        [gds queryDirections:@"transit" withStart:start_ andEnd:end_ withSelector:@selector(addToList:) andDelegate:self];

    }
}

-(void) selectWalking {
    if (self.dataSource.count > 0) {
        NSInteger c = 0;
        for (Route *route in self.dataSource) {
            if ([route.modeOfTransport isEqualToString:@"WALKING"]) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:c inSection:0];
                [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self tableView:self.tableView didSelectRowAtIndexPath:path];

                break;
            }
            c++;
        }
    }
}

-(void) addToList :(NSDictionary *) dict {
    
    NSArray *routes = [dict objectForKey:@"routes"];
    if ([routes count] > 0) {
        NSDictionary *route = [routes objectAtIndex:0];
        
        NSArray *legs = [route objectForKey:@"legs"];
        NSDictionary *leg = [legs objectAtIndex:0];
        NSDictionary *distance = [leg objectForKey:@"distance"];
        NSDictionary *duration = [leg objectForKey:@"duration"];
        NSDictionary *step = [[leg objectForKey:@"steps"] objectAtIndex:0];
        
        
        Route *r = [[Route alloc] init];
        r.modeOfTransport = [step objectForKey:@"travel_mode"];
        
        for (NSDictionary * step_ in [leg objectForKey:@"steps"]) {
            if ([[step_ objectForKey:@"travel_mode"] isEqualToString:@"TRANSIT"]) {
                r.modeOfTransport = @"TRANSIT";
                break;
            }
        }

        r.travelTime = [duration objectForKey:@"text"];
        r.distance = [[distance objectForKey:@"value"] floatValue]*0.000621371;

        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
        [tempArray addObject:r];
        
        self.dataSource = tempArray;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.dataSource count]-1 inSection:0];
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];

        
    }
    count++;
    if (count >= 4) {
        [self hideLoadingView];
        [self selectWalking];
    }
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
        //display popup
        dispatch_async(dispatch_get_main_queue(), ^{
            //Code that presents or dismisses a view controller here
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Submit" message:@"Travel data updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    }
}

- (IBAction)onSubmit:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UITableViewCell* cell = (UITableViewCell*)[sender superview];
    int row = [self.tableView indexPathForCell:cell].row;
    
    Route *r = [self.dataSource objectAtIndex:row];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://localhost/Hackathon/login.php"]];
    
    NSString *format = [NSString stringWithFormat:@"user_id=%@&travel_type=%@&miles=%0.1f&carbon=%0.1f", appDelegate.user.userId, r.modeOfTransport, r.distance, r.carbonEmmision];
    
    NSString *params = [[NSString alloc] initWithFormat:format];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        // Release the receivedData object.
        NSLog(@"connection failed");
        
        // Inform the user that the connection failed.
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(indexPath.row == selectedRowIndex) {
        return 260;
    }
    return 100;
}


-(void) saveStartLocation: (CLLocationCoordinate2D) start andEndLocation: (CLLocationCoordinate2D) end {
    start_ = start;
    end_ = end;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        Route *bus = [[Route alloc] init];
//        bus.modeOfTransport = @"Public Transit";
//        bus.travelTime = @"(1 hr 30 min)";
//        bus.distance = 30;
//        
//        Route *bus2 = [[Route alloc] init];
//        bus2.modeOfTransport = @"Walking";
//        bus2.travelTime = @"(2 hr 5 min)";
//        bus2.distance = .3;
//        
//        Route *bus3 = [[Route alloc] init];
//        bus3.modeOfTransport = @"Cycling";
//        bus3.travelTime = @"(2 hr 3 min)";
//        bus3.distance = 3.5;
//        
//        [bus setFact];
//        [bus2 setFact];
//        [bus3 setFact];
//        NSArray *array = [NSArray arrayWithObjects:bus, bus2, bus3, nil];
//        self.dataSource = array;
    }
    return self;
}

- (void)setTableData:(NSMutableArray *)array
{
    self.dataSource = array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DirectionsTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DirectionsTableViewCell" owner:self options:nil];
        cell = self.directionCell;
        self.directionCell = nil;
    }
    

    Route *route = [dataSource objectAtIndex:indexPath.row];

//    UILabel *label = (UILabel *) [cell viewWithTag:1];
   
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:1];
    UILabel *money = (UILabel *) [cell viewWithTag:2];
    UITextView *textView = (UITextView *) [cell viewWithTag:3];
    UILabel *timeLbl = (UILabel *) [cell viewWithTag:4];
    UILabel *caloriesLbl = (UILabel *) [cell viewWithTag:6];
    UILabel *distanceLbl = (UILabel *) [cell viewWithTag:7];
    UIButton *directionsButton = (UIButton *) [cell viewWithTag:8];
    UIButton *submitButton = (UIButton *) [cell viewWithTag:11];

    UILabel *factLbl = (UILabel *) [cell viewWithTag:10];
    
    
    factLbl.text = @"Emissions come up to: ";

    [directionsButton addTarget:self action:@selector(gotoGoogleMaps:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];

    [money.layer setCornerRadius:32.0];
    
    
    timeLbl.text = route.travelTime;
    distanceLbl.text = [NSString stringWithFormat:@"%.2f miles", route.distance];
    


    
    if ([route.modeOfTransport isEqualToString:@"DRIVING"]) {
        [imageView setImage:[UIImage imageNamed:@"car.png"]];
        money.backgroundColor = [UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:0.9];
        CGFloat moneySpent = [Route gasMoney:0 andDistance:route.distance];
        money.text = [NSString stringWithFormat:@"-$%.2f", moneySpent];

    } else if ([route.modeOfTransport isEqualToString:@"WALKING"]) {
        [imageView setImage:[UIImage imageNamed:@"walking.png"]];
        CGFloat calories = [Route walkCals:route.distance];
        [caloriesLbl setText:[NSString stringWithFormat:@"%d", (int)calories]];
        

        money.backgroundColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:0.9];

    } else if ([route.modeOfTransport isEqualToString:@"TRANSIT"]) {
        [imageView setImage:[UIImage imageNamed:@"transit.png"]];
        money.backgroundColor = [UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:0.9];
        money.text = [NSString stringWithFormat:@"-$%.2f", 2.00];


    } else {
        [imageView setImage:[UIImage imageNamed:@"cycling.png"]];
        money.backgroundColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:0.9];

        CGFloat calories = [Route bikeCals:0 andDistance:route.distance];
        [caloriesLbl setText:[NSString stringWithFormat:@"%d", (int)calories]];
    }
//    switch(route.levelOfHarm) {
//        case 1:
//            cell.backgroundColor = [UIColor colorWithRed:11.0/255 green:211.0/255 blue:24.0/255 alpha:0.2];
//            break;
//        default:
//            break;
//    }
//    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CGRect shadowFrame = cell.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    cell.layer.shadowPath = shadowPath;
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    cell.clipsToBounds = YES;
    return cell;
}

-(IBAction)gotoGoogleMaps:(id)sender {
    UITableViewCell* cell = (UITableViewCell*)[sender superview];
    int row = [self.tableView indexPathForCell:cell].row;
    
    Route *r = [self.dataSource objectAtIndex:row];
    

    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSString *requestString = [NSString
                                   stringWithFormat:@"comgooglemaps-x-callback://?saddr=%f,%f&daddr=%f,%f&directionsmode=%@&x-success=sourceapp://?resume=true&x-source=TravelGreen",
                                   start_.latitude,
                                   start_.longitude,
                                   end_.latitude,
                                   end_.longitude,
                                   [r.modeOfTransport lowercaseString]];
        NSURL *directionsURL = [NSURL URLWithString:requestString];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

//http://stackoverflow.com/questions/7399119/custom-uitableviewcell-button-action
- (UITableViewCell *)parentCell
{
    UIView *superview = self.tableView.superview;
    while( superview != nil ) {
        if( [superview isKindOfClass:[UITableViewCell class]] )
            return (UITableViewCell *)superview;
        
        superview = superview.superview;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource count];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return dataSource[(NSUInteger)indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRowIndex = indexPath.row;
    [tableView beginUpdates];
    [tableView endUpdates];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
