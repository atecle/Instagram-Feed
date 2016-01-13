//
//  LocationGETOperation.m
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "LocationGETOperation.h"

@implementation LocationGETOperation


- (instancetype) initWithClient:(APIClient *)client
{
    return [super initWithClient:client];
}

- (void)main
{
    [self.client requestLocationIDWithLatitude:self.latitude longitude:self.longitude success:^(NSString *locationID) {
         
        _locationID = locationID;
        [self didFinishExecuting];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [self didBeginExecuting];
}

- (void)setLatitude:(float)latitude
{
    _latitude = latitude;
}

- (void)setLongitude:(float)longitude
{
    _longitude = longitude;
}

@end
