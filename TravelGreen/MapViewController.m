//
//  ViewController.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleDirectionsService.h"

@interface MapViewController ()

@end


@implementation MapViewController {
    GMSMapView *mapView_;
    UITextField *searchBar_;
    UITableView *autocompleteTable_;
    UIButton *routeButton_;
    GoogleDirectionsService *gds_;
    NSMutableArray *autocompleteItems_;
    BOOL initialLocationUpdate_;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.3581
                                                            longitude:-71.0636
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    
    [self.view insertSubview:mapView_ atIndex:0];
    
    gds_ = [[GoogleDirectionsService alloc] init];
    
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    //SearchBar
    CGFloat horizontalPadding = 8.0;
    CGFloat verticalPadding = 24.0;
    CGFloat heightOfSearchBar = 48.0;
    
    CGRect searchFrame = CGRectMake(horizontalPadding,
                                    verticalPadding,
                                    self.view.frame.size.width - horizontalPadding*2,
                                    heightOfSearchBar);
    searchBar_ = [[UITextField alloc] initWithFrame:searchFrame];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    searchBar_.leftView = paddingView;
    searchBar_.leftViewMode = UITextFieldViewModeAlways;
    [searchBar_ setBackgroundColor:[UIColor whiteColor]];
    [searchBar_.layer setBorderColor:[UIColor grayColor].CGColor];
    [searchBar_.layer setBorderWidth:2.0];
    
    
    [searchBar_ addTarget:self action:@selector(searchBarDidChange) forControlEvents:UIControlEventEditingChanged];
    [searchBar_ setDelegate:self];
    [searchBar_ setPlaceholder:@"Search for address"];
    searchBar_.returnKeyType = UIReturnKeyGo;
    searchBar_.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    
    //Autocomplete
    autocompleteTable_ = [[UITableView alloc] initWithFrame:searchFrame style:UITableViewStylePlain];
    [autocompleteTable_.layer setBorderColor:[UIColor grayColor].CGColor];
    [autocompleteTable_.layer setBorderWidth:2.0];
    //    [autocompleteTable_ setHidden:YES];
    
    [autocompleteTable_ setDelegate:self];
    [autocompleteTable_ setDataSource:self];
    
    [self.view addSubview:autocompleteTable_];
    [self.view addSubview:searchBar_]; //put searchbar on top of autocomplete

    
    routeButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    routeButton_.frame = CGRectMake(0,
                                    self.view.frame.size.height,
                                    self.view.frame.size.width,
                                    0);
    [routeButton_ setBackgroundColor:[UIColor whiteColor]];
    [routeButton_ setTitle:@"Route" forState:UIControlStateNormal];
    [self.view addSubview:routeButton_];
    
    //    [self queryAutocomplete:@"FOOD" withLatitude:42.3581 andLongitude:-71.0636];
    //
    
    //    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    //    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
    //        NSString *directionsRequest = @"comgooglemaps-x-callback://"
    //        @"?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York"
    //        @"&x-success=sourceapp://?resume=true&x-source=TravelGreen";
    //        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
    //        [[UIApplication sharedApplication] openURL:directionsURL];
    //    } else {
    //        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    //    }
    //
    
}

-(void) showRouteButton {
    CGFloat heightOfButton = 48.0;
    CGRect endFrame = CGRectMake(routeButton_.frame.origin.x,
                                 self.view.frame.size.height - heightOfButton,
                                 routeButton_.frame.size.width,
                                 heightOfButton);
    [UIView animateWithDuration:0.5 animations:^{
        routeButton_.frame =  endFrame;
    }];
}

-(void) hideRouteButton {
    CGRect endFrame = CGRectMake(routeButton_.frame.origin.x,
                                 self.view.frame.size.height,
                                 routeButton_.frame.size.width,
                                 0);
    [UIView animateWithDuration:0.5 animations:^{
        routeButton_.frame =  endFrame;
    }];
}

-(void) showAutoComplete {
    CGFloat heightOfAutocompleteTable = 128.0;
    CGRect endFrame = CGRectMake(searchBar_.frame.origin.x,
                                   searchBar_.frame.origin.y + searchBar_.frame.size.height,
                                   searchBar_.frame.size.width,
                                   heightOfAutocompleteTable);
    [UIView animateWithDuration:0.5 animations:^{
        autocompleteTable_.frame =  endFrame;
    }];
}

-(void) hideAutoComplete {
    [UIView animateWithDuration:0.2 animations:^{
        autocompleteTable_.frame =  searchBar_.frame;
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![searchBar_.text isEqualToString:@""]) {
        [self hideAutoComplete];
        [self search:searchBar_.text];
    }
    return YES;
}

-(void) searchBarDidChange {
    [self hideRouteButton];
    [self showAutoComplete];
    
    if ([searchBar_.text isEqualToString:@""]) {
        [self hideAutoComplete];

        [self setAutocompleteData:[[NSArray alloc] init]];
        
    } else {
        [self queryAutocomplete:searchBar_.text
                   withLatitude:mapView_.myLocation.coordinate.latitude
                   andLongitude:mapView_.myLocation.coordinate.longitude];
    }
}

-(void) queryAutocomplete: (NSString *) searchTerm withLatitude:(CGFloat) latitude andLongitude:(CGFloat) longitude {
    
    SEL selector = @selector(setAutocomplete:);
    [gds_ queryAutocomplete:searchTerm withLatitude:latitude andLongitude:longitude withSelector:selector andDelegate:self];
}

-(void) setAutocompleteData: (NSArray*) items {
    autocompleteItems_ = [NSMutableArray arrayWithArray:items];
    [autocompleteTable_ reloadData];
}

-(void) setAutocomplete : (NSDictionary *) dict {
    
    NSArray *predictions = [dict objectForKey:@"predictions"];
    
    autocompleteItems_ = [[NSMutableArray alloc] init];
    for (NSDictionary* prediction in predictions) {
        [autocompleteItems_ addObject:[prediction objectForKey:@"description"]];
    }
    
    [autocompleteTable_ reloadData];
    
}


#pragma mark - KVO updates
//http://stackoverflow.com/questions/20967496/google-maps-ios-sdk-getting-current-location-of-user
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!initialLocationUpdate_) {
        initialLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        [mapView_ animateToLocation:location.coordinate];
        //        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
        //                                                         zoom:15];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocompleteItems_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"autocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [autocompleteItems_ objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [searchBar_ setText:searchTerm];
    [self search:searchTerm];
}

-(NSString *) formatSearchTerms: (NSString *) searchTerm {
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return searchTerm;
}

-(void) searchWithDict: (NSDictionary *) dict {
    [self search:[dict objectForKey:@"description"]];
}
-(void) search: (NSString *) searchTerm {
    searchTerm = [self formatSearchTerms:searchTerm];
    [gds_ querySearch:searchTerm
         withLatitude:mapView_.myLocation.coordinate.latitude
         andLongitude:mapView_.myLocation.coordinate.longitude
         withSelector:@selector(setEnd:)
          andDelegate:self];
}

-(void) setEnd: (NSDictionary *) dict {
    [mapView_ clear];
    NSArray *results = [dict objectForKey:@"results"];
    if ([results count] > 0) {
        [self hideAutoComplete];
        [self.view endEditing:YES];
        
        NSDictionary *result = [results objectAtIndex:0];
        
        NSDictionary *location = [[result objectForKey:@"geometry"] objectForKey:@"location"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[location objectForKey:@"lat"] doubleValue];
        coordinate.longitude = [[location objectForKey:@"lng"] doubleValue];
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = coordinate;
        marker.snippet = [result objectForKey:@"formatted_address"];
        marker.title = [result objectForKey:@"name"];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = mapView_;
        
        [mapView_ animateToLocation:marker.position];
        [mapView_ setSelectedMarker:marker];
        
        [self showRouteButton];
    }
    
}
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
