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
@end
