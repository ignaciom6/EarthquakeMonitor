//
//  EarthquakeMapViewController.h
//  EarthquakeMonitor
//
//  Created by Ignacio on 8/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EarthquakeMapViewController : UIViewController
{
    MKMapView *mapView;
}

-(void)setCustomLatitudeWithLatitude:(NSString *)latitude;
-(void)setCustomLongitudeWithLongitude:(NSString *)longitude;
-(void)setRegionWithRegion:(NSString *)region;
-(void)setMagnitudeWithMagnitude:(NSString *)magnitude;

@end
