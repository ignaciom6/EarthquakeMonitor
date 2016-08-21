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
#import "EarthquakeMapViewController.h"

@interface EarthquakesListTableViewController ()
<EarthquakesNotifierDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) NSDictionary * earthquakesResponseDictionary;
@property (strong, nonatomic) NSArray * earthquakesArray;
@property (strong, nonatomic) NSString * earthquakeLatitude;
@property (strong, nonatomic) NSString * earthquakeLongitude;
@property (strong, nonatomic) NSString * earthquakeRegion;
@property (strong, nonatomic) NSString * earthquakeMagnitude;

@end

static NSString * const kListToMapSegue = @"ListToMapSegue";
static UIView *spinnerView = nil;
static int spinnerTag = 1;

@implementation EarthquakesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[ConnectionManager sharedInstance] setNewDelegate:self];
    [[ConnectionManager sharedInstance] requestEarthquakes];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateList)
                  forControlEvents:UIControlEventValueChanged];
    
    [self showLoading];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EarthquakeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EarthquakeCell" forIndexPath:indexPath];
    
    NSDictionary * properties = [[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey:@"properties"];
    
    [cell setRegionNameWhithName:[self obtainPlaceFromDictionary:properties]];
    [cell setEarthquakeDateWithDate:[self obtainDateFromDictionary:properties]];
    [cell setEarthquakeScaleWithScale:[self obtainMagnitudeFromDictionary:properties]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * properties = [[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey:@"properties"];
    NSDictionary * geometry = [[self.earthquakesArray objectAtIndex:indexPath.row] objectForKey:@"geometry"];
    NSArray * longAndLat = [geometry objectForKey:@"coordinates"];
    
    NSNumber * doubleMagnitude = [NSNumber numberWithDouble:[self obtainMagnitudeFromDictionary:properties]];
    NSString * magnitude = [doubleMagnitude stringValue];
    
    self.earthquakeLatitude = [longAndLat objectAtIndex:1];
    self.earthquakeLongitude = [longAndLat objectAtIndex:0];
    self.earthquakeRegion = [self obtainPlaceFromDictionary:properties];
    self.earthquakeMagnitude = magnitude;
    
    [self performSegueWithIdentifier:kListToMapSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)updateList
{
    [[ConnectionManager sharedInstance] requestEarthquakes];
}

-(void)showLoading
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    spinner.tag = spinnerTag;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

-(void)hideLoading
{
    [[self.view viewWithTag:spinnerTag] stopAnimating];
}

-(NSString *)obtainPlaceFromDictionary: (NSDictionary*) propertiesDictionary
{
    NSString * place = [[NSString alloc] init];
    place = [propertiesDictionary objectForKey:@"place"];
    return place;
}

-(double)obtainMagnitudeFromDictionary: (NSDictionary*) propertiesDictionary
{
    double mag;
    mag = [[propertiesDictionary objectForKey:@"mag"] doubleValue];
    return mag;
}

-(NSString *)obtainDateFromDictionary: (NSDictionary*) propertiesDictionary
{
    NSString * epochTime;
    epochTime = [propertiesDictionary objectForKey:@"time"];
    NSTimeInterval seconds = [epochTime doubleValue] / 1000;
    
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    
    NSString * dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterLongStyle];
    return dateString;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:kListToMapSegue])
    {
        EarthquakeMapViewController *vc = (EarthquakeMapViewController*)segue.destinationViewController;
        
        [vc setCustomLatitudeWithLatitude:self.earthquakeLatitude];
        [vc setCustomLongitudeWithLongitude:self.earthquakeLongitude];
        [vc setRegionWithRegion:self.earthquakeRegion];
        [vc setMagnitudeWithMagnitude:self.earthquakeMagnitude];
        
    }
}


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
    
    [self hideLoading];
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
    
    [self hideLoading];
}

@end
