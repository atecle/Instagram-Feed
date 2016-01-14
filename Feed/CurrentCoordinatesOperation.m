//
//  CurrentCoordinatesOperation.m
//  Feed
//
//  Created by Adam on 1/14/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "CurrentCoordinatesOperation.h"

@interface CurrentCoordinatesOperation() <CLLocationManagerDelegate>


@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isReady;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation CurrentCoordinatesOperation

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self isReadyToBeginExecuting];
    }
    
    return self;
}

- (void)main
{
    [self didBeginExecuting];
    _locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    //Something is fucked up and the delegate method isn't being called,  continuing for now so I can make progress.
    [self didFinishExecuting];
    
}

- (void) addOpDependency:(NSOperation *)op
{
    [self addDependency:op];
    _dependentOperations = [self.dependentOperations arrayByAddingObject:op];
}


- (void)didFinishExecuting
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _isFinished = YES;
    _isExecuting = NO;
    
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)didBeginExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    
    _isExecuting = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)isReadyToBeginExecuting
{
    [self willChangeValueForKey:@"isReady"];
    
    _isReady = YES;
    
    [self didChangeValueForKey:@"isReady"];
}

- (void)setLatitude:(NSNumber *)latitude
{
    _latitude = latitude;
}


- (void)setLongitude:(NSNumber *)longitude
{
    _longitude = longitude;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    
    NSNumber *latitude = [NSNumber numberWithFloat: location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat: location.coordinate.longitude];
    
    [self setLatitude:latitude];
    [self setLongitude:longitude];
    
    [self didFinishExecuting];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}


@end
