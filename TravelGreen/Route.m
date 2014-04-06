//
//  Route.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "Route.h"

@implementation Route


- (id)init {
    self = [super init];

    return self;
}

- (void)setFact
{
    //calculate data
    self.energyFact = @"You can save enough energy to plant 100 trees!";
}

+(int) carbon_emmission: (int) mpg andDistance: (double) distanceInMiles{
    
    if (mpg == 0){
        
        mpg = 21;
        
    }
    
    double emmissions = 8887/mpg;
    
    return (int)(emmissions * distanceInMiles);
    
}



+(double) gasMoney: (int) mpg andDistance: (double) distanceInMiles{
    
    if (mpg == 0){
        
        mpg = 21;
        
    }
    
    double gasPrice = 3.37;
    
    double val = (distanceInMiles/mpg)*gasPrice;
    
    val= (int)(val * 100 + 0.5) / 100.0;
    
    return(val);
    
}



+(double) gasGallons:(int) mpg andDistance: (double) distanceInMiles{
    
    double val = distanceInMiles / mpg;
    
    val= (int)(val * 100 + 0.5) / 100.0;
    
    return(val);
    
}



+(int) walkCals:(double) distanceInMiles{
    
    return ((int)(100.0 * distanceInMiles));
    
}



+(double) treeAcres_inOneDay:(double) c_emmision{
    
    //3342 grams of carbon per day on average
    
    double val = c_emmision / 3342;
    
    val= (int)(val * 100 + 0.5) / 100.0;
    
    return(val);
    
}

+(int) bikeCals: (int) weight andDistance: (double) distance {
    if (weight == 0) {
        weight = 160;
    }
    
    double calsPerMile = (double) weight*0.25;
    return (int)(distance *calsPerMile);
}
@end
