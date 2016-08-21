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
    if (scale == 9)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor redColor];
    }
    else if (scale >= 7)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor colorWithRed:(254/255.0) green:(198/255.0) blue:(1/255.0) alpha:1];
    }
    else if (scale >= 5)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor colorWithRed:(122/255.0) green:(254/255.0) blue:(145/255.0) alpha:1];
    }
    else if (scale >= 2)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor colorWithRed:(176/255.0) green:(211/255.0) blue:(253/255.0) alpha:1];
    }
    else
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor colorWithRed:(234/255.0) green:(234/255.0) blue:(234/255.0) alpha:1];
    }
}

@end
