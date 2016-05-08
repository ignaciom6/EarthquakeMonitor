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

-(void)setEarthquakeScaleWithScale:(NSString *)scale
{
    self.scaleLabel.text = scale;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *scaleNumber = [[NSNumber alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.decimalSeparator = @".";
    scaleNumber = [formatter numberFromString:scale];
    
    [self setEarthquakeIntensityColorForScale:scaleNumber];
}

-(void)setEarthquakeIntensityColorForScale:(NSNumber *)scale
{
    double compareScale = [scale doubleValue];
    
    if (compareScale > 7)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor redColor];
    }
    else if (compareScale > 5)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor orangeColor];
    }
    else if (compareScale > 3)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor greenColor];
    }
    else if (compareScale > 1)
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor blueColor];
    }
    else
    {
        self.earthquakeIntensityView.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
