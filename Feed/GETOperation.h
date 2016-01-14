//
//  GETOperation.h
//  Feed
//
//  Created by Adam on 1/13/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"

@interface GETOperation : NSOperation

@property (strong, nonatomic, readonly) id JSON;
@property (strong, nonatomic, readonly) NSError *error;
@property (copy, nonatomic, readonly) NSArray *dependentOperations;
@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) APIClient *client;

- (instancetype) initWithClient:(APIClient *)client;
- (void) addOpDependency:(NSOperation *)op;
- (void)didBeginExecuting;
- (void)didFinishExecuting;
- (void)isReadyToBeginExecuting;

@end
