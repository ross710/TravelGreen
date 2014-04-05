//
//  DirectionsTableTableViewController.h
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface DirectionsTableViewController : UITableViewController
{
    NSArray *dataSource;
}
@property (nonatomic,retain) NSArray *dataSource;
-(void) saveStartLocation: (CLLocationCoordinate2D) start andEndLocation: (CLLocationCoordinate2D) end;
- (void)setTableData:(NSMutableArray *)array;
@end
