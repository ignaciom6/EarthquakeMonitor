//
//  EarthquakesListTableViewController.m
//  EarthquakeMonitor
//
//  Created by Ignacio on 6/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import "EarthquakesListTableViewController.h"
#import "ConnectionManager.h"
#import "EarthquakeTableViewCell.h"

@interface EarthquakesListTableViewController () <EarthquakesNotifierDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary * earthquakesResponseDictionary;
@property (strong, nonatomic) NSArray * earthquakesArray;

@end

@implementation EarthquakesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[ConnectionManager sharedInstance] setNewDelegate:self];
    [[ConnectionManager sharedInstance] requestEarthquakes];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateList)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
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
    return [self.earthquakesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarthquakeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarthquakeCell" forIndexPath:indexPath];
    
    [cell setRegionNameWhithName:[[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey: @"region"]];
    [cell setEarthquakeDateWithDate:[[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey:@"timedate"]];
    [cell setEarthquakeScaleWithScale:[[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey:@"magnitude"]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)updateList
{
    [[ConnectionManager sharedInstance] requestEarthquakes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Notifications

-(void)notifyRequestSuccessWithDictionary:(NSDictionary *)dictionaryOfEarthquakes
{
    self.earthquakesResponseDictionary = dictionaryOfEarthquakes;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    
    for(NSDictionary * earthquakes in self.earthquakesResponseDictionary)
    {
        [data addObject:earthquakes];
    }
    
    self.earthquakesArray = data;
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)notifyRequestErrorWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Error retrieving earthquakes"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okButton];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
