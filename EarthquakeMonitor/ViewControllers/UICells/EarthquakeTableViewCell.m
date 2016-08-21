//
//  EarthquakeTableViewCell.m
//  EarthquakeMonitor
//
//  Created by Ignacio on 6/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import "EarthquakeTableViewCell.h"

@interface EarthquakeTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *regionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *earthquakeIntensityView;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;


@end

@implementation EarthquakeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRegionNameWhithName:(NSString *)region
{
    self.regionNameLabel.text = region;
}

-(void)setEarthquakeDateWithDate:(NSString *)date
{
    self.dateLabel.text = date;
}

-(void)setEarthquakeScaleWithScale:(double)scale
{
    NSNumber * doubleNumber = [NSNumber numberWithDouble:scale];
    NSString * scaleValue = [doubleNumber stringValue];
    
    self.scaleLabel.text = scaleValue;
    
    [self setEarthquakeIntensityColorForScale:scale];
}

-(void)setEarthquakeIntensityColorForScale:(double)scale
{    
    if (scale > 7)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor redColor];
    }
    else if (scale > 5)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor orangeColor];
    }
    else if (scale > 3)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor greenColor];
    }
    else if (scale > 1)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor blueColor];
    }
    else
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
