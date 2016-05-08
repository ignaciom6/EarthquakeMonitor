//
//  EarthquakeMapViewController.m
//  EarthquakeMonitor
//
//  Created by Ignacio on 8/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import "EarthquakeMapViewController.h"

@interface EarthquakeMapViewController ()

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *magnitude;

@end

@implementation EarthquakeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    double latitude = [self.latitude doubleValue];
    double longitude = [self.longitude doubleValue];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(3, 3);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location, span);
    
    annotation.coordinate = location;
    [annotation setTitle:self.region];
    [annotation setSubtitle:self.magnitude];
    
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:mapRegion];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomLatitudeWithLatitude:(NSString *)latitude
{
    self.latitude = latitude;
}

-(void)setCustomLongitudeWithLongitude:(NSString *)longitude
{
    self.longitude = longitude;
}

-(void)setRegionWithRegion:(NSString *)region
{
    self.region = region;
}

-(void)setMagnitudeWithMagnitude:(NSString *)magnitude
{
    self.magnitude = magnitude;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
