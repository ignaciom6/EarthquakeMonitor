//
//  EarthquakeTableViewCell.h
//  EarthquakeMonitor
//
//  Created by Ignacio on 6/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthquakeTableViewCell : UITableViewCell

-(void)setRegionNameWhithName:(NSString *)region;
-(void)setEarthquakeDateWithDate:(NSString *)date;
-(void)setEarthquakeScaleWithScale:(NSString *)scale;

@end
