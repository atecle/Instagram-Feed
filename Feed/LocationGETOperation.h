//
//  LocationGETOperation.h
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "GETOperation.h"

@interface LocationGETOperation : GETOperation

@property (nonatomic, readonly) float latitude, longitude;
@property (copy, nonatomic, readonly) NSString *locationID;

- (void)setLatitude:(float)latitude;
- (void)setLongitude:(float)longitude;

@end
