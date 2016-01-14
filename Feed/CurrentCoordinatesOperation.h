//
//  CurrentCoordinatesOperation.h
//  Feed
//
//  Created by Adam on 1/14/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface CurrentCoordinatesOperation : NSOperation

@property (copy, nonatomic, readonly) NSArray *dependentOperations;
@property (copy, nonatomic, readonly) NSNumber *latitude, *longitude;

- (void) addOpDependency:(NSOperation *)op;
- (void)didBeginExecuting;
- (void)didFinishExecuting;
- (void)isReadyToBeginExecuting;

@end
