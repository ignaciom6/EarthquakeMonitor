//
//  ConnectionManager.m
//  EarthquakeMonitor
//
//  Created by Ignacio on 7/5/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

#import "ConnectionManager.h"
#import "AFNetworking.h"

@interface ConnectionManager()

@property (nonatomic, strong) NSMutableDictionary * earthquakesDictionary;

@end

static NSString * const kBaseUrl = @"http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=20";

@implementation ConnectionManager

+ (id)sharedInstance {
    static ConnectionManager *sharedConnectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnectionManager = [[self alloc] init];
    });
    return sharedConnectionManager;
}

- (id)init {
    if (self = [super init])
    {
        _earthquakesDictionary = nil;
    }
    return self;
}

- (void) setNewDelegate:(id)newDelegate
{
    self.delegate = newDelegate;
}

- (void)requestEarthquakes
{
    NSURL *url = [NSURL URLWithString:kBaseUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             
             NSLog(@"JSON: %@", responseObject);
             
             self.earthquakesDictionary = [responseObject objectForKey:@"features"];
             
             if (self.delegate && [self.delegate respondsToSelector:@selector(notifyRequestSuccessWithDictionary:)])
             {
                 [self.delegate notifyRequestSuccessWithDictionary:self.earthquakesDictionary];
             }
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             
             if (self.delegate && [self.delegate respondsToSelector:@selector(notifyRequestErrorWithError:)])
             {
                 [self.delegate notifyRequestErrorWithError:error];
             }
             
         }];
    
}


@end
