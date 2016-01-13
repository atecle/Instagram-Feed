//
//  MediaFromLocationGETOperation.h
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "GETOperation.h"

@interface MediaFromLocationGETOperation : GETOperation

@property (copy, nonatomic, readonly) NSString *locationID;
@property (copy, nonatomic, readonly) NSArray *posts;

- (void)setLocationID:(NSString *)locationID;

@end
