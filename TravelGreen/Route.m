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




+(int) cowFart: (int) carbon_grams{
    return (int) carbon_grams / 555;
}

+(NSString *) carFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance{
    NSInteger fact_no = arc4random() % 3;
    //System.out.println(fact_no);
    NSString *str = @"";
    
    double co2 = [Route carbon_emmission:mpg andDistance:distance];
    if (fact_no == 0){
        str = [NSString stringWithFormat: @"%ld acres of trees would offset this trips carbon emission in one day", (long)[Route treeAcres_inOneDay:co2] + 1];
    }
    
    else if (fact_no == 1){
        str = [NSString stringWithFormat: @"One acre of trees would take %ld days to offset this trips carbon emmissions", (long)[Route treeAcres_inOneDay:co2] + 1];
    }
    else if (fact_no == 2){
        str = [NSString stringWithFormat: @"The carbon emissions from this trip would be equivalent to  %ld cow farts", (long)[Route cowFart:carbon] +1];
    }
    return str;
}

+(NSString *) walkFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance{
    NSInteger fact_no = arc4random() % 3;
    //System.out.println(fact_no);
    NSString *str = @"";
    

    if (fact_no == 0){
        double chipotle = [Route gasMoney:mpg andDistance:distance] / 7.0;
        if (chipotle >= 1){
            str = [NSString stringWithFormat: @"You can buy %d Chipotle burritos with the money you'll save", (int)chipotle];
        } else {
            str = [NSString stringWithFormat: @"You can buy %d packs of gum with the money you'll save", (int)[Route gasMoney:mpg andDistance:distance]];
        }
    }
    
    else if (fact_no == 1){
       str = @"This is about how far Rajon Rondo runs in a game";
    }
    else if (fact_no == 2){
        str = @"This is about how far Lioenl Messi runs in a game";
    }

    return str;
}

+(NSString *) bikeFunFact: (NSInteger) carbon withMPG: (NSInteger) mpg andDistance: (NSInteger) distance{
    NSInteger fact_no = arc4random() % 3;
    //System.out.println(fact_no);
    NSString *str = @"";
    
    double co2 = [Route carbon_emmission:mpg andDistance:distance];
    if (fact_no == 0){
        double chipotle = [Route gasMoney:mpg andDistance:distance] / 7.0;
        if (chipotle >= 1){
            str = [NSString stringWithFormat: @"You can buy %d Chipotle burritos with the money you'll save", (int)chipotle];
        } else {
            str = [NSString stringWithFormat: @"You can buy %d packs of gum with the money you'll save", (int)[Route gasMoney:mpg andDistance:distance]];
        }
    }
    else if (fact_no == 1){
        double legs = distance/110;
        if (legs > 0){
            str = [NSString stringWithFormat: @"This is like biking %ld legs of the Tour de France", (long)legs];
        } else {
            double marathon = distance / 26;
            if (marathon > 0){
                str = [NSString stringWithFormat: @"This is like biking %ld marathons", (long)marathon];
            }
            else{
                str = @"That'll be a nice bike ride :)";
            }
        }

    }
    else if (fact_no == 2){
        str = @"Keep it up!  You helping youself AND the environment!";
    }

    return str;
}

@end
