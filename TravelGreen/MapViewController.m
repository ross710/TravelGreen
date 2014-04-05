//
//  ViewController.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@end


@implementation MapViewController {
    GMSMapView *mapView_;
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

    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    //SearchBar
    CGFloat horizontalPadding = 8.0;
    CGFloat verticalPadding = 24.0;
    CGFloat heightOfSearchBar = 64.0;

    CGRect searchFrame = CGRectMake(horizontalPadding,
                                    verticalPadding,
                                    self.view.frame.size.width - horizontalPadding*2,
                                    heightOfSearchBar);
    UITextField *searchBar = [[UITextField alloc] initWithFrame:searchFrame];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    searchBar.leftView = paddingView;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    [searchBar.layer setBorderColor:[UIColor grayColor].CGColor];
    [searchBar.layer setBorderWidth:2.0];
    
    [searchBar setPlaceholder:@"Search for address"];
    

    [self.view addSubview:searchBar];
    
    
    
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

#pragma mark - KVO updates

//http://stackoverflow.com/questions/20967496/google-maps-ios-sdk-getting-current-location-of-user
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!initialLocationUpdate_) {
        initialLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
