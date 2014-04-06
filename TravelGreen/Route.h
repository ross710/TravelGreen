//
//  Route.h
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property(nonatomic) NSString *startLocation;
@property(nonatomic) NSString *endLocation;
@property(nonatomic) NSString *modeOfTransport;
@property(nonatomic) NSString *travelTime;
@property(nonatomic) NSString *energyFact;
@property(nonatomic) int levelOfHarm; //int to choose which image to use
@property(nonatomic) float carbonEmmision;
@property(nonatomic) float distance; //miles

-(void) setFact;
+(int) carbon_emmission: (int) mpg andDistance: (double) distanceInMiles;
+(double) gasMoney: (int) mpg andDistance: (double) distanceInMiles;

+(double) gasGallons:(int) mpg andDistance: (double) distanceInMiles;

+(int) walkCals:(double) distanceInMiles;
+(int) bikeCals: (int) weight andDistance: (double) distance;
+(double) treeAcres_inOneDay:(double) c_emmision;
+(NSString *) bikeFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance;
+(NSString *) walkFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance;
+(NSString *) carFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance;
@end
