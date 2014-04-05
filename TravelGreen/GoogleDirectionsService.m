//
//  GoogleDirectionsService.m
//  TravelGreen
//
//  Created by Ross Tang Him on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "GoogleDirectionsService.h"

@implementation GoogleDirectionsService{
@private
    NSDate *startTime_;

}

static NSString *baseGoogleMapsURL = @"http://maps.googleapis.com/maps/api/directions/json?";
static NSString *baseURL = @"https://maps.googleapis.com/maps/api/place/";
static NSString *apiKey = @"AIzaSyB2vzAUIIPyjXG-bUeniwK3lSekjxNEgx8";

//https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Amoeba&types=establishment&location=37.76999,-122.44696&radius=500&sensor=true&key=AIzaSyB2vzAUIIPyjXG-bUeniwK3lSekjxNEgx8



-(void) queryAutocomplete: (NSString*) searchTerm
            withLatitude : (CGFloat) latitude
            andLongitude : (CGFloat) longitude
            withSelector : (SEL) selector
             andDelegate : (id) delegate {
    
    
    BOOL shouldQuery = NO;
    
    if (startTime_ == nil) {
        shouldQuery = YES;
        startTime_ = [NSDate date];
    } else if (-[startTime_ timeIntervalSinceNow] > 0.5) {
        shouldQuery = YES;
    }
    
    if (shouldQuery) {

        startTime_ = [NSDate date];
        
        NSInteger radius = 2;

        NSString *requestString = [NSString
                                   stringWithFormat:@"%@autocomplete/json?input=%@&location=%f,%f&radius%ld&sensor=true&key=%@",
                                   baseURL,
                                   searchTerm,
                                   latitude,
                                   longitude,
                                   (long)radius,
                                   apiKey];

        [self query:requestString withLatitude:latitude andLongitude:longitude withSelector:selector andDelegate:delegate];
    }
}
//https://maps.googleapis.com/maps/api/place/textsearch/xml?query=restaurants+in+Sydney&sensor=true&key=AddYourOwnKeyHere
//https://maps.googleapis.com/maps/api/place/textsearch/json?query=Market+Basket,+Somerville+Avenue,+Somerville,+MA,+United+States&location=42.381382,-71.103798&radius2&key=AIzaSyB2vzAUIIPyjXG-bUeniwK3lSekjxNEgx8

-(void) query: (NSString*) requestString
    withLatitude : (CGFloat) latitude
    andLongitude : (CGFloat) longitude
    withSelector : (SEL) selector
    andDelegate : (id) delegate{
    

    NSURL *requestURL = [NSURL URLWithString:requestString];
        
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        NSData* data = [NSData dataWithContentsOfURL:requestURL];

        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self recieveData:data withSelector:selector withDelegate:delegate];

        });
    });
    
}

-(void) querySearch: (NSString*) searchTerm
            withLatitude : (CGFloat) latitude
            andLongitude : (CGFloat) longitude
            withSelector : (SEL) selector
             andDelegate : (id) delegate {
    NSInteger radius = 2;
    
    NSString *requestString = [NSString
                               stringWithFormat:@"%@textsearch/json?input=%@&radius%ld&sensor=true&key=%@",
                               baseURL,
                               searchTerm,
                               (long)radius,
                               apiKey];
    
    [self query:requestString withLatitude:latitude andLongitude:longitude withSelector:selector andDelegate:delegate];

}


- (void)recieveData: (NSData *) data withSelector: (SEL)selector withDelegate:(id)delegate{
    if (data == nil) {
        return;
    }
    NSError* error;
    NSDictionary *dict = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    [delegate performSelector:selector withObject:dict];
}


@end
