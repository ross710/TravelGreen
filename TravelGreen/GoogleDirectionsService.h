//
//  GoogleDirectionsService.h
//  TravelGreen
//
//  Created by Ross Tang Him on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleDirectionsService : NSObject

-(void) queryAutocomplete: (NSString*) searchTerm
            withLatitude : (CGFloat) latitude
            andLongitude : (CGFloat) longitude
            withSelector : (SEL) selector
             andDelegate : (id) delegate;

-(void) querySearch: (NSString*) searchTerm
      withLatitude : (CGFloat) latitude
      andLongitude : (CGFloat) longitude
      withSelector : (SEL) selector
       andDelegate : (id) delegate;
@end
