//
//  LeaderboardController.m
//  TravelGreen
//
//  Created by Ross Tang Him on 4/6/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "LeaderboardController.h"
#import "User.h"
#import "Route.h"

@interface LeaderboardController ()

@end

@implementation LeaderboardController {
    NSArray *calories;
    NSArray *emissions;
    NSArray *currentArray;
    UISegmentedControl *sc;
}

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
    
    sc = [[UISegmentedControl alloc] initWithItems:@[@"Calories", @"Emissions Impact"]];
    [sc setSelectedSegmentIndex:0];
    
    [sc addTarget:self action:@selector(didChangeTypeOfLeaderBoard:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = sc;

    
    User *u1 = [[User alloc] init];
    User *u2 = [[User alloc] init];
    User *u3 = [[User alloc] init];
    User *u4 = [[User alloc] init];
    User *u5 = [[User alloc] init];
    
    u1.username = @"Bess";
    u2.username = @"Ross";
    u3.username = @"Jacob";
    u4.username = @"Jamie";
    u5.username = @"Brock";
    
    u1.treesDestroyed = 51;
    u2.treesDestroyed = 32;
    u3.treesDestroyed = 25;
    u4.treesDestroyed = 12;
    u5.treesDestroyed = 5;


    u1.milesBiked = 51;
    u2.milesBiked = 32;
    u3.milesBiked= 25;
    u4.milesBiked = 12;
    u5.milesBiked = 5;
    
    u1.milesWalked = 51;
    u2.milesWalked = 32;
    u3.milesWalked= 25;
    u4.milesWalked = 12;
    u5.milesWalked = 5;
    
    currentArray = @[u1, u2, u3, u4, u5];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)didChangeTypeOfLeaderBoard:(id)sender {
//    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
//    if (segmentedControl.selectedSegmentIndex == 0) {
//        [self switchToCalories];
//    } else if(segmentedControl.selectedSegmentIndex == 1) {
//        [self switchToEmissions];
//    }
//
    NSLog(@"SWITCH");
    [self.tableView reloadData];
}

//-(void) switchToCalories {
//    
//    if ([calories count] <= 0) {
//        //get calories
//        
//    }
//    currentArray = calories;
//}
//
//-(void) switchToEmissions {
//    
//    if ([emissions count] <= 0) {
//        //get calories
//        
//    }
//    currentArray = emissions;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Current array %d", [currentArray count]);
    // Return the number of sections.
    return [currentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    User *user = [currentArray objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = user.username;
    
    if (sc.selectedSegmentIndex == 0) {
        NSInteger cals = [Route walkCals:user.milesWalked] + [Route bikeCals:user.bikeMpg andDistance:user.milesBiked];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Calories Burned", (long)cals];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Trees Saved", (long)user.treesDestroyed];
    }

    // Configure the cell...
    
    return cell;
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

@end
