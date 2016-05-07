//
//  ConnectionManager.h
//  EarthquakeMonitor
//
//  Created by Ignacio on 7/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EarthquakesNotifierDelegate <NSObject>

-(void)notifyRequestSuccessWithDictionary:(NSDictionary *)dictionaryOfEarthquakes;
-(void)notifyRequestErrorWithError:(NSError *)error;

@end


@interface ConnectionManager : NSObject

@property (strong, nonatomic) id<EarthquakesNotifierDelegate> delegate;

+(id)sharedInstance;
-(void)setNewDelegate:(id)newDelegate;
-(void)requestEarthquakes;

@end
