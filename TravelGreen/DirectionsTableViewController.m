//
//  DirectionsTableTableViewController.m
//  TravelGreen
//
//  Created by Bess Chan on 4/5/14.
//  Copyright (c) 2014 Hackathon. All rights reserved.
//

#import "DirectionsTableViewController.h"
#import "Route.h"

@interface DirectionsTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *directionCell;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DirectionsTableViewController {
    CLLocationCoordinate2D start_;
    CLLocationCoordinate2D end_;
}

@synthesize dataSource;

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
    self.navigationController.navigationBar.hidden = NO;
    //this.tableView.cell.
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void) saveStartLocation: (CLLocationCoordinate2D) start andEndLocation: (CLLocationCoordinate2D) end {
    start_ = start;
    end_ = end;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        Route *bus = [[Route alloc] init];
        bus.modeOfTransport = @"Public Transit";
        bus.travelTime = @"(1 hr 30 min)";
        bus.distance = 30;
        
        Route *bus2 = [[Route alloc] init];
        bus2.modeOfTransport = @"Walking";
        bus2.travelTime = @"(2 hr 5 min)";
        bus2.distance = .3;
        
        Route *bus3 = [[Route alloc] init];
        bus3.modeOfTransport = @"Cycling";
        bus3.travelTime = @"(2 hr 3 min)";
        bus3.distance = 3.5;
        
        [bus setFact];
        [bus2 setFact];
        [bus3 setFact];
        NSArray *array = [NSArray arrayWithObjects:bus, bus2, bus3, nil];
        self.dataSource = array;
    }
    return self;
}

- (void)setTableData:(NSMutableArray *)array
{
    self.dataSource = array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DirectionsTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DirectionsTableViewCell" owner:self options:nil];
        cell = self.directionCell;
        self.directionCell = nil;
    }
    Route *route = [dataSource objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *) [cell viewWithTag:1];
   
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:2];
    UITextView *textView = (UITextView *) [cell viewWithTag:3];
    UILabel *timeLbl = (UILabel *) [cell viewWithTag:4];

    timeLbl.text = route.travelTime;
    imageView.image = [UIImage imageNamed:@"yellow.png"];
    textView.text = route.energyFact;
    label.text = route.modeOfTransport;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource count];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return dataSource[(NSUInteger)indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
